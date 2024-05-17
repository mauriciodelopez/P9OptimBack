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
        List<Account> accounts = TestDataFactory.createAccounts(200);
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Family');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100);
        Order testord = TestDataFactory.createOrder(accountId, orderStatus);
        TestDataFactory.createOrderItem(ord.Id, prod.Id, pbe.Id, 1, 100);
        
    }
    @isTest static void testBeforeUpdate() {
        // Preparar datos de prueba
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Order ord = [SELECT Id, ShipmentCost__c, NetAmount__c, TotalAmount FROM Order WHERE AccountId = :acc.Id LIMIT 1];
        
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
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Order ord = [SELECT Id, Status, TotalAmount FROM Order WHERE AccountId = :acc.Id LIMIT 1];

        
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

