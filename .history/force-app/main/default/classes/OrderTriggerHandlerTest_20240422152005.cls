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