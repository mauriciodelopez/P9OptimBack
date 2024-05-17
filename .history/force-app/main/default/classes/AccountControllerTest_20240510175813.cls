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
        List<Account> accounts = TestDataFactory.createAccounts(200);
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
        Account acc = testDataFactory.createAccount('Test Account');
        Product2 testProduct = testDataFactory.createProduct('Test Product', 'Test Product');
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = testDataFactory.createPricebookEntry(pricebookId, testProduct.Id, 100);
    
        Order ord = testDataFactory.createOrder(acc.Id, 'Draft', testProduct.Id, 1);
    
        List<OrderItem> orderItems = testDataFactory.createOrderItems(ord.Id, standardPrice.Id, 2);
        Decimal expectedCA = 0;
        for (OrderItem oi : orderItems) {
        expectedCA += oi.TotalPrice;
        }
    
        Test.startTest();
        ord.Status = 'Activated';
        update ord;
        Test.stopTest();
    
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(expectedCA, acc.Chiffre_d_affaire__c, 'Account Chiffre_d_affaire__c should be updated with the total value of the order');
    }

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
        System.assertEquals(200.0, updatedAccounts[0].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the first account should be 200.0');
    }    

}