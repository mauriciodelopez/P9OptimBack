/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {
    
    // Method to create accounts from Accounts objet Salesforce
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            acc.Id = null;
            accounts.add(acc);
        }
        insert accounts;    
        return accounts;
    }

    // Method to create order for test accounts 
    public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer numOrdersPerAccount) {
        List<Order> orders = new List<Order>();
        for(Account acc : accounts) {
            
            Order ord = new Order(AccountId = acc.Id, EffectiveDate = Date.today(), Status = 'Draft', Pricebook2Id = Test.getStandardPricebookId());
            orders.add(ord);
        }
        insert orders;
        return orders;
    }

    //Method to create products for test orders
    public static Product2 createProduct(String name, String family) {
        Product2 prod = new Product2(Name = name, Family = family);
        insert prod;
        return prod;
    }

    // Method to create a pricebookentry for a product
    public static PricebookEntry createPricebookEntry(Product2 product, Decimal unitPrice) {
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = unitPrice,
            IsActive = true
        );
        insert pbe;
        return pbe;
    }
    //Method to create a order for a account
    public static Order createOrder(Id accountId, String orderStatus) {
        Order order = new Order(
            AccountId = accountId,
            EffectiveDate = System.today(),
            Status = orderStatus,
            PriceBook2Id = Test.getStandardPricebookId()
        );
        //insert order;
        return order;
    }
    

    // Method to create a OrderItem for each order
    public static List<OrderItem> createOrderItems(List<Order> orders, Id pricebookEntryId, Integer quantity, Decimal unitPrice) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for(Order ord : orders) {
            OrderItem oi = new OrderItem(OrderId = ord.Id, PricebookEntryId = pricebookEntryId, Quantity = quantity, UnitPrice = unitPrice);
            orderItems.add(oi);
        }
        insert orderItems;
        return orderItems;
    }
    
}