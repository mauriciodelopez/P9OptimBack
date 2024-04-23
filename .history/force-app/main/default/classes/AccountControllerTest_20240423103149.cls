/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@isTest
    public with sharing class AccountControllerTest {
    //methode de configuration du test 
    @TestSetup
    static void setup() {
    // Création de 10 accounts
    TestDataFactory.createAccounts(10);
    }
    //methode du test pour la creation des comptes
    @isTest
    static void testCreateAccounts() {
        // Definir la variable accounts like una liste d'objets Account
        List<Account> accounts = new List<Account>();

        //Récupérer les comptes créés dans la méthode de configuration du test Setup()
        accounts = [SELECT Id FROM Account];

        //vérifier que les 10 comptes ont été crées
        System.assertEquals(10, accounts.size(), 'Nous attendonds 10 comptes créés');

        //vérífier que les nombres de les comptes suivant le patron attendu
        for(Integer i = 0; i < accounts.size(); i++) {
            String expectedName = 'Test Account' + i;
            System.assertEquals(expectedName, accounts[i].Name, 'Le nom du compte ne correspond pas au modèle attendu');
        
        }
    }

    @isTest
static void testUpdateChiffreDAffaire() {
    // Recuperer una cuenta creada en el método de configuración del test Setup()
    List<Account> testAccounts = [SELECT Id FROM Account LIMIT 1];

    // Establecer un nuevo valor para Chiffre_d_affaire__c
    Decimal newChiffreDAffaire = 1000.00;

    // Crear una instancia del controlador y actualizar Chiffre_d_affaire__c
    AccountController controller = new AccountController();
    controller.updateChiffreDAffaire(testAccount.Id, newChiffreDAffaire);

    // Recuperar la cuenta actualizada
    Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];

    // Verificar que Chiffre_d_affaire__c se ha actualizado correctamente
    System.assertEquals(newChiffreDAffaire, updatedAccount.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c no se actualizó correctamente');
}
}













/**
@isTest
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Création de 10 accounts
        List<Account> testAccounts = TestDataFactory.createAccounts(10);

        // Création de 5 orders pour chaque account
        List<Order> testOrders = TestDataFactory.createOrders(testAccounts, 5);

        // Création de 3 artícles de commande pour chaque commande avec un prix unitaire de 100.0, une quantité de 2 et 3 articles per commande
        TestDataFactory.createOrderItems(testOrders, 100.0, 2, 3);

        // Mettre à jour ChiffreDAffaire pour chaque compte
        TestDataFactory.updateChiffreDAffaire(testAccounts);
    }
}
**/
