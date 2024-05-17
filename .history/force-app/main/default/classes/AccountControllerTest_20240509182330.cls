/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-09-2024
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

    












}