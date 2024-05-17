/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {
    public class TestDataFactoryException extends Exception {}

    //Method to create products for test orders
    public static Product2 createProduct() {
        Product2 chemiseVerte = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert chemiseVerte;
        return chemiseVerte;
    }

    //Method to create a pricebook entry for test products
    public static PricebookEntry createPricebookEntry(Product2 chemiseVerte) {
        PricebookEntry pricebook = new PricebookEntry(
        Pricebook2Id = Test.getStandardPricebookId(),
        Product2Id = chemiseVerte.Id,
        UnitPrice = 1020,
        IsActive = true
        );
        insert pricebook;
        return pricebook;
    }

    public static List<Id> getStandardPricebookId() {
        List<Id> pricebookIds = new List<Id>();
        for (Pricebook2 pb : [SELECT Id FROM Pricebook2 WHERE IsStandard = true]) {
            pricebookIds.add(pb.Id);
        }
        return pricebookIds;
    }


    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account(Name = 'Test Account ' + i, Chiffre_d_affaire__c = 0);
            accounts.add(acc);
        }
        insert accounts;
        return accounts;
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

    public static List<Order> createOrdersForAccounts(List<Account> accounts) {
        List<Order> orders = new List<Order>();
        Map<Id, Id> pricebook2IdToEntryId = new Map<Id, Id>();
    
        // Obtener todos los PricebookEntryId necesarios
        for (PricebookEntry entry : [SELECT Id, Pricebook2Id FROM PricebookEntry WHERE Pricebook2Id IN :Test.getStandardPricebookId()]) {
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

    /**
     * Method to verify updated Accounts
     **/
    /*
    @isTest
    public static void verifyUpdatedAccounts() {
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(0, acc.Chiffre_d_affaire__c, 'Le chiffre d\'affaires du compte ' + acc.Name + ' n\'a pas été mis à jour.');
        }
    
        Integer numUpdatedAccounts = [SELECT COUNT() FROM Account WHERE Chiffre_d_affaire__c > 0];
        System.assertEquals(200, numUpdatedAccounts, 'Le nombre de comptes mis à jour est incorrect.');
    }

    public static void createOrderItemsForAccounts(List<Account> accounts, Integer itemsPerAccount) {
        
        // Create a product and a pricebook entry for the product
        Product2 product = createProduct('Test Product', 'Test Product', 'ABC', true);
        PricebookEntry pricebookEntry = createPricebookEntry(product.Id, Test.getStandardPricebookId());
    
        // Create a list to store the order items
        List<OrderItem> orderItems = new List<OrderItem>();
    
        // Get the standard pricebook ID
        Id pricebookId = Test.getStandardPricebookId();
    
        // Create orders for each account
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 1);
    
        // Create the specified number of order items associated with the order
        for (Order order : orders) {
            OrderItem orderItem = createOrderItem(order.Id, product.Id, pricebookEntry.Id, 1, 120.00);
            orderItems.add(orderItem);
        }
    }*/
}
