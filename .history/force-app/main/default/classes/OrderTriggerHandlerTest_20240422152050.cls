/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// Test class for OrderTriggerHandler
@isTest
public class OrderTriggerHandlerTest {
    // Function to setup test data
    @testSetup
    static void setup(){
        // Create many accounts
        List<Account> accounts = TestDataFactory.createAccounts(200);

        // Create orders for all accounts
        TestDataFactory.createOrdersForAccounts(accounts, 2);
    }

    // Function to test afterInsert method
    @isTest
    public static void afterInsertTest(){
        // Get all orders
        List<Order> orders = [SELECT Id, TotalAmount FROM Order];

        // Run logic to test
        Test.startTest();   
         OrderTriggerHandler.afterInsert(orders);
        Test.stopTest();
        