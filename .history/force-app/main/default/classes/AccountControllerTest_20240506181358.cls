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

    // ... (existing test methods)
}