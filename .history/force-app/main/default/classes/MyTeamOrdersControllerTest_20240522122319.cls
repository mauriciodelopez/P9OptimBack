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
        // Crear un UserRole de prueba
        UserRole r = new UserRole(DeveloperName = 'testRole', Name = 'Commercial');
        insert r;

        // Crear un User de prueba
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com',
            UserRoleId = r.Id);
        insert u;

        // Crear un pedido de prueba para el usuario
        Order testOrder = new Order(
            OwnerId = u.Id,
            Status = 'Ordered',
            //TotalAmount = 100.00
        );
        insert testOrder;
    }

    @isTest
    static void testOrdersBySalesRep() {
        // Crear una nueva instancia del controlador
        Test.startTest();
        MyTeamOrdersController controller = new MyTeamOrdersController();
        Test.stopTest();

        // Verificar que cada vendedor tiene la suma correcta de pedidos
        User testUser = [SELECT Id FROM User WHERE UserName = 'standarduser@testorg.com'];
        Decimal userOrderSum = controller.sumOrdersByUser.get(testUser.Id);
        System.assertEquals(100.00, userOrderSum,
            'La suma de pedidos para el vendedor ' + testUser.Id + ' no es correcta');
    }
}