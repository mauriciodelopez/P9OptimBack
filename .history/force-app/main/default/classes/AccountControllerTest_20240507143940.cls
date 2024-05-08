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
        List<Account> accounts = new List<Account>{
        new Account(Name = 'Test Account 1'),
        new Account(Name = 'Test Account 2')
        };
        insert accounts;

        // Create two orders for each account
        List<Order> orders = new List<Order>{
        new Order(AccountId = accounts[0].Id, Status = 'Draft'),
        new Order(AccountId = accounts[0].Id, Status = 'Draft'),
        new Order(AccountId = accounts[1].Id, Status = 'Draft'),
        new Order(AccountId = accounts[1].Id, Status = 'Draft')
    };
    insert orders;

    // Create OrderItems with specific UnitPrice and Quantity values
    List<OrderItem> orderItems = new List<OrderItem>{
        new OrderItem(OrderId = orders[0].Id, UnitPrice = 100.0, Quantity = 1),
        new OrderItem(OrderId = orders[1].Id, UnitPrice = 200.0, Quantity = 1),
        new OrderItem(OrderId = orders[2].Id, UnitPrice = 300.0, Quantity = 1),
        new OrderItem(OrderId = orders[3].Id, UnitPrice = 400.0, Quantity = 1)
    };
    
    insert orderItems;

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