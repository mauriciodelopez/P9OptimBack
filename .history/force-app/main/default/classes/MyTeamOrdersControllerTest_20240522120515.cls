/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class MyTeamOrdersControllerTest {
    // Méthode de configuration des données de test utilisant @testSetup
    @testSetup
    static void setupTestData() {
        testDataFactory.getOrdersBySalesRep();
        // Crear un UserRole de prueba
        UserRole r = new UserRole(DeveloperName = 'testRole', Name = 'Commercial');
        insert r;

        // Crear un User de prueba
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com',
            UserRole = r);
        insert u;
        
    }

    @isTest
    static void testControllerLogic() {
        // Create a new instance of the controller
        Test.startTest();
        MyTeamOrdersController controller = new MyTeamOrdersController();
        Test.stopTest();

        // Check if the sumOrders property is correctly calculated
        System.assertEquals(0.0, controller.sumOrders, 'The sum of the order amounts is not correct');
    }



}