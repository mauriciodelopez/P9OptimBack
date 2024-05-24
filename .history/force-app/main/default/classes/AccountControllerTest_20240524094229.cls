/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Création de 200 comptes de test
        List<Account> accounts = TestDataFactory.createAccounts(50);

        List<Order> allOrders = new List<Order>();
        for(Account acc : accounts) {
            // Création de 100 commandes pour chaque compte
            List<Order> orders = TestDataFactory.createOrdersMass(acc.Id, 'Draft', 100);
            allOrders.addAll(orders);
        }
        insert allOrders; // Insérez toutes les commandes en une seule opération

        // Création de 1 OrderItems, Products et PricebookEntries pour chaque commande
        List<OrderItem> allOrderItems = new List<OrderItem>();
        for(Order ord : allOrders) {
            List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithProductsAndPricebookEntries(ord.Id, 'Draft', 50, 1, 100, 1);
            for(OrderItem oi : orderItems) {
                oi.Ordered = true; // Ajoutez cette ligne pour définir le champ "Ordered" à true
            }
            allOrderItems.addAll(orderItems);
        }
        insert allOrderItems; // Insérez tous les OrderItems, Products et PricebookEntries en une seule opération
    
        // Mise à jour des commandes au statut 'Ordered'
        for(Order ord : allOrders) {
            ord.Status = 'Ordered';
        }
        update allOrders;
    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Obtenez les comptes créés dans la méthode @testSetup
        List<Account> accounts = [SELECT Id, Name FROM Account];

        // Créez une instance de Controller (AccountController()) et appelez la méthode updateChiffreDAffaire
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Vérifiez que le champ Chiffre_d_affaire__c a été mis à jour correctement
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c ne doit pas être null');
            System.assertEquals(100.0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c doit être 100.0');
        }
    }    
}