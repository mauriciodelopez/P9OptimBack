/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateAccountsBatchTest {
    @testSetup
    static void setup() {
        // Create test accounts
        List<Account> testAccounts = TestDataFactory.createMassiveAccounts(50);
        // Create test orders associated with these accounts
        TestDataFactory.createOrderItemsForAccounts(testAccounts, 2);
    }

    @isTest
    static void testBatch() {
        // Get the test accounts
        List<Account> testAccounts = [SELECT Id FROM Account];

        // Start the test, run the batch job, and stop the test
        Test.startTest();
        UpdateAccountsBatch batch = new UpdateAccountsBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();

        // Verify that the batch job processed all accounts
        AsyncApexJob job = [SELECT TotalJobItems, Status FROM AsyncApexJob WHERE Id = :batchId];
        System.assertEquals(testAccounts.size(), job.TotalJobItems, 'All accounts should be processed by the batch job.');

        // Verify that the updateChiffreDAffaire method was called for each account
        for (Account acc : testAccounts) {
            Account updatedAcc = [SELECT ChiffreDAffaire__c FROM Account WHERE Id = :acc.Id];
            System.assertNotEquals(null, updatedAcc.ChiffreDAffaire__c, 'ChiffreDAffaire should be updated for each account.');
        }
    }
}