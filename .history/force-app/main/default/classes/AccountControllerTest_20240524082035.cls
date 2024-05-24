/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Création de 200 comptes de test
        List<Account> accounts = TestDataFactory.createAccounts(200);

        for(Account acc : accounts) {
            // Création de 200 commandes pour chaque compte
            List<Order> orders = TestDataFactory.createOrdersMass(acc.Id, 'Draft', 200);
            insert orders; // Insérez les commandes ici
        
        
        

        // Création de 5 OrderItems, Products et PricebookEntries pour chaque commande
        for(Order ord : orders) {
            TestDataFactory.createOrderItemsWithProductsAndPricebookEntries(ord.Id, 'Draft', 200, 1, 100, 5);
        }
        
        }

        
        
        
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