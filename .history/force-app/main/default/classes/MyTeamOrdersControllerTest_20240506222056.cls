/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class MyTeamOrdersControllerTest {
    // Méthode de configuration des données de test utilisant @testSetup
    @testSetup
    static void setupTestData() {
        testDataFactory.getOrdersBySalesRep()();
    }

    @isTest
    static void testControllerLogic() {
        // Create a new instance of the controller
        MyTeamOrdersController controller = new MyTeamOrdersController();


        // Check if the sumOrders property is correctly calculated
        System.assertEquals(0.0, controller.sumOrders, 'The sum of the order amounts is not correct');
    }



}
