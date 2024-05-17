/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-17-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateAccountsBatchTest {
    @testSetup static void setup() {
        // Crear datos de prueba
        List<Account> testAccounts = TestDataFactory.createAccounts(5);
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(testAccounts, 'Ordered');

    }
    @isTest
    static void testBatchExecution() {
        // Obtener IDs de cuentas para verificar después
        List<Account> testAccounts = [SELECT Id FROM Account LIMIT 5];
        List<Id> accountIds = new List<Id>();
        for(Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }
        
        // Iniciar el trabajo en lotes
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        // Verificar que los datos se actualizaron correctamente
        List<Account> updatedAccounts = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(0, acc.Chiffre_d_affaire__c, 'El campo Chiffre_d_affaire__c no se actualizó correctamente para la cuenta: ' + acc.Name);
        }

    @isTest
    static void testExecuteCalculatesTurnoverCorrectly() {
        // Obtener las cuentas y las órdenes de la base de datos
        List<Account> testAccounts = [SELECT Id FROM Account];
        List<Order> testOrders = [SELECT Id, AccountId, TotalAmount FROM Order WHERE AccountId IN :testAccounts];

        // Asignar cantidades conocidas a las órdenes
        for(Order ord : testOrders) {
            ord.TotalAmount = 100.0;
        }
        update testOrders;
    
        // Iniciar el trabajo en lotes
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.QueryLocator ql = batchJob.start(null);
            Database.BatchableContext bc;
    batchJob.execute(bc, testAccounts);
    Test.stopTest();
    
    // Verificar que la cifra de negocios se calculó correctamente
    List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
    for(Account acc : updatedAccounts) {
        System.assertEquals(100.0, acc.Chiffre_d_affaire__c, 'La cifra de negocios no se calculó correctamente para la cuenta: ' + acc.Id);
    }
}




    }
    @isTest
    static void testBatchExecutionWithNoOrders() {
        // Obtener IDs de cuentas para verificar después
        List<Account> testAccounts = [SELECT Id FROM Account LIMIT 5];
        List<Id> accountIds = new List<Id>();
        for(Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }
        
        // Eliminar todas las órdenes asociadas con las cuentas de prueba
        List<Order> ordersToDelete = [SELECT Id FROM Order WHERE AccountId IN :accountIds];
        delete ordersToDelete;
        
        // Iniciar el trabajo en lotes
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        // Verificar que los datos se actualizaron correctamente
        List<Account> updatedAccounts = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds];
        for(Account acc : updatedAccounts) {
            System.assert(acc.Chiffre_d_affaire__c == 0 || acc.Chiffre_d_affaire__c == null, 'El campo Chiffre_d_affaire__c no debería haberse actualizado para la cuenta: ' + acc.Name);
        }
    }

    @isTest
    static void testBatchExecutionWithNoAccounts() {
        // Iniciar el trabajo en lotes
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        // Verificar que no se produjeron actualizaciones
        List<Account> updatedAccounts = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account WHERE Name = 'TestAccount'];
        System.assertEquals(0, updatedAccounts.size(), 'No se deberían haber producido actualizaciones en los registros de cuenta');
    }
}