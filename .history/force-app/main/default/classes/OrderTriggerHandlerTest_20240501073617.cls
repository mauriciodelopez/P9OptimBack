/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest // Cette annotation indique que cette classe est une classe de test.
public class OrderTriggerHandlerTest {
    @testSetup // Cette annotation indique que la méthode suivante est utilisée pour configurer les données de test.
    static void setup() {
        // Créez un compte
        Account acc = new Account(Name='Test Account'); // Crée un nouvel objet compte avec le nom 'Test Account'.
        insert acc; // Insère le compte dans la base de données.

        // Créez une commande pour le compte
        Order ord = new Order(AccountId=acc.Id, Status='Draft', ShipmentCost__c=10, EffectiveDate=System.today()); // Crée un nouvel objet commande lié au compte précédemment créé, avec un statut 'Draft', et des frais de livraison de 10, et une date effective d'aujourd'hui.
        insert ord; // Insère la commande dans la base de données.
    }

    @isTest // Cette annotation indique que la méthode suivante est une méthode de test.
    static void testBeforeUpdate() {
        // Récupérez la commande
        Order ord = [SELECT Id, ShipmentCost__c, NetAmount__c FROM Order LIMIT 1]; // Récupère la première commande de la base de données.

        // Mettez à jour la commande

        if (ord != null) {
            ord.ShipmentCost__c = 20;

            Test.startTest();
            update ord;
            Test.stopTest();

            Order updatedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :ord.Id];

            if (updatedOrder != null && updatedOrder.NetAmount__c != null) {
                System.assertEquals(180, updatedOrder.NetAmount__c, 'Le montant net n\'a pas été correctement calculé dans la méthode beforeUpdate');
            }
        }
    }

    @isTest
    public static void testAfterUpdateV1(){
        Order testOrder = new Order(Status = 'Ordered');
        Account testAccount = 



    }
    @isTest // Cette annotation indique que la méthode suivante est une méthode de test.
    static void testAfterUpdate() {
        // Récupérez la commande
        Order ord = [SELECT Id, AccountId, Status, TotalAmount FROM Order LIMIT 1]; // Récupère la première commande de la base de données.

        // Mettez à jour la commande
        if (ord != null) {
            ord.Status = 'Ordered';

            Test.startTest();
            update ord;
            Test.stopTest();

            Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :ord.AccountId];

            if (updatedAccount != null && updatedAccount.Chiffre_d_affaire__c != null) {
                System.assertEquals(ord.TotalAmount, updatedAccount.Chiffre_d_affaire__c, 'Le chiffre d\'affaires n\'a pas été correctement calculé dans la méthode afterUpdate');
            }
        }

    }
}