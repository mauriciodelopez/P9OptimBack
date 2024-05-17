/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-17-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class OrderUpdateCalculationsTriggerTest {
    @testSetup
    static void setup() {
        // Crear una cuenta
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Crear un pedido utilizando la función createOrder de TestDataFactory
        Order testOrder = TestDataFactory.createOrder(testAccount.Id, 'Draft');
    }

    @isTest
    static void testOrderUpdateCalculationsTrigger() {
        // Recuperar el pedido de los datos de prueba
        Order testOrder = [SELECT Id, Name, Status FROM Order WHERE Status = 'Draft' LIMIT 1];

        // Actualizar el pedido
        Test.startTest();
        testOrder.Status = 'Activated';
        update testOrder;
        Test.stopTest();

        // Verificar que los métodos beforeUpdate y afterUpdate se llamaron correctamente
        // Nota: Necesitarás implementar los métodos getBeforeUpdateCalled y getAfterUpdateCalled en la clase OrderTriggerHandler
        System.assertEquals(true, OrderTriggerHandler, 'beforeUpdate no se llamó correctamente');
        System.assertEquals(true, OrderTriggerHandler.afterUpdate(), 'afterUpdate no se llamó correctamente');
    }
}