/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class OrderTriggerHandlerTest {
    @TestSetup static void setup(){
        // Create 200 test accounts
        List<Account> accounts = TestDataFactory.createAccounts(200);

        // Create an order test for each account
        List<Order> orders = new List<Order>();
        for(Account acc : accounts) {
            Order ord = TestDataFactory.createOrder(acc.Id, 'Draft');
            orders.add(ord);
        }
        insert orders;

        // Create a new product using the TestDataFactory utility class. 
        // The product has a name of 'Test Product' and belongs to the 'Test Family' product family.
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Create a new pricebook entry for the product we just created, also using the TestDataFactory utility class.
        // The pricebook entry sets the unit price of the product to 1.
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 1);

        // Using the TestDataFactory utility class, create order items for the orders.
        // The order items are associated with the pricebook entry identified by 'pbe.Id'.
        // Each order item has a quantity of 1 and a unit price of 100.
        TestDataFactory.createOrderItems(orders, pbe.Id, 1, 100);
    }
    //This test method is testing the before update trigger on the Order object. 
    //It verifies that when the ShipmentCost__c field is updated, the NetAmount__c field is recalculated correctly.
    @isTest static void testBeforeUpdate() {

        // Prepare test data.
        // Select an Account record.
        Account acc = [SELECT Id FROM Account LIMIT 1];

        // Select an Order record related to the Account.
        Order ord = [SELECT Id, ShipmentCost__c, NetAmount__c, TotalAmount FROM Order WHERE AccountId = :acc.Id LIMIT 1];
        
        // Update the Order to trigger the beforeUpdate code.
        // Start the test context.
        Test.startTest();
        // Set the ShipmentCost__c field to 10.
        ord.ShipmentCost__c = 10;
        // Update the Order record. This should trigger the beforeUpdate code that recalculates the NetAmount__c field.
        update ord;
        // Stop the test context.
        Test.stopTest();
        
        // Retrieve the updated Order record.
        ord = [SELECT NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id = :ord.Id];
        
        // Verify that the NetAmount__c field was calculated correctly.
        // The NetAmount__c field should be equal to the TotalAmount minus the ShipmentCost__c.
        System.assertEquals(ord.TotalAmount - ord.ShipmentCost__c, ord.NetAmount__c, 'NetAmount__c dont calculate correctly');
    }


    //This test method is testing the after update trigger on the Order object. 
    //It verifies that when the Status field of an Order is updated to 'Ordered', 
    //the Chiffre_d_affaire__c field on the related Account is updated to match the TotalAmount of the Order.
    @isTest static void testAfterUpdate() {
        // Prepare test data.
        // Select an Account record.
        Account acc = [SELECT Id FROM Account LIMIT 1];

        // Select an Order record related to the Account.
        Order ord = [SELECT Id, Status, TotalAmount FROM Order WHERE AccountId = :acc.Id LIMIT 1];

        
        // Update the Order to trigger the afterUpdate code.
        Test.startTest();
        // Set the Status field to 'Ordered'
        ord.Status = 'Ordered';
        // Update the Order record. This should trigger the afterUpdate code that updates the Chiffre_d_affaire__c field on the related Account.
        update ord;
        Test.stopTest();
        
        // Retrieve the updated Account record.
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        
        // Verify that the Chiffre_d_affaire__c field was updated correctly.
        // The Chiffre_d_affaire__c field on the Account should be equal to the TotalAmount of the Order.
        System.assertEquals(ord.TotalAmount, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c no se actualizó correctamente');
        System.assertNotEquals(0, );

    }
}