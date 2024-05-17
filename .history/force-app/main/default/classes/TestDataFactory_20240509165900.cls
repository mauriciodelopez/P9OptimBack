/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-09-2024
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

    
    public static PricebookEntry createPricebookEntry(Product2 chemiseVerte) {
        List<PricebookEntry> entries = [SELECT Id, UnitPrice, IsActive FROM PricebookEntry WHERE Product2Id = :productId AND Pricebook2Id = :pricebook2Id LIMIT 1];
        PricebookEntry existingEntry = null;
        if (!entries.isEmpty()) {
            existingEntry = entries[0];
        }
        if (existingEntry != null) {
            // Modify necessary fields
            existingEntry.UnitPrice = 100; // Change newUnitPrice to the desired value
            existingEntry.IsActive = true; // Change newIsActive to the desired value
    
            // Update the PricebookEntry
            update existingEntry;
        } else {
            // If no existing PricebookEntry was found, create a new one
            PricebookEntry standardPrice = new PricebookEntry();
            standardPrice.Pricebook2Id = pricebook2Id;
            standardPrice.Product2Id = productId;
            standardPrice.UnitPrice = 100;
            standardPrice.IsActive = true;
            standardPrice.UseStandardPrice = false; 
            return standardPrice;
        }
        return existingEntry;
    }

    public static Account createAccount(Integer i) {
        Account acc = new Account(
            Name = 'SFDCPanther.com' + i,// Added index to name to ensure uniqueness
            Rating = 'Hot',
            Industry = 'Banking',
            Phone = '9087654321'
        );
        return acc;
    }

    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = createAccount(i);
            accounts.add(acc);
        }
        return accounts;
    }

    public static Order createOrder(Id accountId) {
        Order order = new Order(
            AccountId = accountId,
            EffectiveDate = System.today(),
            Status = 'Draft',
            PriceBook2Id = Test.getStandardPricebookId()
        );
        return order;
    }

    public static OrderItem createOrderItem(Id orderId, Id productId, Id pricebookEntryId, Decimal quantity, Decimal unitPrice) {
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = orderId;
        lineItem.Quantity = quantity;
        lineItem.UnitPrice = unitPrice;
        lineItem.Product2id = productId;
        lineItem.PricebookEntryId = pricebookEntryId;
        return lineItem;
    }

    public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer numOrdersPerAccount) {
        List<Order> orders = new List<Order>();
        for(Account acc : accounts) {
            for(Integer i = 0; i < numOrdersPerAccount; i++) {
                Order ord = new Order(
                    AccountId = acc.Id,
                    EffectiveDate = System.today(),
                    Status = 'Draft',
                    Pricebook2Id = Test.getStandardPricebookId()
                );
                orders.add(ord); // Move the insertion of orders here to associate each order with a specific account
            }
        }
        return orders;
    }
    
    public static Order activateOrder(Id orderId) {
        Order order = [SELECT Id, Status FROM Order WHERE Id = :orderId];
        order.Status = 'Activated';
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
    }
}
