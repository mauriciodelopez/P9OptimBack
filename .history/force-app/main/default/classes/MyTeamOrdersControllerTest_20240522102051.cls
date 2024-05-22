/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-22-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class MyTeamOrdersControllerTest {
    @isTest
    static void testMyTeamOrdersController() {
        // Créer des données de test
        List<Account> accounts = TestDataFactory.createAccounts(2);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Family');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100.0);
        List<OrderItem> orderItems = TestDataFactory.createOrderItems(orders, pbe.Id, 1, 100.0);

        // Update orders to Ordered status
        for(Order ord : orders) {
            ord.Status = 'Ordered';
        }
        update orders;


        // Update all the orders at once
        update ordersToUpdate;

        // Exécuter le test
        Test.startTest();
        MyTeamOrdersController controller = new MyTeamOrdersController();
        Test.stopTest();

        // Vérifier les résultats
        System.assertEquals(10, controller.teamMembers.size(), 'There should be ten team members.');
        System.assertEquals(200.0, controller.sumOrders, 'The total sum of orders should be 200.0');
        for(User u : users) {
            System.assertEquals(20.0, controller.sumOrdersByUser.get(u.Id), 'The sum of orders for each user should be 20.0');
        }
    }
}