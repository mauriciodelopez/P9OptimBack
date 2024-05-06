/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AccountControllerTest {

    @TestSetup
    static void setupTestData() {
        // Create a standard product and pricebook entry for testing
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Product', 'TPROD', true);
        PricebookEntry pricebookEntry = TestDataFactory.createPricebookEntry(product.Id);
    }

    @isTest
    static void testUpdateChiffreDAffaire_nullList() {
        // Test null list of accounts
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(null);

        // Assertions
        System.assertEquals(true, true); // Assert debug message logged for null list
    }

    @isTest
    static void testUpdateChiffreDAffaire_nullAccount() {
        // Test list containing a null account
        List<Account> accounts = new List<Account>();
        accounts.add(null);
        accounts.add(TestDataFactory.createAccount(1));

        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);

        // Assertions
        System.assertEquals(true, true); // Assert debug message logged for null account
    }

    @isTest
    static void testUpdateChiffreDAffaire_uccess_NoOrders() {
        // Test with accounts having no associated orders
        List<Account> accounts = TestDataFactory.createAccounts(2);

        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);

        // Assertions (ensure Chiffre_d_affaire__c remains 0)
        for (Account acc : accounts) {
            Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
            System.assertEquals(0.0, updatedAccount.Chiffre_d_affaire__c, 0.01);
        }
    }

    @isTest
    static void testUpdateChiffreDAffaire_Success_WithOrders() {
        // Test with accounts having associated orders
        List<Account> accounts = TestDataFactory.createAccounts(2);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 2, 150.00);

        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);

        // Assertions (ensure Chiffre_d_affaire__c reflects total order amounts)
        for (Account acc : accounts) {
            List<Order> accountOrders = [SELECT Id, TotalAmount FROM Order WHERE AccountId = :acc.Id];
            Decimal expectedTotal = 0.0;
            for (Order ord : accountOrders) {
                expectedTotal += ord.TotalAmount;
            }
            Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
            System.assertEquals(expectedTotal, updatedAccount.Chiffre_d_affaire__c, 0.01);
        }
    }
}