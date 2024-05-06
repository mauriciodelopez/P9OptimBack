/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class OrderTriggerHandlerTest {
    @testSetup
    static void setup() {
        // Option 1: Create accounts and orders with unit price control (recommended)
        List<Account> accounts = TestDataFactory.createMassiveAccounts(5);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 2, 'Test Product', 'ABC', 100.00);
    }

    @isTest
    static void testBeforeUpdate() {
        // Obtenez les données de test
        List<Order> orders = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order];

        // Commencez le test
        System.test.startTest();

        // Effectuez l'opération pour déclencher beforeUpdate
        for (Order ord : [SELECT Id FROM Order]) {
            ord.Status = 'Ordered';
        }
        update orders;

        // Arrêtez le test
        System.test.stopTest();

        // Vérifiez les résultats
        for (Order ord : [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order]) {
            System.assertNotEquals(0, ord.NetAmount__c, 'NetAmount__c should not be 0');
        }
    }

    @isTest
    static void testAfterUpdate() {
        // Obtenez les données de test
        List<Order> orders = [SELECT Id, AccountId, Status FROM Order];
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c FROM Account]);

        // Commencez le test
        System.test.startTest();

        // Effectuez l'opération pour déclencher afterUpdate
        for (Order ord : orders) {
            ord.Status = 'Ordered';
        }
        update orders;

        // Arrêtez le test
        System.test.stopTest();

        // Vérifiez les résultats
        for (Account acc : [SELECT Id, Chiffre_d_affaire__c FROM Account]) {
            System.assertNotEquals(accounts.get(acc.Id).Chiffre_d_affaire__c, acc.Chiffre_d_affaire__c,);
        }
    }
}