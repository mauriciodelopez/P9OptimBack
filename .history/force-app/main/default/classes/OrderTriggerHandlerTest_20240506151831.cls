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
        
        Order ord = TestDataFactory.createTestOrder(acc.Id, 'Draft', 100, 10);
        insert ord;
        
        // Actualizar el pedido para disparar el código beforeUpdate
        Test.startTest();
        ord.Status = 'Ordered';
        update ord;
        Test.stopTest();
        
        // Recuperar el pedido actualizado
        ord = [SELECT NetAmount__c FROM Order WHERE Id = :ord.Id];
        
        // Verificar que NetAmount__c se calculó correctamente
        System.assertEquals(90, ord.NetAmount__c,'The NetAmount__c was not calculated correctly.');
    }
    
    @isTest static void testAfterUpdate() {
        // Preparar datos de prueba
        Account acc = TestDataFactory.createTestAccount();
        acc.Chiffre_d_affaire__c = 0;
        insert acc;
        
        Order ord = TestDataFactory.createTestOrder(acc.Id, 'Draft', 100, null);
        insert ord;
        
        // Actualizar el pedido para disparar el código afterUpdate
        Test.startTest();
        ord.Status = 'Ordered';
        update ord;
        Test.stopTest();
        
        // Recuperar la cuenta actualizada
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        
        // Verificar que Chiffre_d_affaire__c se actualizó correctamente
        System.assertEquals(100, acc.Chiffre_d_affaire__c, 'The Account revenue wasn\'t updated correctly');
    }
}


//'The NetAmount__c was not calculated correctly.'
//