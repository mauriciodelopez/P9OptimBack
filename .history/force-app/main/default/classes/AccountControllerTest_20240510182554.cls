/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2024
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
        // Verificar que el valor de la orden actualiza la cuenta correctamente
        Account acc = TestDataFactory.createAccounts(1)[0];
        Product2 testProduct = TestDataFactory.createProduct();
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(testProduct);
    
        Test.startTest();
        Order order = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItems(order.Id, testProduct.Id, pricebook.Id, 2);
        order.Status = 'Activated';
        update order;
        Test.stopTest();
    
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(200.00, acc.Chiffre_d_affaire__c, 'El campo Chiffre_d_affaire__c de la cuenta debería actualizarse con el valor total de la orden');
    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Verificar que el campo Chiffre_d_affaire__c se actualiza correctamente para todas las cuentas
        Test.startTest();
        AccountController controller = new AccountController();
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Verificar que los valores de Chiffre_d_affaire__c se han actualizado correctamente
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account];

        for (Account acc : updatedAccounts) {
            System.assertEquals(1000, acc.Chiffre_d_affaire__c, 'El valor de Chiffre_d_affaire__c no se ha actualizado correctamente');
        }
    }
}
