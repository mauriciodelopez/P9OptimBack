/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-27-2024
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
    static void testCreateOrdersAndCAUpdate() {
        // Test pour créer des commandes avec une valeur et mettre à jour le CA
    
        // Récupérer les comptes créés dans la méthode de configuration du test Setup()
        List<Account> accounts = TestDataFactory.createAccounts(200);
    
        // Définir la date effective et le statut pour la nouvelle commande
        Date effectiveDate = Date.today();
        String status = 'Draft';
        
        // Créer une commande pour chaque compte avec un montant de 50€
        for (Account acc : accounts) {
            // Créer l'ordre et l'ajouter à la liste des ordres
            Order order = TestDataFactory.createOrderWithAmount(50.0, Date.today(), 'Draft');
            order.AccountId = acc.Id; // Définir l'ID du compte sur l'ordre
        }
        
        // Démarrer le contexte de test
        Test.startTest();
    
        // Mettre à jour les comptes pour déclencher le déclencheur lors de la mise à jour
        update accounts;
    
        // Arrêter le contexte de test
        Test.stopTest();
    
        // Vérifier que le CA Chiffre_d_affaires__c de chaque compte a été mis à jour correctement
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account accUpdated : updatedAccounts) {
            System.assertEquals(10000.0, accUpdated.Chiffre_d_affaire__c, 'Le champ Chiffre_d_affaires__c n\'a pas été mis à jour correctement');
        }
    }
    /**
    @isTest
    static void testAddOrderToCA() {
        //Test pour ajouter une commande au CA éxistant, car dans le test précedant 
        //supprime la valeur actuelle du CA pour chaque compte et la remplace par 50€
        //Récupérer les comptes exixtants du setup
        List<Account> accounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];

        //Sauvegarder le CA initial de chaque compte
        Map<Id,Decimal> initialCAs = new Map<Id,Decimal>();
        for(Account acc : accounts){
            initialCAs.put(acc.Id, acc.Chiffre_d_affaire__c);
        }

        // Créer une nouvelle commande pour chaque compte avec un montant de 50€
        for(Account acc : accounts){
            TestDataFactory.createOrderWithAmount(50.0, Date.today(), 'Draft');
        }

        // Start the test context
        Test.startTest();

        // Mettre à jour les comptes pour déclencher le trigger sur update
        update accounts;

        //Stop the test context
        Test.stopTest();

        //Vérifier que le CA de chaque compte a été mis à jour correctement 
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];//Cette ligne exécute une requête SOQL (Salesforce Object Query Language) pour sélectionner les comptes mis à jour depuis la base de données. Elle récupère l'ID de chaque compte ainsi que son chiffre d'affaires actuel (stocké dans le champ Chiffre_d_affaires__c). La clause WHERE Id IN :accounts filtre les comptes en fonction des ID fournis dans la liste accounts.
        //boucle for qui itère à travers chaque compte dans la liste updatedAccounts. À chaque itération, le compte mis à jour est référencé par la variable accUpdated.
        for(Account accUpdated : updatedAccounts) {
            Decimal initialCA = initialCAs.get(accUpdated.Id);//Cette ligne récupère le chiffre d'affaires initial du compte à partir de la map initialCAs, en utilisant l'ID du compte (accUpdated.Id) comme clé. La valeur correspondante (le chiffre d'affaires initial) est stockée dans la variable initialCA
            Decimal expectedCA = initialCA != null ? initialCA + 50.0 : 50.0;//Cette ligne calcule le chiffre d'affaires attendu après l'ajout de la nouvelle commande. Si le chiffre d'affaires initial (initialCA) n'est pas nul, alors le nouveau chiffre d'affaires sera égal à l'ancien chiffre d'affaires plus 50. Sinon, si le chiffre d'affaires initial est nul (ce qui signifie qu'il n'y avait pas de chiffre d'affaires précédent), le nouveau chiffre d'affaires sera simplement de 50.
            System.assertEquals(expectedCA, accUpdated.Chiffre_d_affaire__c, 'Le champ Chiffre_d_affaire__c n\'a pas été mis à jour correctement avec l\'ajout de la nouvelle commande (montant 50€).');    
        }
    }
}