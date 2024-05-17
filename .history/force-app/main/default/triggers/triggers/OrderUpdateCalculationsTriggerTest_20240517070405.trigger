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

    }
}