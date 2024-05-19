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

        // Creation of orders
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(testAccounts);
        
        // Creation of a test product
        Product2 testProduct = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Creation of a pricebook entry for the product
        PricebookEntry testPricebookEntry = TestDataFactory.createPricebookEntry(testProduct, 100.0);

        // Creation of order items for each order
        List<OrderItem> testOrderItems = TestDataFactory.createOrderItems(testOrders, testPricebookEntry.Id, 1, 100.0); 
        
        // Update orders to Ordered status
        for(Order ord : testOrders) {
            ord.Status = 'Ordered';
        }
        update testOrders;
    }

    // This test the UpdateAccountsBatch class by creating test data, executing the batch job, and then verifying that the Chiffre_d_affaire__c field has been updated or calculated correctly based on the corresponding order item's price (100.0).
    @isTest static void testUpdateAccountsBatch() {
        // Query for the test data created in the setup method
        List<Account> testAccounts = [SELECT Id FROM Account];
        List<Order> testOrders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :testAccounts];
        List<OrderItem> testOrderItems = [SELECT Id, OrderId, UnitPrice FROM OrderItem WHERE OrderId IN :testOrders];

        // Start the test
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();

        // Query for the updated data
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];

        // Perform assertions to verify that the batch job worked as expected
        for (Account acc : updatedAccounts) {
            // Find the corresponding OrderItem for this Account
            OrderItem correspondingOrderItem = null;
            for (OrderItem oi : testOrderItems) {
                if (oi.OrderId == acc.Id) {
                    correspondingOrderItem = oi;
                    break;
                }
            }

            // If we found a corresponding OrderItem, assert that the Chiffre_d_affaire__c field has been updated to the OrderItem's price
            if (correspondingOrderItem != null) {
                System.assertEquals(correspondingOrderItem.UnitPrice, acc.Chiffre_d_affaire__c, 'The Chiffre_d_affaire__c field should have been updated to the OrderItem\'s price');
            }
        }
    }

    @isTest
    static void testExecuteCalculatesTurnoverCorrectly() {
        // Obtener las cuentas y las órdenes de la base de datos
        List<Account> testAccounts = [SELECT Id FROM Account];
        List<Order> testOrders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :testAccounts];    
    
        // Iniciar el trabajo en lotes
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
    
        // Verificar que la cifra de negocios se calculó correctamente
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        for(Account acc : updatedAccounts) {
            System.assertEquals(100.0, acc.Chiffre_d_affaire__c, 'La cifra de negocios no se calculó correctamente para la cuenta: ' + acc.Id);
        }
    }
}    
