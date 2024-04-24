/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class AccountControllerTest {
    static List<Account> accounts;

    @testSetup
    static void setup() {
        // Créer des comptes de test
        accounts = TestDataFactory.createAccounts(200);
        //Elimination de tout assignation ID aux registres de compte
        for(Account account : accounts){
            account.Id = null;
        
        insert accounts;
    }

    @isTest
    static void testCreateAccounts() {
        // Récupérer les comptes créés dans la méthode de configuration du test Setup()
        accounts = [SELECT Id, Name FROM Account];
        // Vérifier que le nombre de comptes créés correspond au nombre attendu
        System.assertEquals(200, accounts.size(), 'Le nombre de comptes créés ne correspond pas au nombre attendu');
        // Vérifier que le nom de chaque compte correspond au modèle attendu
        for(Integer i = 0; i < accounts.size(); i++) {
            String expectedName = 'Test Account ' + (i + 1);
            System.assertEquals(expectedName, accounts[i].Name, 'Le nom du compte ne correspond pas au modèle attendu');
        }
    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Créer une instance de AccountController
        AccountController controller = new AccountController();

        Test.startTest();
        // Appeler la méthode updateChiffreDAffaire() pour mettre à jour le champ Chiffre_d_affaire__c des comptes
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Récupérer les comptes mis à jour
        accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        // Vérifier que le champ Chiffre_d_affaire__c a été mis à jour correctement pour chaque compte
        for(Account acc : accounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Le champ Chiffre_d_affaire__c n\'a pas été mis à jour');
        }
    }
}