/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-23-2024
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
        // Assertions
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];

        for (Account account : accounts) {
            System.assertEquals(1000, account.Chiffre_d_affaire__c, 'The total amount of all orders should be added to the total amount of all orders');
        }
    }

    // Function to test afterUpdate method
    @isTest
    public static void afterUpdateTest(){
        // Get all orders

        List<Order> orders = [SELECT Id, TotalAmount FROM Order];

        // Run logic to test
        Test.startTest();   
        OrderTriggerHandler.afterUpdate(orders);   
        Test.stopTest();

        // Assertions
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];    

        for (Account account : accounts) {
            System.assertEquals(1000, account.Chiffre_d_affaire__c, 'The total amount of all orders should be added to the total amount of all orders');
        }
    }   
    
    // Function to test afterDelete method
    @isTest
    public static void afterDeleteTest(){
        // Get all orders   
        List<Order> orders = [SELECT Id, TotalAmount FROM Order];

        // Run logic to test
        Test.startTest();   
        OrderTriggerHandler.afterDelete(orders);   
        Test.stopTest();  

        // Assertions
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];        
        for (Account account : accounts) {
            System.assertEquals(1000, account.Chiffre_d_affaire__c, 'The total amount of all orders should be added to the total amount of all orders');
        }
    }   
    
    // Function to test afterUndelete method
    @isTest
    public static void afterUndeleteTest(){
        // Get all orders   
        List<Order> orders = [SELECT Id, TotalAmount FROM Order];
        delete orders;  

        // Run logic to test
        Test.startTest();   
        OrderTriggerHandler.afterUndelete(orders);   
        Test.stopTest();                              

        // Assertions
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];

        for (Account account : accounts) {
            System.assertEquals(1000, account.Chiffre_d_affaire__c, 'The total amount of all orders should be added to the total amount of all orders');
        }
    }   
}   