/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {
    public class TestDataFactoryException extends Exception {}

    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account(Name = 'Test Account ' + i, Chiffre_d_affaire__c = 0);
            accounts.add(acc);
        }
        insert accounts;    
        return accounts;
    }

    //Method to create products for test orders
    public static Product2 createProduct(String name, String family) {
        Product2 pd = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert chemiseVerte;
        return chemiseVerte;
    }

    //Method to create a pricebook entry for test products
    public static List<PricebookEntry> createPricebookEntry(products, unitPrice)(List<Product2> products, Decimal unitPrice) {
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for(Product2 product : products) {
            PricebookEntry pricebook = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = unitPrice,
            IsActive = true
            );
            pricebookEntries.add(pricebook);
        }
        insert pricebookEntries;
        return pricebookEntries;

    }

    
    public static Order createOrder(Id accountId, String orderStatus) {
        Order order = new Order(
            AccountId = accountId,
            EffectiveDate = System.today(),
            Status = orderStatus,
            PriceBook2Id = Test.getStandardPricebookId()
        );
        insert order;
        return order;
    }
    
    public static List<OrderItem> createOrderItems(List<Id> orderIds, List<Id> productIds, List<Id> pricebookEntryIds, List<Decimal> quantities, List<Decimal> unitPrices) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for(Integer i = 0; i < orderIds.size(); i++) {
            OrderItem lineItem = new OrderItem();
            lineItem.OrderId = orderIds[i];
            lineItem.Quantity = quantities[i];
            lineItem.UnitPrice = unitPrices[i];
            lineItem.Product2Id = productIds[i];
            lineItem.PricebookEntryId = pricebookEntryIds[i];
            orderItems.add(lineItem);
        }
        insert orderItems;
        return orderItems;
    }

    public static List<OrderItem> createOrderItemsSpecOrders(List<Order> orders, Id productId, Id pricebookEntryId, Decimal quantity, Decimal unitPrice) {
        List<Id> orderIds = new List<Id>();
        for (Order ord : orders) {
            orderIds.add(ord.Id);
        }
        return createOrderItems(orderIds, new List<Id>{productId}, new List<Id>{pricebookEntryId}, new List<Decimal>{quantity}, new List<Decimal>{unitPrice});
    }

    public static List<Order> createOrdersForAccounts(List<Account> accounts) {
        List<Order> orders = new List<Order>();
        Map<Id, Id> pricebook2IdToEntryId = new Map<Id, Id>();
    
        // Obtener todos los PricebookEntryId necesarios
        for (PricebookEntry entry : [SELECT Id, Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id = :Test.getStandardPricebookId()]) {
            pricebook2IdToEntryId.put(entry.Pricebook2Id, entry.Id);
        }
    
        for(Account acc : accounts) {
            Order order = new Order(
                AccountId = acc.Id,
                EffectiveDate = System.today(),
                Status = 'Draft',
                PriceBook2Id = Test.getStandardPricebookId()
            );
            orders.add(order);
        }
    
        // Insertar todas las órdenes a la vez
        insert orders;
    
        // Crear OrderItems para cada Order
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order ord : orders) {
            OrderItem item = new OrderItem(
                OrderId = ord.Id,
                UnitPrice = 100.00,
                Quantity = 1,
                PricebookEntryId = pricebook2IdToEntryId.get(ord.PriceBook2Id)
            );
            orderItems.add(item);
        }
    
        // Insertar todos los OrderItems a la vez
        insert orderItems;
    
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

}
