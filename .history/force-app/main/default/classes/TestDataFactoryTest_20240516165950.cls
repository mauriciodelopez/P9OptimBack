/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactoryTest {
    static List<Account> testAccounts;
    static List<Order> testOrders;
    static Product2 testProduct;
    static PricebookEntry testPBE;

    @testSetup 
    static void setup() {
        // Create test data
        testAccounts = TestDataFactory.createAccounts(5);
        testOrders = TestDataFactory.createOrdersForAccounts(testAccounts);
        testProduct = TestDataFactory.createProduct('Test Product', 'Test Family');
        testPBE = TestDataFactory.createPricebookEntry(testProduct, 100.0);
    }

    @isTest
    static void testCreateAccounts() {
        System.assertEquals(5, testAccounts.size(), 'Incorrect number of accounts created');
    }

    @isTest
    static void testCreateOrdersForAccounts() {
        System.assertEquals(5, testOrders.size(), 'Incorrect number of orders created');
    }

    @isTest
    static void testCreateProduct() {
        System.assertNotEquals(null, testProduct.Id, 'Product ID should not be null');
    }

    @isTest
    static void testCreatePricebookEntry() {
        System.assertNotEquals(null, testPBE.Id, 'PricebookEntry ID should not be null');
    }

    @isTest
    static void testCreateOrder() {
        Order order = TestDataFactory.createOrder(testAccounts[0].Id, 'Draft');
        System.assertNotEquals(null, order.Id, 'Order ID should not be null');
    }

    @isTest
    static void testCreateOrderItems() {
        List<OrderItem> orderItems = TestDataFactory.createOrderItems(testOrders, testPBE.Id, 5, 100.0);
        System.assertEquals(1, orderItems.size(), 'Incorrect number of order items created');
    }

    @isTest
    static void testGetOrdersBySalesRep() {
        Map<Id, List<Order>> ordersBySalesRep = TestDataFactory.getOrdersBySalesRep();
        System.assertNotEquals(null, ordersBySalesRep, 'Orders by sales rep should not be null');
    }
}