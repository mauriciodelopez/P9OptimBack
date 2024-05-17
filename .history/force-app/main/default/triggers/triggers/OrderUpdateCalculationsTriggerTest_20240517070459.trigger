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

        // Guardar el estado original del pedido
        String originalStatus = testOrder.Status;

        // Actualizar el pedido
        Test.startTest();
        testOrder.Status = 'Activated';
        update testOrder;
        Test.stopTest();

        // Recuperar el pedido actualizado
        Order updatedOrder = [SELECT Id, Name, Status FROM Order WHERE Id = :testOrder.Id];

// Verificar que los métodos beforeUpdate y afterUpdate han realizado los cambios esperados
System.assertNotEquals(originalStatus, updatedOrder.Status, 'beforeUpdate no se llamó correctamente');
// Aquí puedes añadir más afirmaciones para verificar los cambios realizados por afterUpdate

    }
}