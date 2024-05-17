/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateAccountsBatchTest {
    @testSetup static void setup() {
        // Crear datos de prueba
        List<Account> testAccounts = TestDataFactory.createAccounts(5);
        TestDataFactory.createOrdersForAccounts(testAccounts);
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
        List<Account> updatedAccounts = [SELECT Id, Name Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(0, acc.Chiffre_d_affaire__c, 'El campo Chiffre_d_affaire__c no se actualizó correctamente para la cuenta: ' + acc.Name);
        }
    }
}