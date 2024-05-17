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
            Account acc = new Account(Name = 'Test Account ' + i);
            acc.Id = 
            accounts.add(acc);
        }
        insert accounts;    
        return accounts;
    }

    // Método para crear una orden para cada cuenta
    public static List<Order> createOrdersForAccounts(List<Account> accounts) {
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
        Product2 prod = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert prod;
        return prod;
    }

    // Método para crear una entrada de lista de precios para un producto
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
    

    // Método para crear un ítem de orden para cada orden
    public static List<OrderItem> createOrderItems(List<Order> orders, Id pricebookEntryId, Integer quantity, Decimal unitPrice) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for(Order ord : orders) {
            OrderItem oi = new OrderItem(OrderId = ord.Id, PricebookEntryId = pricebookEntryId, Quantity = quantity, UnitPrice = unitPrice);
            orderItems.add(oi);
        }
        insert orderItems;
        return orderItems;
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

    private static List<Id> getAccountIds(List<Account> accounts) {
        List<Id> accountIds = new List<Id>();
        for(Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        return accountIds;
    }


}
