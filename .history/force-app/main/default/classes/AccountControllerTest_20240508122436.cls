/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-08-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AccountControllerTest {
    @testSetup
    static void setup() {
        // Create  accounts
        List<Account> accounts = TestDataFactory.createAccounts(5);

        // Get the standard pricebook ID
        String pricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        

        // Create two orders for each account
        TestDataFactory.createOrdersForAccounts(accounts, 2);

        // Create order items for all accounts
        TestDataFactory.createOrderItemsForAccounts(accounts, 2); // Create order items for all accounts
    }
        
    

    @isTest
    static void testUpdateChiffreDAffaireWithError() {
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
        // Verify that the Chiffre_d_affaire__c field has been correctly updated for the first account
        System.assertEquals(200.0, updatedAccounts[0].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the first account should be 200.0');
        System.assertEquals(0.0, updatedAccounts[1].Chiffre_d_affaire__c, 'Chiffre_d_affaire__c for the second account should be 0.0');
    }
}