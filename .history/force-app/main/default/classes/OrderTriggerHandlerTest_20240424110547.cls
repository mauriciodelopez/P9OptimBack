/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
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
        Order ord = new Order(AccountId=acc.Id, Status='Draft', ShipmentCost__c=10, EffectiveDate=System); // Crée un nouvel objet commande lié au compte précédemment créé, avec un statut 'Draft', et des frais de livraison de 10.
        insert ord; // Insère la commande dans la base de données.
    }

    @isTest // Cette annotation indique que la méthode suivante est une méthode de test.
    static void testBeforeUpdate() {
        // Récupérez la commande
        Order ord = [SELECT Id, ShipmentCost__c, NetAmount__c FROM Order LIMIT 1]; // Récupère la première commande de la base de données.

        // Mettez à jour la commande
        ord.ShipmentCost__c = 20; // Modifie les frais de livraison de la commande à 20.

        Test.startTest(); // Démarre la partie du test qui est réellement mesurée.
        update ord; // Met à jour la commande dans la base de données. Cela devrait déclencher le calcul du montant net.
        Test.stopTest(); // Arrête la partie du test qui est réellement mesurée.

        // Récupérez la commande mise à jour
        Order updatedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :ord.Id]; // Récupère la commande mise à jour de la base de données.

        // Vérifiez que le montant net a été correctement calculé
        System.assertEquals(180, updatedOrder.NetAmount__c, 'Le montant net n\'a pas été correctement calculé dans la méthode beforeUpdate'); // Vérifie que le montant net de la commande est bien de 180. Si ce n'est pas le cas, le test échoue et le message d'erreur est affiché.
    }

    @isTest // Cette annotation indique que la méthode suivante est une méthode de test.
    static void testAfterUpdate() {
        // Récupérez la commande
        Order ord = [SELECT Id, AccountId, Status, TotalAmount FROM Order LIMIT 1]; // Récupère la première commande de la base de données.

        // Mettez à jour la commande
        ord.Status = 'Ordered'; // Modifie le statut de la commande à 'Ordered'.

        Test.startTest(); // Démarre la partie du test qui est réellement mesurée.
        update ord; // Met à jour la commande dans la base de données. Cela devrait déclencher le calcul du chiffre d'affaires du compte.
        Test.stopTest(); // Arrête la partie du test qui est réellement mesurée.

        // Récupérez le compte mis à jour
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :ord.AccountId]; // Récupère le compte mis à jour de la base de données.

        // Vérifiez que le chiffre d'affaires a été correctement calculé
        System.assertEquals(ord.TotalAmount, updatedAccount.Chiffre_d_affaire__c, 'Le chiffre d\'affaires n\'a pas été correctement calculé dans la méthode afterUpdate'); // Vérifie que le chiffre d'affaires du compte est bien égal au montant total de la commande. Si ce n'est pas le cas, le test échoue et le message d'erreur est affiché.
    }
}