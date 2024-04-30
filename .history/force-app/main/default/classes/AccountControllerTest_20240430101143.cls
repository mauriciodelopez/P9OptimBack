/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
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
static void testCreateOrdersForAccounts() {
    // Obtenir les comptes crées dans la méthode @TestSetup
    List<Account> testAccounts = [SELECT id, Name FROM Account];
    
    // Appeler la méthode createorderForAccounts de la classe TestDataFactory
    Integer numOrdersPerAccount = 1;
    Decimal pricePerOrder = 100.0;
    List<Order> orders = TestDataFactory.createOrdersForAccounts(testAccounts, numOrdersPerAccount, pricePerOrder)

    // Vérifier que les ordres ont bien été créées pour chaque compte
    System.assertEquals(numOrdersPerAccount * testAccounts.)
    // Crear datos de prueba para las cuentas
    List<Account> testAccounts = new List<Account>();
    for (Integer i = 0; i < 5; i++) {
        testAccounts.add(new Account(Name = 'Test Account ' + i));
    }
    insert testAccounts;

    // Llamar al método createOrdersForAccounts con los datos de prueba
    Integer numOrdersPerAccount = 3;
    TestDataFactory.createOrdersForAccounts(testAccounts, numOrdersPerAccount);

    // Verificar que se crearon las órdenes correctas
    List<Order> orders = [SELECT Id, AccountId FROM Order];
    System.assertEquals(numOrdersPerAccount * testAccounts.size(), orders.size(), 'Se deben crear las órdenes correctas');

    // Verificar que el campo Chiffre_d_affaires__c de cada cuenta se actualizó correctamente
    for (Account acc : [SELECT Id, Chiffre_d_affaires__c FROM Account WHERE Id IN :testAccounts]) {
        // Aquí debes reemplazar 'expectedChiffreDAffaires' con el valor esperado para Chiffre_d_affaires__c
        System.assertEquals(expectedChiffreDAffaires, acc.Chiffre_d_affaires__c, 'Chiffre_d_affaires__c debe actualizarse correctamente');
    }
}
    //crear un test que verifique si una lista de cuentas es nula 
    @isTest
    static void testUpdateNullList() {
        // Lista de cuentas vacia
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(null);
        List<Account> updateAccounts=[SELECT Id, Chiffre_d_affaire__c FROM Account];
        for(Account acc:updateAccounts){
            System.assertEquals(null, acc.Chiffre_d_affaire__c, 'El campo debe ser 0');

        }
    }
    @isTest
    static void testAccountuserModify(){
        //Escribe un método de prueba que ejecute updateChiffreDAffaire con un usuario que no tenga permisos de actualización en el objeto Account
        AccountController controller = new AccountController();

        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        controller.updateChiffreDAffaire(new List<Account>{testAccount});
        //Verifica que no se imprima ningun mensaje, indicando que la cuenta se actualizó
        System.assert(ApexPages.currentPage().getParameters().get('message')==null);
        
    }
}

