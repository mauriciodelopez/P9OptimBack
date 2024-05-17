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

    /**
     * Method to create a Product
     * @param name Name of the product
     * @param description Description of the product
     * @param productCode Product code
     * @param isActive Activation status of the product
     * @param pricebook2Id Id of the Pricebook associated with the product
     * @return The created Product
     **/
    public static Product2 createProduct(String name, String description, String productCode, Boolean isActive, Id pricebook2Id) {
        Product2 p = new Product2();
        p.Name = name;  
        p.Description = description;
        p.ProductCode = productCode;
        p.IsActive = isActive;
        
        // If a Pricebook2Id is provided, associate the product with it by creating a PricebookEntry
        if (pricebook2Id != null) {
            // Create a PricebookEntry for the product
            PricebookEntry pbEntry = createPricebookEntry(p.Id, pricebook2Id);
        }

        return p;     
    }

    /**
     * Overloaded createProduct method without the pricebook2Id parameter
     * Creates a Product using the Standard Pricebook
     **/
    public static Product2 createProduct(String name, String description, String productCode, Boolean isActive) {
        // Get the ID of the Standard Pricebook
        Id pricebook2Id = Test.getStandardPricebookId();
        return createProduct(name, description, productCode, isActive, pricebook2Id);
    }    

    /**
     * Method to create a Pricebook entry for a Product
     * @param productId Id of the Product associated with the Pricebook entry
     * @param pricebook2Id Id of the Pricebook associated with the Pricebook entry
     * @return The created Pricebook entry
     **/
               
            return standardPrice;
        }
        return existingEntry;
    }

    /**
     * Method to create an Account
     * @param i Index for creating unique Account names
     * @return The created Account
     **/
    public static Account createAccount(Integer i) {
        Account acc = new Account(
            Name = 'SFDCPanther.com' + i,// Added index to name to ensure uniqueness
            Rating = 'Hot',
            Industry = 'Banking',
            Phone = '9087654321'
        );
        return acc;
    }

    /**
     * Method to create a list of Accounts
     * @param numAccounts Number of accounts to create
     * @return List of created Accounts
     **/
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = createAccount(i);
            accounts.add(acc);
        }
        return accounts;
    }

    /**
     * Method to create an Order
     * @param accountId Id of the Account associated with the Order
     * @return The created Order
     **/
    public static Order createOrder(Id accountId) {
        Order order = new Order(
            AccountId = accountId,
            EffectiveDate = System.today(),
            Status = 'Draft',
            PriceBook2Id = Test.getStandardPricebookId()
        );
        return order;
    }

    /**
     * Method to create an Order Item
     * @param orderId Id of the Order associated with the Order Item
     * @param productId Id of the Product associated with the Order Item
     * @param pricebookEntryId Id of the Pricebook Entry associated with the Order Item
     * @param quantity Quantity of the Order Item
     * @param unitPrice Unit price of the Order Item
     * @return The created Order Item
     **/
    public static OrderItem createOrderItem(Id orderId, Id productId, Id pricebookEntryId, Decimal quantity, Decimal unitPrice) {
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = orderId;
        lineItem.Quantity = quantity;
        lineItem.UnitPrice = unitPrice;
        lineItem.Product2id = productId;
        lineItem.PricebookEntryId = pricebookEntryId;
        return lineItem;
    }

    /**
     * Method to create Orders for a list of Accounts
     * @param accounts List of Accounts for which Orders need to be created
     * @param numOrdersPerAccount Number of Orders to create for each Account
     * @return List of created Orders
     **/
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
    
    /**
     * Method to activate an Order
     * @param orderId Id of the Order to activate
     * @return The activated Order
     **/
    public static Order activateOrder(Id orderId) {
        Order order = [SELECT Id, Status FROM Order WHERE Id = :orderId];
        order.Status = 'Activated';
        return order;
    }

    /**
     * Method to get Orders organized by Sales Representative
     * @return Map with Orders grouped by Sales Representative Id
     **/
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

    /**
     * Method to create Order Items for a list of Accounts
     * @param accounts List of Accounts for which Order Items need to be created
     * @param itemsPerAccount Number of Order Items to create for each Account
     **/
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
