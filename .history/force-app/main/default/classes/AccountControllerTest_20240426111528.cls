/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-26-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class AccountControllerTest {

    @testSetup
    static void setup() {
        // Créer des comptes de test
        List<Account> accounts = TestDataFactory.createAccounts(200);
        System.assertEquals(200, accounts.size(), 'TestDataFactory.createAccounts should create exactly 20 accounts');
        //Insert les enregistrements de compte dans la base de données
        insert accounts;
    }
    
    @isTest
    static void testCreateAccounts() {

        // Récupérer les comptes créés dans la méthode de configuration du test Setup()
        List<Account> accounts = [SELECT Id, Name FROM Account];

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
        List<Account> accounts = [SELECT Id, Name FROM Account];

        // Créer une instance de AccountController
        AccountController controller = new AccountController();

        // Verifica que las cuentas no sean null antes de llamar a updateChiffreDAffaire
        if (accounts != null) {
                    controller.updateChiffreDAffaire(accounts);
                }


        // Récupérer les comptes mis à jour
        List<Account> accountsAfterUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        
        // Vérifier que le champ Chiffre_d_affaire__c a été mis à jour correctement pour chaque compte
        for(Account acc : accountsAfterUpdate) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Le champ Chiffre_d_affaire__c n\'a pas été mis à jour');
        }
    }

    @isTest
    static void testCreateOrdersAndCAUpdate() {
        //Test pour créer des commandes avec une valeur et mettre à jour le CA

        //Récuperer les comptes crées dans la méthode de configuration du test Setup()
        List<Account> accounts = [SELECT Id, Name FROM Account];

        //Créer une commande pour chaque compte avec un montant de 50€
        for (Account acc : accounts) {
            TestDataFactory.createOrderWithAmount(50);
        }
        //Start the test context
        Test.startTest();

        // Mettre à jour les comptes pour activer le trigger sur update
        update accounts;

        // Stop the test context
        Test.stopTest();

        // Vérifier que le CA Chiffre_d_affaires__c de chaque compte a été mis à jour correctement
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaires__c FROM Account WHERE Id IN :accounts];
        for(Account accUpdated : updatedAccounts) {
            System.assertEquals(50, acc.Chiffre_d_affaires__c, 'Le champ Chiffre_d_affaires__c n\'a pas été mis à jour correctement');
        }
    }

    @isTest
    static void testAddorderToCa() {
        //Test pour ajouter une commande au CA éxistant, car dans le test précedant 
        //supprime la valeur actuelle du CA pour chaque compte et la remplace par 50€
        //Récupérer les comptes exixtants du setup
        List<Account> accounts = [SELECT Id, Chiffre_d_affaires__c FROM Account];

        //Sauvegarder le CA initial de chaque compte
        Map<Id,Decimal> initialCAs = new Map<Id,Decimal>();
        for(Account acc : accounts){
            initialCAs.put(acc.Id, acc.Chiffre_d_affaires__c);
        }

        // Créer une nouvelle commande pour chaque compte avec un montant de 50€
        for(Account acc : accounts){
            TestDataFactory.createOrderWithAmount(50);
        }

        // Start the test context
        Test.startTest();

        // Mettre à jour les comptes pour déclencher le trigger sur update
        update accounts;

        //Stop the test context
        Test.stopTest();

        //Vérifier que le CA de chaque compte a été mis à jour correctement 
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaires__c FROM Account WHERE Id IN :accounts];
        for(Account accUpated :)



        
    }
}