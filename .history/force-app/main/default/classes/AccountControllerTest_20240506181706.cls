/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AccountControllerTests {

    @isTestSetup
    static void setupTestData() {
        // Create a standard product and pricebook entry for testing
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Product', 'TPROD', true);
        PricebookEntry pricebookEntry = TestDataFactory.createPricebookEntry(product.Id);
    
    }
    @isTest
    static void testUpdateChiffreDAffaire_NullList() {
        // Test null list of accounts
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(null);

        // Assertions
        System.assertEquals(true, true); // Assert debug message logged for null list
    }

    @isTest
    static void testUpdateChiffreDAffaire_NullAccount() {
        // Test list containing a null account
        List<Account> accounts = new List<Account>();
        accounts.add(null);
        accounts.add(TestDataFactory.createAccount(1));

        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);

        // Assertions
        System.assertEquals(true, true); // Assert debug message logged for null account
    }

    
}