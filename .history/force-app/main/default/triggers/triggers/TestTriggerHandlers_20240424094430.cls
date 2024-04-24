/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest // Cette annotation indique que cette classe est une classe de test.
public class TestTriggerHandlers {
    @testSetup // Cette annotation indique que la méthode suivante est utilisée pour configurer les données de test.
    static void setup() {
        // Créer des données de test
        List<Account> testAccounts = TestDataFactory.createAccounts(5); // Crée 5 comptes de test
        List<Order> testOrders = TestDataFactory.createOrders(testAccounts, 3); // Crée 3 commandes de test pour chaque compte
    }

    @isTest
    static void orderUpdateCalculationsTriggerTest() {
        // Récupérer les données de test
        List<Account> testAccounts = [SELECT Id FROM Account];
        List<Order> testOrders = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE AccountId IN :testAccounts];
    
        // Effectuer une opération qui déclenchera le déclencheur CalculMontant
        for(Order ord : testOrders) {
            ord.Status = 'Draft';//use 'Draft' comment la valeur de status 
            ord.e
        }
        update testOrders;
    
        // Récupérer les commandes mises à jour
        List<Order> updatedOrders = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id IN :testOrders];
    
        // Vérifier que le déclencheur CalculMontant a mis à jour le champ NetAmount__c
        for(Order ord : updatedOrders) {
            System.assertEquals(ord.TotalAmount - ord.ShipmentCost__c, ord.NetAmount__c, 'NetAmount__c no se calculó correctamente');
        }
    
        // Récupérer les comptes mis à jour
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c, (SELECT Id, TotalAmount FROM Orders WHERE Status = 'Ordered') FROM Account WHERE Id IN :testAccounts];
    
        // Vérifier que le déclencheur CalculMontant a mis à jour le champ Chiffre_d_affaire__c
        for(Account acc : updatedAccounts) {
            Double expectedChiffre = 0;
            for(Order ord : acc.Orders) {
                expectedChiffre += ord.TotalAmount;
            }
            System.assertEquals(expectedChiffre, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c no se calculó correctamente');
        }
    }

}
