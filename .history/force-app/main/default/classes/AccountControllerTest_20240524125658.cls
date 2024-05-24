/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Creation of test accounts 
        List<Account> accounts = TestDataFactory.createAccounts(1);
        

        // Creation orders for the accounts 
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 2);

        // Creation a product
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Creation a pricebookentry for the product
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100);

        // Creation a order Item for each order 
        TestDataFactory.createOrderItems(orders, pbe.Id, 1, 100);

    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Get created accounts in @testSetup method
        List<Account> accounts = [SELECT Id, Name FROM Account];

        // Create an instance of Controller (AccountController()) & call the method updateChiffreDAffaire
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Check that the Chiffre_d_affaire__c field has been updated correctly
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should not be null');
            System.assertEquals(200.0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be 200.0');

        }
    }    


}