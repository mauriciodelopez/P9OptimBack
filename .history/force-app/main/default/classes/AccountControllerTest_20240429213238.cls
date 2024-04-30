/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class AccountControllerTest {

    @testSetup
    static void setup() {
        // Créer des comptes de test
        List<Account> accounts = TestDataFactory.createAccounts(200);
        System.assertEquals(200, accounts.size(), 'TestDataFactory.createAccounts should create exactly 200 accounts');
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
        //Ce test vérifie si la méthode updateChiffreDAffaire de la classe AccountController
        // met à jour correctement le champ Chiffre_d_affaire__c de chaque compte.
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
    static void testAccountOrderUpdateCA() {
        //Test pour créer des commandes avec une valeur et mettre à jour le CA
        //Création de 200 accounts
        List<Account> accounts = TestDataFactory.createAccounts(200);
        insert accounts;

        // Créer des ordres pour chaque compte avec un article pour une valeur de 50€
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts, 1, 50.0, 1);
        for(Order order : orders) {
            order.Status = 'Ordered';
        }
        insert orders;

        // Mettre à jour le CA de chaque compte
        TestDataFactory.updateChiffreDAffaire(accounts);

        // Vérifier que le CA a été mis à jour correctement
        List<Account> accountsAfterUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account acc : accountsAfterUpdate) {
            System.assertEquals(50.0, acc.Chiffre_d_affaire__c, 'Le CA n\'a pas été mis à jour correctement');
        }   
    }

    
    //crear un test que verifique si una lista de cuentas es nula 
    @isTest
    static void testUpdateNullList() {
        // Lista de cuentas vacia
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(null);
        List<Account> updateAccounts =[SELECT Id, Chiffre_d_affaire__c FROM Account];
        System.assertEquals(0, updateAccounts.size(), 'La lista de cuentas no deberia ser nula');
    }
}