/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Crear datos de prueba
        List<Account> accounts = TestDataFactory.createAccounts(200);
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(product);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        TestDataFactory.createOrderItems(
            new List<Id>{orders[0].Id, orders[1].Id},
            new List<Id>{product.Id, product.Id},
            new List<Id>{pricebook.Id, pricebook.Id},
            new List<Decimal>{1, 2},
            new List<Decimal>{100, 200}
        );
    }

    @isTest
    static void testAccountsCreation() {
        // Verificar la creación de cuentas
        List<Account> accounts = TestDataFactory.createAccounts(5);
        System.assertEquals(5, accounts.size(), 'Número incorrecto de cuentas creadas');
        for(Account acc : accounts) {
            System.assertNotEquals(null, acc.Id, 'El Id de la cuenta no debe ser nulo después de la inserción');
        }
    }

    @isTest
    static void testOrdersCreation() {
        // Verificar la creación de órdenes
        List<Account> accounts = TestDataFactory.createAccounts(2);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        System.assertEquals(2, orders.size(), 'Número incorrecto de órdenes creadas');
        for(Order ord : orders) {
            System.assertNotEquals(null, ord.Id, 'El Id de la orden no debe ser nulo después de la inserción');
        }
    }

    @isTest
    static void testProductCreation() {
        // Verificar la creación de productos
        Product2 product = TestDataFactory.createProduct();
        System.assertNotEquals(null, product.Id, 'El Id del producto no debe ser nulo después de la inserción');
    }

    @isTest
    static void testPricebookCreation() {
        // Verificar la creación de entradas en el catálogo de precios
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(product);
        System.assertNotEquals(null, pricebook.Id, 'El Id de la entrada en el catálogo de precios no debe ser nulo después de la inserción');
    }

    @isTest
    static void testOrderItemsCreation() {
        // Verificar la creación de elementos de orden
        List<Account> accounts = TestDataFactory.createAccounts(2);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(product);
        List<OrderItem> orderItems = TestDataFactory.createOrderItems(
            new List<Id>{orders[0].Id, orders[1].Id},
            new List<Id>{product.Id, product.Id},
            new List<Id>{pricebook.Id, pricebook.Id},
            new List<Decimal>{1, 2},
            new List<Decimal>{100, 200}
        );
        System.assertEquals(2, orderItems.size(), 'Número incorrecto de elementos de orden creados');
        for(OrderItem item : orderItems) {
            System.assertNotEquals(null, item.Id, 'El Id del elemento de orden no debe ser nulo después de la inserción');
        }
    }


    @isTest
    static void testOrderValueUpdatesAccount() {
        Integer numAccounts = 1; // Define numAccounts
        String chemiseVerte = 'chemiseVerte'; // Define chemiseVerte
    
        List<Account> accList = testDataFactory.createAccounts(numAccounts);
        Account acc = accList[0]; // Get the first account from the list
        Product2 testProduct = testDataFactory.createProduct('Test Product', 'Test Product');
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = testDataFactory.createPricebookEntry(chemiseVerte, pricebookId, testProduct.Id, 100);
    
        Order order = testDataFactory.createOrder(acc.Id, pricebookId, 'Draft', testProduct.Id);
    
        List<Id> orderIds = new List<Id>{order.Id};
        List<Id> productIds = new List<Id>{testProduct.Id};
        List<Id> pricebookEntryIds = new List<Id>{standardPrice.Id};
        List<Decimal> quantities = new List<Decimal>{2};
        List<Decimal> unitPrices = new List<Decimal>{standardPrice.UnitPrice};
    
        List<OrderItem> orderItems = testDataFactory.createOrderItems(orderIds, productIds, pricebookEntryIds, quantities, unitPrices);
    
        Test.startTest();
        order.Status = 'Activated';
        update order;
        Test.stopTest();
    
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(200.00, acc.Chiffre_d_affaire__c, 'Account Chiffre_d_affaire__c should be updated with the total value of the order');
    }

    @isTest
    static void testUpdateChiffreDAffaire() {

        // Crear cuentas con un valor específico en Chiffre_d_affaire__c
        List<Account> accounts = TestDataFactory.createAccounts(5);
        for (Account acc : accounts) {
            acc.Chiffre_d_affaire__c = 500; // Establecer un valor inicial conocido
        }
        insert accounts; // Insertar las cuentas en la base de datos
        
        // Verificar que el campo Chiffre_d_affaire__c se actualiza correctamente para todas las cuentas
        Test.startTest();
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();
    
        // Verificar que los valores de Chiffre_d_affaire__c se han actualizado correctamente
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account];
    
        Decimal expectedTotal = 5 * 500; // 5 cuentas con un valor inicial de 500
        for (Account acc : updatedAccounts) {
            System.assertEquals(expectedTotal, acc.Chiffre_d_affaire__c, 'El valor de Chiffre_d_affaire__c no se ha actualizado correctamente');
        }
    }
    
    //Test pour vérifier que les comptes se mettent à jour correctement, lors qu'il n'ya pas des orders associées
    @isTest
    static void testUpdateCAWithoutOrders(){
        //Préparation de l'environnement de test 
        //Création des données de test donc des comptes & 
    }

}
