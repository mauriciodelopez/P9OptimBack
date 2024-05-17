/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class OrderTriggerHandlerTest {
    @TestSetup static void setup(){
        Account acc = TestDataFactory.createAccounts(2);
        Product2 prod = TestDataFactory.createProduct(name, family);
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100);
        Order ord = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItem(ord.Id, prod.Id, pbe.Id, 1, 100);
        
    }
    @isTest static void testBeforeUpdate() {
        // Preparar datos de prueba
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Order ord = [SELECT Id, Shi];
        
        // Actualizar el pedido para disparar el código beforeUpdate
        Test.startTest();
        ord.ShipmentCost__c = 10;
        update ord;
        Test.stopTest();
        
        // Recuperar el pedido actualizado
        ord = [SELECT NetAmount__c, TotalAmount FROM Order WHERE Id = :ord.Id];
        
        // Verificar que NetAmount__c se calculó correctamente
        System.assertEquals(ord.TotalAmount - ord.ShipmentCost__c, ord.NetAmount__c, 'NetAmount__c no se calculó correctamente');
    }

    @isTest static void testAfterUpdate() {
        // Preparar datos de prueba
        Account acc = TestDataFactory.createAccount();
        Product2 prod = TestDataFactory.createProduct();
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id);
        Order ord = TestDataFactory.createOrder(acc.Id);
        TestDataFactory.createOrderItem(ord.Id, prod.Id, pbe.Id, 1, 100);
        
        // Actualizar el pedido para disparar el código afterUpdate
        Test.startTest();
        ord.Status = 'Ordered';
        update ord;
        Test.stopTest();
        
        // Recuperar la cuenta actualizada
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        
        // Verificar que Chiffre_d_affaire__c se actualizó correctamente
        System.assertEquals(ord.TotalAmount, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c no se actualizó correctamente');
    }
}

//En este código, he agregado la creación de un OrderItem a tus datos de prueba. Esto debería hacer que TotalAmount se calcule automáticamente cuando insertas el OrderItem. Luego, en tus pruebas, verifico que NetAmount__c y Chiffre_d_affaire__c se calculen correctamente en base a TotalAmount.