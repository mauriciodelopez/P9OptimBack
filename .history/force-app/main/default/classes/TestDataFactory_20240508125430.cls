/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-08-2024
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
        insert p;
        //return p;  
        
        // Create a PricebookEntry for the product
        PricebookEntry pbEntry = createPricebookEntry(p.Id);
    
        return p;     
    }

    public static Product2 createProduct() {
        Id pricebookId = Test.getStandardPricebookId();
        return TestDataFactory.createProduct('Test Product', 'Test Product', 'ABC', true);
    }    

    public static PricebookEntry createPricebookEntry(Id productId) {

        //PricebookEntry existingEntry = [SELECT Id FROM PricebookEntry 
                                    //WHERE Product2Id = :productId 
                                    //LIMIT 1];
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = productId;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice;
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
        insert order;
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

    public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer numOrdersPerAccount) {
        List<Order> orders = new List<Order>();
        //List<OrderItem> orderItems = new List<OrderItem>();
        for(Account acc : accounts) {
            for(Integer i = 0; i < numOrdersPerAccount; i++) {
                Order ord = new Order(
                    AccountId = acc.Id,
                    EffectiveDate = System.today(),
                    Status = 'Draft',
                    Pricebook2Id = Test.getStandardPricebookId() // Remove semicolon
                );
                orders.add(ord); // Move the insertion of orders here to associate each order with a specific account
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
    //Methode qui fait la meme chose que createAccounts, il faut retirer cette methode
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
        List<Order> orders = new List<Order>();

        // Get the standard pricebook ID
        Id pricebookId = Test.getStandardPricebookId();

        

        //Creation d'orders
        orders = TestDataFactory.createOrdersForAccounts(accounts, 1);

    
            // Create the specified number of order items associated with the order
            // creation des orders Item, ajout de produits a chaque order
            for (Order order : orders) {

                OrderItem orderItem = createOrderItem(order.Id, product.Id, pricebookEntry.Id, 1, 120.00);

                orderItems.add(orderItem);
            }

            insert orderItems;    
    }

    @isTest
    public static void verifyUpdatedAccounts() {
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(0, acc.Chiffre_d_affaire__c, 'Le chiffre d\'affaires du compte ' + acc.Name + ' n\'a pas été mis à jour.');
        }
    
        Integer numUpdatedAccounts = [SELECT COUNT() FROM Account WHERE Chiffre_d_affaire__c > 0];
        System.assertEquals(200, numUpdatedAccounts, 'Le nombre de comptes mis à jour est incorrect.');
    }

}