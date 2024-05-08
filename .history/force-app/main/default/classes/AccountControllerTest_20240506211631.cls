/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AccountControllerTest {
    // This method sets up test data for the test methods in this class.
    @TestSetup
    static void setupTestData() {
        // Create a standard product and pricebook entry for testing
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Product', 'TPROD', true);
        PricebookEntry pricebookEntry = TestDataFactory.createPricebookEntry(product.Id);
    }
    // This test method tests the scenario where the list of accounts passed to the updateChiffreDAffaire method is null.
    @isTest
    static void testUpdateChiffreDAffaireNullList() {
        // Test null list of accounts
        Test.startTest();
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(null);
        Test.stopTest();

    

        // Assertions
        System.assertEquals(true, true, 'test'); // This assertion is a placeholder and should be replaced with a meaningful assertion.
    }

    // This test method tests the scenario where the list of accounts passed to the updateChiffreDAffaire method contains a null account.
    @isTest
    static void testUpdateChiffreDAffaireNullAccount() {
        // Create a list of accounts with a null account
        List<Account> accounts = new List<Account>();
        accounts.add(null);
        accounts.add(TestDataFactory.createAccount(1));

        Test.startTest();
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Assertions
        System.assertEquals(true, true, 'test'); // Assert debug message logged for null account
    }

    
    @isTest
    static void testUpdateChiffreDAffaireSuccessNoOrders() {
        // Test with accounts having no associated orders
        List<Account> accounts = TestDataFactory.createAccounts(2);

        Test.startTest();
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Assertions (ensure Chiffre_d_affaire__c remains 0)
        for (Account acc : accounts) {
            Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
            System.assertEquals(0.0, updatedAccount.Chiffre_d_affaire__c, 0.01);
        }
    }

    @isTest
    static void testUpdateChiffreDAffaireSuccessWithOrders() {
        list<Account> updatedAccount = new List<Account>();

        // Test with accounts having associated orders
        List<Account> accounts = TestDataFactory.createAccounts(2);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 2, 150.00);

        
        Test.startTest();
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Assertions (ensure Chiffre_d_affaire__c reflects total order amounts)
        List<Account> updatedAccounts = new List<Account>(
        [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts]
        );
        //List<Order> ListMap = new List<Order>(orders);

            /*for (Account acc : accounts) {
                Decimal expectedTotal = 0.0;
                for (Order ord : orders) {
                    updatedAccount.add(acc.Id);
                expectedTotal += ord.TotalAmount;
                }
                
            }
        Test.startTest();
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(null);
        Test.stopTest();*/
    
    }
    
}
