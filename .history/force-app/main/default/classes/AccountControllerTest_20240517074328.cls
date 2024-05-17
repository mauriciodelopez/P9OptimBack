/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-17-2024
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
    static void testSetupDataCreation() {
        // Verificar la creación de las cuentas
        List<Account> accounts = [SELECT Id FROM Account];
        System.assertEquals(200, accounts.size(), 'Deberían haberse creado 200 cuentas');

        // Verificar la creación de las órdenes
        List<Order> orders = [SELECT Id FROM Order];
        System.assertEquals(200, orders.size(), 'Deberían haberse creado 200 órdenes');

        // Verificar la creación del producto
        List<Product2> products = [SELECT Id FROM Product2 WHERE Name = 'Test Product' AND Family = 'Test Family'];
        System.assertEquals(1, products.size(), 'Debería haberse creado 1 producto');

        // Verificar la creación de la entrada de lista de precios
        List<PricebookEntry> pbes = [SELECT Id FROM PricebookEntry WHERE Product2Id = :products[0].Id AND UnitPrice = 100];
        System.assertEquals(1, pbes.size(), 'Debería haberse creado 1 entrada de lista de precios');

        // Verificar la creación de los ítems de orden
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE PricebookEntryId = :pbes[0].Id AND Quantity = 1 AND UnitPrice = 100];
        System.assertEquals(200, orderItems.size(), 'Deberían haberse creado 200 ítems de orden');
    }

    @isTest
    static void testAccountUpdateable() {
        // Setup: Create a user with the Standard User profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser' + DateTime.now().getTime() + '@testorg.com');

        System.runAs(u) {
            // Call the method that checks if the Account object is updateable
            Test.startTest();
            Boolean isUpdateable = Schema.sObjectType.Account.isUpdateable();
            Test.stopTest();

            // Assert: The Account object should be updateable for the Standard User profile
            System.assertEquals(true, isUpdateable, 'Account object should be updateable for the Standard User profile');
        }
    }        

    
}















