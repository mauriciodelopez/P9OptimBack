/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class OrderTriggerHandlerTest {
    @isTest static void testBeforeUpdate() {
        // Preparar datos de prueba
        Account acc = TestDataFactory.createTestAccount();
        insert acc;
        
        Order ord = TestDataFactory.createOrder(acc.Id);
        ord.TotalAmount = 100;
        ord.ShipmentCost__c = 10;
        update ord;
        
        // Actualizar el pedido para disparar el código beforeUpdate
        Test.startTest();
        ord.Status = 'Ordered';
        update ord;
        Test.stopTest();
        
        // Recuperar el pedido actualizado
        ord = [SELECT NetAmount__c FROM Order WHERE Id = :ord.Id];
        
        // Verificar que NetAmount__c se calculó correctamente
        System.assertEquals(90, ord.NetAmount__c, 'NetAmount__c no se calculó correctamente');
    }
    
    @isTest static void testAfterUpdate() {
        // Preparar datos de prueba
        Account acc = TestDataFactory.createTestAccount();
        acc.Chiffre_d_affaire__c = 0;
        insert acc;
        
        Order ord = TestDataFactory.createOrder(acc.Id);
        ord.TotalAmount = 100;
        update ord;
        
        // Actualizar el pedido para disparar el código afterUpdate
        Test.startTest();
        ord.Status = 'Ordered';
        update ord;
        Test.stopTest();
        
        // Recuperar la cuenta actualizada
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        
        // Verificar que Chiffre_d_affaire__c se actualizó correctamente
        System.assertEquals(100, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c no se actualizó correctamente');
    }
}