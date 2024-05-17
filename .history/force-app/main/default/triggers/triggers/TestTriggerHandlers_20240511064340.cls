/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest // Cette annotation indique que cette classe est une classe de test.
public class TestTriggerHandlers {
    @testSetup // Cette annotation indique que la méthode suivante est utilisée pour configurer les données de test.
    static void setup() {
        // Créer des données de test
        List<Account> testAccounts = TestDataFactory.createAccounts(5); // Crée 5 comptes de test
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(accounts);
    }

    @isTest
    static void orderUpdateCalculationsTriggerTest() {
        // Récupérer les données de test
        List<Account> testAccounts = [SELECT Id FROM Account];
        List<Order> testOrders = [SELECT Id FROM Order];
    
        // Effectuer une opération qui déclenchera le déclencheur CalculMontant
        for(Order ord : testOrders) {
            ord.Status = 'Draft';//use 'Draft' comment la valeur de status 
            ord.EffectiveDate = Date.today(); //met à jour la date effective
        }
        update testOrders;
    
        // Récupérer les commandes mises à jour
        List<Order> updatedOrders = [SELECT Id, NetAmount__c FROM Order];
    
        // Vérifier que le déclencheur CalculMontant a mis à jour le champ NetAmount__c
        for(Order ord : updatedOrders) {
            System.assertEquals(ord.TotalAmount - ord.ShipmentCost__c, ord.NetAmount__c, 'NetAmount__c non sest pas claculé correctament');
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
