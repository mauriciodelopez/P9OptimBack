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
        Account acc = testDataFactory.createAccounts(numAccounts);('Test Account');
        Product2 testProduct = testDataFactory.createProduct();('Test Product', 'Test Product');
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = testDataFactory.createPricebookEntry(chemiseVerte)(pricebookId, testProduct.Id, 100);
    
        Order order = testDataFactory.createOrder(accountId)(acc.Id, pricebookId, 'Draft', testProduct.Id);
        List<OrderItem> orderItems = testDataFactory.createOrderItems(order.Id, standardPrice.Id, 2);
    
        Test.startTest();
        order.Status = 'Activated';
        update order;
        Test.stopTest();
    
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(200.00, acc.Chiffre_d_affaire__c, 'Account Chiffre_d_affaire__c should be updated with the total value of the order');
    }
        


    @isTest
static void testUpdateChiffreDAffaire() {
    // Récupérez la liste des comptes
    List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];

    Test.startTest();
    // Mettez à jour la valeur de Chiffre d'affaire pour chaque compte
    List<Account> toUpdate = new List<Account>();
    for (Account acc : accounts) {
        acc.Chiffre_d_affaire__c = 1000;
        toUpdate.add(acc);
    }
    update toUpdate;
    Test.stopTest();

    // Récupérez de nouveau les comptes pour vérifier que les mises à jour ont été effectuées
    List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account];

    // Vérifiez que les comptes ont bien été mises à jour avec la valeur souhaitée
    for (Account acc : updatedAccounts) {
        System.assertEquals(1000, acc.Chiffre_d_affaire__c, 'La valeur de chiffre d\'affaire n\'a pas été mise à jour');
    }
}
}