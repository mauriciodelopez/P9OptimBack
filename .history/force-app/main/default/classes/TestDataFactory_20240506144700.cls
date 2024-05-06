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
        // Arrange
        Account acc = TestDataFactory.createAccount();
        Order order = TestDataFactory.createOrder(acc.Id);
        order.TotalAmount = 500;
        order.ShipmentCost__c = 100;
        
        // Act
        Test.startTest();
        order.TotalAmount = 600;
        update order;
        Test.stopTest();
        
        // Assert
        Order updatedOrder = [SELECT Id, NetAmount__c FROM Order WHERE Id = :order.Id];
        System.assertEquals(500, updatedOrder.NetAmount__c);
    }

    @isTest
    static void testAfterUpdate() {
        // Arrange
        Account acc = TestDataFactory.createAccount();
        Order order = TestDataFactory.createOrder(acc.Id);
        order.Status = 'Draft';
        order.TotalAmount = 500;
        update order;
        
        // Act
        Test.startTest();
        order.Status = 'Ordered';
        update order;
        Test.stopTest();
        
        // Assert
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(500, updatedAccount.Chiffre_d_affaire__c);
    }
}