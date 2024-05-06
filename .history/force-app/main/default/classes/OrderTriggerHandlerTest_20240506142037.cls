/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class OrderTriggerHandlerTest {
    @isTest
    static void testBeforeUpdate() {
        // Prepare test data
        Order testOrder = TestDataFactory.createOrderWithProduct('Test Product', 'ABC', 1, 100.00);
        testOrder.ShipmentCost__c = 10.00;
        testOrder.TotalAmount = 100.00;
        update testOrder;

        // Query the updated order
        Order updatedOrder = [SELECT Id, NetAmount__c FROM Order WHERE Id = :testOrder.Id];

        // Assert that the NetAmount__c field has been correctly calculated
        System.assertEquals(90.00, updatedOrder.NetAmount__c, 'The NetAmount__c was not calculated correctly.');
    }

    @isTest
    static void testAfterUpdate() {
        // Prepare test data
        Order testOrder = TestDataFactory.createOrderWithProduct('Test Product', 'ABC', 1, 100.00);
        testOrder.Status = 'Draft';
        update testOrder;

        // Change the status to 'Ordered' and update the order
        testOrder.Status = 'Ordered';
        update testOrder;

        // Query the updated order and related account
        Order updatedOrder = [SELECT Id, AccountId, Status FROM Order WHERE Id = :testOrder.Id];
        Account relatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :updatedOrder.AccountId];

        // Assert that the Chiffre_d_affaire__c field has been correctly updated
        System.assertEquals(100.00, relatedAccount.Chiffre_d_affaire__c, 'The Chiffre_d_affaire__c was not updated correctly.');
    }
}