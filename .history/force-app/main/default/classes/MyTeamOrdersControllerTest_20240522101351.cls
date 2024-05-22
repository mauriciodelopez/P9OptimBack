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

        // Créer une liste de 10 utilisateurs de test avec le rôle 'Commercial'
        UserRole r = [SELECT Id FROM UserRole WHERE Name = 'Commercial'];
        List<User> users = new List<User>();
        for(Integer i=0; i<10; i++) {
            User u = new User(Alias = 'standt' + i, Email='standarduser' + i + '@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing' + i, LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User'].Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser' + i + '@testorg.com',
            UserRole = r);
            users.add(u);
        }
        insert users;

        // Assigner les commandes à l'utilisateur de test
        Integer userIndex = 0;
        for (Order o : orders) {
            o.OwnerId = users[userIndex].Id; // Assigner les commandes à l'utilisateur actuel
            update o;

            // Move to the next user, if we're at the end of the list, start over
            userIndex++;
            if (userIndex >= users.size()) {
                userIndex = 0;
            }
        }

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