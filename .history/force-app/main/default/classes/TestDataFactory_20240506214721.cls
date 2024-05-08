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
        insert p;
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
        insert lineItem;
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
        return orders;
    }

    public static Order activateOrder(Id orderId) {
        Order order = [SELECT Id, Status FROM Order WHERE Id = :orderId];
        order.Status = 'Activated';
        update order;
        return order;
    }


    public static void createTeamOrdersTestData() {
        // Créer des commerciaux
        List<User> salesReps = createUsers(5);
    
        // Créer une liste pour stocker toutes les commandes
        List<Order> allOrders = new List<Order>();
    
        // Créer des comptes pour chaque commercial
        for (User salesRep : salesReps) {
            List<Account> accounts = createAccountsForUser(salesRep, 1);
    
            // Créer des commandes pour chaque compte
            List<Order> orders = createOrdersForAccounts(accounts, 3, 100);
    
            // Attribuer chaque commande au commercial
            for (Order order : orders) {
                order. = salesRep.Id;
                allOrders.add(order);
            }
        }
    
        // Mettre à jour les commandes avec l'ID du commercial en dehors de la boucle
        update allOrders;
    }


    public static List<Account> createAccountsForUser(User user, Integer numAccounts) {
        // Créer une liste pour stocker les accounts
        List<Account> accounts = new List<Account>();
    
        // Créer les accounts
        for (Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account(Name = 'Test Account ' + i, OwnerId = user.Id);
            accounts.add(acc);
        }
    
        // Insérer les accounts dans la base de données
        insert accounts;
    
        // Retourner la liste des accounts
        return accounts;
    }

}