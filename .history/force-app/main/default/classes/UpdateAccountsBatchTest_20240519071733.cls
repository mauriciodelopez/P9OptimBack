/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateAccountsBatchTest {
    @testSetup static void setup() {
        // Creation of test data
        // Creation a list of test accounts 
        List<Account> testAccounts = TestDataFactory.createAccounts(5);
        
        Product2 testProduct = TestDataFactory.createProduct('Test Product', 'Test Family');
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(testAccounts);
        // Actualizar las órdenes al estado 'Ordered'
        for(Order ord : testOrders) {
            ord.Status = 'Ordered';
        }
        update testOrders;
        // Crear una linea de pedido para cada orden con un precio total de 100
        List<OrderItem> orderItems = TestDataFactory.createOrderItems(testOrders, testProduct.Id, 1, 100);
    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Obtenir les accounts qui vont servir au test
        List<Account> testAccounts = [SELECT Id FROM Account];

        // Initier le test en créant une instance du batch et en appelant la méthode UpdteAccountsBatch
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();

        //Vérifier que le champ Chiffre_d_affaire__c c'est actualisé correctement
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        for (Account acc : updatedAccounts) {
            System.assertEquals(100, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c devrait être égal à 100');
        }
    }
    /*
    @isTest
    static void testBatchExecution() {
        // Obtener IDs de cuentas para verificar después
        Set<Id> accountIdsSet = new Map<Id, Account>([SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]).keySet();
        List<Id> accountIds = new List<Id>(accountIdsSet);

                
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
    }
    */

    @isTest
    static void testExecuteCalculatesTurnoverCorrectly() {
        // Obtener las cuentas y las órdenes de la base de datos
        List<Account> testAccounts = [SELECT Id FROM Account];
        List<Order> testOrders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :testAccounts];    
    
        // Crear un producto
            Product2 product = new Product2(Name = 'Test Product', IsActive = true);
        insert product;

        // Crear una entrada de lista de precios para el producto
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100.0);

        // Crear una lista para recoger los OrderItems
        List<OrderItem> itemsToInsert = new List<OrderItem>();

        // Asignar cantidades conocidas a las órdenes
        for(Order ord : testOrders) {
            // Crear un OrderItem para la orden
            OrderItem item = new OrderItem(
            OrderId = ord.Id,
            UnitPrice = 100.0,
            Quantity = 1,
            PricebookEntryId = pbe.Id
            );
            // Añadir el OrderItem a la lista
            itemsToInsert.add(item);
        }
        
        // Insertar todos los OrderItems a la vez
        insert itemsToInsert;

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
