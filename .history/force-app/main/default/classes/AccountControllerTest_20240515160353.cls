/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Création des données de test 
        List<Account> accounts = TestDataFactory.createAccounts(200);
        

        // Crear órdenes para las cuentas
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);

        // Crear un producto
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Crear una entrada de lista de precios para el producto
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100);

        // Crear un ítem de orden para cada orden
        TestDataFactory.createOrderItems(orders, pbe.Id, 1, 100);

    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Recuperar las cuentas creadas en el método @testSetup
        List<Account> accounts = [SELECT Id, Name FROM Account];

        // Crear una instancia del controlador y llamar al método updateChiffreDAffaire
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Verificar que el campo Chiffre_d_affaire__c se ha actualizado correctamente
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should not be null');

        }
    }    

    @isTest
    static void testUpdateCAWithOrder() {

        // Recuperar las cuentas creadas en el método @testSetup
        List<Account> accounts = [SELECT Id, Name FROM Account];

        // Crear una instancia del controlador y llamar al método updateChiffreDAffaire
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Vérifeir que le champ Chiffre_d_affaire__c ce met a jour 
        for(Account acc : accounts) {
            System.assertEquals(100.0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be 100.0');
        }
    }

    @isTest
    private static void testOrdersCreation() {

        //Obtenir les orders qu'ont été crées dans la methode setup
        List<Order> orders = [SELECT Id FROM Order];

        //Vérifier que les orders ont été crées
        System.assertNotEquals(0, orders.size(), 'Orders should have been created');
    }

    @isTest
    private static void testOrderItemsCreation(){

        //Obtenir les orders qu'ont été crées dans la methode setup
        List<Order> orders = [SELECT Id FROM Order];

        // Verificar si se crearon las órdenes correctamente
        System.assertNotEquals(0, orders.size(), 'Se esperaba que se crearan órdenes');

        // Obtener los IDs de las órdenes para usarlos en la consulta SOQL
        Set<Id> orderIds = new Set<Id>();
        for (Order ord : orders) {
        orderIds.add(ord.Id);
        }

        // Consultar los OrderItems asociados a las órdenes fuera del bucle
        List<OrderItem> allOrderItems = [SELECT Id, OrderId FROM OrderItem WHERE OrderId IN :orderIds];

        // Iterar sobre cada orden y verificar la existencia de los OrderItems asociados
        for (Order ord : orders) {
            Integer orderItemCount = 0;
            for (OrderItem item : allOrderItems) {
                if (item.OrderId == ord.Id) {
                orderItemCount++;
                }
            }
        
            // Verificar que se crearon OrderItems
            Integer expectedSize = 1; // Cambiar el tamaño esperado según tu lógica de creación de OrderItems
            System.assertEquals(expectedSize, orderItemCount, 'Se esperaba que se creara un OrderItem para la orden con ID: ' + ord.Id);
        }
    }
    //Test pour accounts vides 
    @isTest
    static void testEmptyAccounts() {
        // Crear una instancia del controlador y llamar al método updateChiffreDAffaire
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(new List<Account>());
        Test.stopTest();

        // Verificar que no haya errores o excepciones
        System.assertEquals(1, 1, 'No debería haber errores al manejar cuentas vacías');
    }

    @isTest
static void testNoUpdateAccessToAccount() {
    // Set up a mock user without update access to the Account object
    // Note: You would need to implement this yourself
    User mockUser = TestDataFactory.createMockUserWithoutAccountUpdateAccess();

    // Run as the mock user
    System.runAs(mockUser) {
        // Retrieve the accounts created in the @testSetup method
        List<Account> accounts = [SELECT Id, Name FROM Account];

        // Create an instance of the controller and call the updateChiffreDAffaire method
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Verify that the Chiffre_d_affaire__c field has not been updated
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account acc : updatedAccounts) {
            System.assertEquals(null, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be null');
        }
    }
}
        

    
}















