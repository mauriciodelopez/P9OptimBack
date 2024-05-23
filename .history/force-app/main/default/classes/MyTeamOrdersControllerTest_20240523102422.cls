/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class MyTeamOrdersControllerTest {
    @testSetup
    static void setup() {
        // Creation test accounts
        List<Account> testAccounts = TestDataFactory.createAccounts(2);

        // Creation orders for test accounts
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(testAccounts);

        // Crear un producto de prueba
        Product2 testProduct = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Creation d'une pricebookentry pour le test produit
        PricebookEntry testPBE = TestDataFactory.createPricebookEntry(testProduct, 100.0);

        // Création des order item pour 
        List<OrderItem> testOrderItems = TestDataFactory.createOrderItems(testOrders, testPBE.Id, 1, 100.0);

        // Update orders to Ordered status
        for(Order ord : testOrders) {
            ord.Status = 'Ordered';
        }
        update testOrders;
    }

    @isTest
    static void testMyTeamOrdersController() {
        // Crear una instancia de MyTeamOrdersController
        MyTeamOrdersController controller = new MyTeamOrdersController();

        // Verificar que la suma de las órdenes es correcta
        System.assertEquals(200.0, controller.sumOrders, 'La Somme des ordres nest pas correcte');
    }
}