/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AccountControllerTest {
    @testSetup
    static void setup() {
        // Create two accounts
        List<Account> accounts = TestDataFactory.createAccounts(200);

        // Get the standard pricebook ID
        Id pricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;

        // Create two orders for each account
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 2);

        // Create OrderItems with specific UnitPrice and Quantity values
        TestDataFactory.createOrderItemsForAccounts(accounts, 2), pricebookId);
    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Récupérez les comptes créés dans la méthode de configuration
        List<Account> accounts = [SELECT Id FROM Account];

        // Commencez la partie du test qui est mesurée pour les limites de gouverneur
        Test.startTest();

        // Appellez la méthode updateChiffreDAffaire
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);

        // Arrêtez la partie du test qui est mesurée pour les limites de gouverneur
        Test.stopTest();

        // Récupérez les comptes mis à jour
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];

        // Vérifiez que le champ Chiffre_d_affaire__c a été correctement mis à jour
        System.assertEquals(300.0, updatedAccounts[0].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the first account should be 300.0');
        System.assertEquals(700.0, updatedAccounts[1].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the second account should be 700.0');
    }
}