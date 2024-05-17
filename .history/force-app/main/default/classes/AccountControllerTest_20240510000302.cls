/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(2);
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(product);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        TestDataFactory.createOrderItems(
            new List<Id>{orders[0].Id, orders[1].Id},
            new List<Id>{product.Id, product.Id},
            new List<Id>{pricebook.Id, pricebook.Id},
            new List<Decimal>{1, 2},
            new List<Decimal>{100, 200}
        );
    }

    @isTest
    static void testAccountsCreation() {
        List<Account> accounts = TestDataFactory.createAccounts(5);
        System.assertEquals(5, accounts.size(), 'Number of accounts created is incorrect');
        for(Account acc : accounts) {
            System.assertNotEquals(null, acc.Id, 'Account Id should not be null after insertion');
        }
    }

    @isTest
    static void testOrdersCreation() {
        List<Account> accounts = TestDataFactory.createAccounts(2);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        System.assertEquals(2, orders.size(), 'Number of orders created is incorrect');
        for(Order ord : orders) {
            System.assertNotEquals(null, ord.Id, 'Order Id should not be null after insertion');
        }
    }

    @isTest
    static void testProductCreation() {
        Product2 product = TestDataFactory.createProduct();
        System.assertNotEquals(null, product.Id, 'Product Id should not be null after insertion');
    }

    @isTest
    static void testPricebookCreation() {
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(product);
        System.assertNotEquals(null, pricebook.Id, 'PricebookEntry Id should not be null after insertion');
    }

    @isTest
    static void testOrderItemsCreation() {
        List<Account> accounts = TestDataFactory.createAccounts(2);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(product);
        List<OrderItem> orderItems = TestDataFactory.createOrderItems(
            new List<Id>{orders[0].Id, orders[1].Id},
            new List<Id>{product.Id, product.Id},
            new List<Id>{pricebook.Id, pricebook.Id},
            new List<Decimal>{1, 2},
            new List<Decimal>{100, 200}
        );
        System.assertEquals(2, orderItems.size(), 'Number of order items created is incorrect');
        for(OrderItem item : orderItems) {
            System.assertNotEquals(null, item.Id, 'OrderItem Id should not be null after insertion');
        }
    }

    @isTest
    static void testOrderValueUpdatesAccount() {
        // Setup
        List<Account> accounts = [SELECT Id FROM Account];
        Account account = accounts[0];
        List<Order> orders = [SELECT Id, AccountId FROM Order WHERE AccountId = :account.Id];
        Order order = orders[0];
        List<OrderItem> orderItems = [SELECT Id, OrderId, Quantity, UnitPrice FROM OrderItem WHERE OrderId = :order.Id];
        OrderItem orderItem = orderItems[0];
        Decimal orderItemQuantity = orderItem.Quantity;
        Decimal orderItemUnitPrice = orderItem.UnitPrice;

        // Test
        Test.startTest();
        AccountController controller = new AccountController();
        controller.updateAccountsWithOrderValue();
        Test.stopTest();

        // Assertions
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :account.Id];
        System.assertEquals(orderItemQuantity * orderItemUnitPrice, updatedAccount.Chiffre_d_affaire__c, 'Account Chiffre_d_affaire__c should be updated with the total value of the order');
    }
    /*
    @isTest
    static void testUpdateChiffreDAffaire() {
        // Récupérez les comptes créés dans la méthode de configuration
        List<Account> accounts = [SELECT Id FROM Account];

        // Commencez la partie du test qui est mesurée pour les limites de gouverneur
        Test.startTest();

        // Appellez la méthode updateChiffreDAffaire
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);

        // Arrêtez la partie du test qui est mesurée pour les limites de gouverneur
        Test.stopTest();

        // Récupérez les comptes mis à jour
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];

        // Vérifiez que le champ Chiffre_d_affaire__c a été correctement mis à jour
        System.assertEquals(100.0, updatedAccounts[0].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the first account should be 300.0');
        System.assertEquals(700.0, updatedAccounts[1].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the second account should be 700.0');
    }
    */

}