/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class AccountControllerTest {
    private static final Integer NUM_ACCOUNTS = 200;
    private static final Integer NUM_ORDERS_PER_ACCOUNT = 1;
    private static final Decimal PRICE_PER_ORDER = 100.0;
    private static AccountController controller;

    @testSetup
    static void setup() {
        controller = new AccountController();
        List<Account> accounts = TestDataFactory.createAccounts(NUM_ACCOUNTS);
        System.assertEquals(NUM_ACCOUNTS, accounts.size(), 'TestDataFactory.createAccounts should create exactly NUM_ACCOUNTS accounts');
        insert accounts;
    }
    
    @isTest
    static void testCreateAccounts() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        System.assertEquals(NUM_ACCOUNTS, accounts.size(), 'The number of created accounts does not match the expected number');
        for(Integer i = 0; i < accounts.size(); i++) {
            String expectedName = 'Test Account ' + (i + 1);
            System.assertEquals(expectedName, accounts[i].Name, 'The account name does not match the expected pattern');
        }
    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        if (accounts != null && !accounts.isEmpty()) {
            controller.updateChiffreDAffaire(accounts);
        }
        List<Account> accountsAfterUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account acc : accountsAfterUpdate) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'The Chiffre_d_affaire__c field was not updated');
        }
    }

    @isTest
    static void testCreateOrdersForAccounts() {
        List<Account> testAccounts = [SELECT id, Name FROM Account];
        List<Order> orders = TestDataFactory.createOrdersForAccounts(testAccounts, NUM_ORDERS_PER_ACCOUNT, PRICE_PER_ORDER);
        System.assertEquals(NUM_ORDERS_PER_ACCOUNT * testAccounts.size(), orders.size(), 'The number of created orders does not match the expected number');
    }

    @isTest
    static void testUpdateNullList() {
        controller.updateChiffreDAffaire(null);
        List<Account> updateAccounts=[SELECT Id, Chiffre_d_affaire__c FROM Account];
        for(Account acc:updateAccounts){
            System.assertEquals(null, acc.Chiffre_d_affaire__c, 'The field should be 0');
        }
    }

    @isTest
    static void testAccountuserModify(){
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        controller.updateChiffreDAffaire(new List<Account>{testAccount});
        System.assert(ApexPages.currentPage().getParameters().get('message')==null);
    }

    @isTest
    static void testUpdateChiffreDAffaireWithOrders() {
        List<Account> accounts = TestDataFactory.createAccounts(10);
        insert accounts;
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, NUM_ORDERS_PER_ACCOUNT, PRICE_PER_ORDER);
        controller.updateChiffreDAffaire(accounts);
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for (Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'The Chiffre_d_affaire__c field was not updated correctly');
        }
    }
}