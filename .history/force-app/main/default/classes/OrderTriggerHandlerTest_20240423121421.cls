/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class OrderTriggerHandlerTest {
    @testSetup
    static void setup() {
        // Créez un compte
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Créez une commande pour le compte
        Order ord = new Order(AccountId=acc.Id, Status='Draft', TotalAmount=100, ShipmentCost__c=10);
        insert ord;
    }

    @isTest
    static void testBeforeUpdate() {
        // Récupérez la commande
        Order ord = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order LIMIT 1];

        // Mettez à jour la commande
        ord.TotalAmount = 200;
        ord.ShipmentCost__c = 20;

        Test.startTest();
        update ord;
        Test.stopTest();

        // Récupérez la commande mise à jour
        Order updatedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :ord.Id];

        // Vérifiez que le montant net a été correctement calculé
        System.assertEquals(180, updatedOrder.NetAmount__c, 'Le montant net n\'a pas été correctement calculé dans la méthode beforeUpdate');
    }

    @isTest
    static void testAfterUpdate() {
        // Récupérez la commande
        Order ord = [SELECT Id, AccountId, Status, TotalAmount FROM Order LIMIT 1];

        // Mettez à jour la commande
        ord.Status = 'Ordered';

        Test.startTest();
        update ord;
        Test.stopTest();

        // Récupérez le compte mis à jour
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :ord.AccountId];

        // Vérifiez que le chiffre d'affaires a été correctement calculé
        System.assertEquals(ord.TotalAmount, updatedAccount.Chiffre_d_affaire__c, 'Le chiffre d\'affaires n\'a pas été correctement calculé dans la méthode afterUpdate');
    }
}