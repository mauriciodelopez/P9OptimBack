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
    public static Id jobId;

    @testSetup
    static void setup() {
        testAccounts = TestDataFactory.createMassiveAccounts(200);
        TestDataFactory.createOrdersForAccounts(testAccounts, 200,100 );
        TestDataFactory.createOrderItemsForAccounts(testAccounts, 5);
    }

    @isTest
    static void testBatchHandlesMassiveData() {
        Test.startTest();
        UpdateAccountsBatch batch = new UpdateAccountsBatch();
        jobId = Database.executeBatch(batch);
        Test.stopTest();

        TestDataFactory.verifyUpdatedAccounts();
        verifyBatchJobCompletion();
    }

    @isTest
    static void verifyBatchJobCompletion() {
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :jobId AND Status = 'Completed'];
        System.assertEquals(1, jobs.size(), 'Le batch n\'a pas été exécuté avec succès.');
    }
}