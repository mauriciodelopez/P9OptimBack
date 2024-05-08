/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateAccountsBatchTest {
    private static List<Account> testAccounts;

    @testSetup
    static void setup() {
        testAccounts = TestDataFactory.createMassiveAccounts(200);
        TestDataFactory.createOrdersForAccounts(testAccounts, 200);
        TestDataFactory.createOrderItemsForAccounts(testAccounts, 5);
    }

    @isTest
    static void testBatchHandlesMassiveData() {
        Test.startTest();
        UpdateAccountsBatch batch = new UpdateAccountsBatch();
        Id jobId = Database.executeBatch(batch);
        Test.stopTest();

        TestDataFactory.verifyUpdatedAccounts(testAccounts);
        TestDataFactory.verifyBatchJobCompletion(jobId);
    }
}