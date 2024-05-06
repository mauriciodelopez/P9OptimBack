/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {
    public static Product2 createProduct(String name = 'Test Product', String description = 'Test Product', String productCode = 'ABC', Boolean isActive = true) {
        Product2 p = new Product2();
        p.Name = name;
        p.Description = description;
        p.productCode = productCode;
        p.isActive = isActive;
        insert p;
        return p;    
    }

    public static PricebookEntry createPricebookEntry(Id productId) {
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = productId;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice;
        return standardPrice;
    }

    public static Account createAccount() {
        Account acc = new Account(
            Name = 'SFDCPanther.com',
            Rating = 'Hot',
            Industry = 'Banking',
            Phone = '9087654321'
        );
        insert acc;
        return acc;
    }

    public static Order createOrder(Id accountId) {
        Order order = new Order(
            AccountId = accountId,
            EffectiveDate = System.today(),
            Status = 'Draft',
            PriceBook2Id = Test.getStandardPricebookId()
        );
        insert order;
        return order;
    }

    public static OrderItem createOrderItem(Id orderId, Id productId, Id pricebookEntryId) {
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = orderId;
        lineItem.Quantity = 24;
        lineItem.UnitPrice = 240;
        lineItem.Product2id = productId;
        lineItem.PricebookEntryId = pricebookEntryId;
        insert lineItem;
        return lineItem;
    }

    public static Order activateOrder(Id orderId) {
        Order order = [SELECT Id, Status FROM Order WHERE Id = :orderId];
        order.Status = 'Activated';
        update order;
        return order;
    }
}