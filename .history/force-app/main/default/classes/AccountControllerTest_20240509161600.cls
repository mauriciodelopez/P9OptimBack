/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AccountControllerTest {
    @testSetup
    static void setup() {
        // Create accounts
        List<Account> accounts = TestDataFactory.createAccounts(5);

        // Get the standard pricebook ID
        Id pricebookId = Test.getStandardPricebookId();

        // Create two orders for each account
        TestDataFactory.createOrdersForAccounts(accounts, 2);

        // Create order items for all accounts
        TestDataFactory.createOrderItemsForAccounts(accounts, 2);
    }

    @isTest
    static void testUpdateChiffreDAffaireWithError() {
// Create test accounts
    Account acc1 = new Account(Name='Test Account1');
    Account acc2 = new Account(Name='Test Account2');
    insert new List<Account>{acc1, acc2};
        // Start the test part that is measured for governor limits
        Test.startTest();

        // Call the updateChiffreDAffaire method
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);

        // Stop the test part that is measured for governor limits
        Test.stopTest();

        // Get the updated accounts
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        // Verify that the Chiffre_d_affaire__c field has been correctly updated for the first account
        System.assertEquals(200.0, updatedAccounts[0].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the first account should be 200.0');
        System.assertEquals(0.0, updatedAccounts[1].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the second account should be 0.0');
    }
}
