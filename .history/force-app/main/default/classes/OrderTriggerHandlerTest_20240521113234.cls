/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-21-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class OrderTriggerHandlerTest {
    @TestSetup static void setup(){
        // Create 200 test accounts
        List<Account> accounts = TestDataFactory.createAccounts(200);

        // Create an order test for each account
        List<Order> orders = new List<Order>();
        for(Account acc : accounts) {
            Order ord = TestDataFactory.createOrder(acc.Id, 'Draft');
            orders.add(ord);
        }
        insert orders;

        // Create a new product using the TestDataFactory utility class. 
        // The product has a name of 'Test Product' and belongs to the 'Test Family' product family.
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Create a new pricebook entry for the product we just created, also using the TestDataFactory utility class.
        // The pricebook entry sets the unit price of the product to 1.
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 1);

        // Using the TestDataFactory utility class, create order items for the orders.
        // The order items are associated with the pricebook entry identified by 'pbe.Id'.
// Each order item has a quantity of 1 and a unit price of 100.
        TestDataFactory.createOrderItems(orders, pbe.Id, 1, 100);
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
        ord = [SELECT NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id = :ord.Id];
        
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