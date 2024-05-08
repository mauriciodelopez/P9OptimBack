/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {
    public static Product2 createProduct(String name, String description, String productCode, Boolean isActive) {
        Product2 p = new Product2();
        p.Name = name;
        p.Description = description;
        p.productCode = productCode;
        p.isActive = isActive;
        //insert p;
        return p;    
    }

    public static Product2 createProduct() {
        return createProduct('Test Product', 'Test Product', 'ABC', true);
    }    

    public static PricebookEntry createPricebookEntry(Id productId) {
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = productId;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        //insert standardPrice;
        return standardPrice;
    }

    public static Account createAccount(Integer i) {
        Account acc = new Account(
            Name = 'SFDCPanther.com' + i,// Added index to name to ensure uniqueness
            Rating = 'Hot',
            Industry = 'Banking',
            Phone = '9087654321'
        );
        //insert acc;
        return acc;
    }

    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = createAccount(i);
            accounts.add(acc);
        }
        insert accounts;//Insert all accounts at once 
        return accounts;
    }

    public static Order createOrder(Id accountId) {
        Order order = new Order(
            AccountId = accountId,
            EffectiveDate = System.today(),
            Status = 'Draft',
            PriceBook2Id = Test.getStandardPricebookId()
        );
        //insert order;
        return order;
    }

    public static OrderItem createOrderItem(Id orderId, Id productId, Id pricebookEntryId, Decimal quantity, Decimal unitPrice) {
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = orderId;
        lineItem.Quantity = quantity;
        lineItem.UnitPrice = unitPrice;
        lineItem.Product2id = productId;
        lineItem.PricebookEntryId = pricebookEntryId;
        //insert lineItem;
        return lineItem;
    }

    public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer numOrdersPerAccount, Decimal orderAmount) {
        List<Order> orders = new List<Order>();
        for(Account acc : accounts) {
            for(Integer i = 0; i < numOrdersPerAccount; i++) {
                Order ord = createOrder(acc.Id); // Assuming createOrder creates an order with a specified accountId
                // Set order amount here if necessary
                orders.add(ord);
            }
        }

        insert orders;
        return orders;
    }

    public static Order activateOrder(Id orderId) {
        Order order = [SELECT Id, Status FROM Order WHERE Id = :orderId];
        order.Status = 'Activated';
        update order;
        return order;
    }

    public static Map<Id, List<Order>> getOrdersBySalesRep() {
        // Create a Map to store the orders by sales representative
        Map<Id, List<Order>> ordersBySalesRep = new Map<Id, List<Order>>();
    
        // Get all orders for all sales representatives
        List<Order> allOrders = [SELECT Id, OrderNumber, Status, TotalAmount, OwnerId 
                                FROM Order 
                                WHERE OwnerId IN (SELECT Id FROM User WHERE UserType = 'Standard')];
    
        // Organize the orders by sales representative
        for (Order order : allOrders) {
            if (!ordersBySalesRep.containsKey(order.OwnerId)) {
                ordersBySalesRep.put(order.OwnerId, new List<Order>());
            }
            ordersBySalesRep.get(order.OwnerId).add(order);
        }
    
        // Return the Map
        return ordersBySalesRep;
    }

    public static List<Account> createMassiveAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = createAccount(i);
            accounts.add(acc);
        }
        insert accounts;
        return accounts;
    }

    public static void createOrderItemsForAccounts(List<Account> accounts, Integer itemsPerAccount) {
        Product2 product = createProduct('Test Product', 'Test Product', 'ABC', true);
        PricebookEntry pricebookEntry = createPricebookEntry(product.Id);
        List<OrderItem> orderItems = new List<OrderItem>();

        for(Account acc : accounts) {
            Order order = createOrder(acc.Id);
            for(Integer i = 0; i < itemsPerAccount; i++) {
                OrderItem orderItem = createOrderItem(order.Id, product.Id, pricebookEntry.Id, 1, 100);
                orderItems.add(orderItem);
            }
        }
        // Insert all objects at once
        insert new List<SObject>{product, orderItems;
    }

}