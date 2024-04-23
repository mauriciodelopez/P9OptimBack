/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-23-2024
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

    @isTest // Cette annotation indique que la méthode suivante est une méthode de test.
    static void testCalculMontantTrigger() {
        // Récupérer les données de test
        List<Account> testAccounts = [SELECT Id FROM Account]; // Sélectionne tous les comptes
        List<Order> testOrders = [SELECT Id FROM Order WHERE AccountId IN :testAccounts]; // Sélectionne toutes les commandes associées aux comptes

        // Effectuer une opération qui déclenchera le déclencheur CalculMontant
        for(Order ord : testOrders) {
            ord.Status = 'Draft'; // Change le statut de chaque commande à 'Draft'
        }
        update testOrders; // Met à jour les commandes dans la base de données, ce qui déclenche le déclencheur CalculMontant

        // Ici, vous pouvez ajouter des assertions pour vérifier que le déclencheur CalculMontant a fonctionné comme prévu
    }

    @isTest // Cette annotation indique que la méthode suivante est une méthode de test.
    static void testOrderUpdateTrigger() {
        // Récupérer les données de test
        List<Account> testAccounts = [SELECT Id FROM Account]; // Sélectionne tous les comptes
        List<Order> testOrders = [SELECT Id FROM Order WHERE AccountId IN :testAccounts]; // Sélectionne toutes les commandes associées aux comptes

        // Effectuer une opération qui déclenchera le déclencheur OrderUpdateTrigger
        for(Order ord : testOrders) {
            ord.Status = 'Activated'; // Change le statut de chaque commande à 'Activated'
        }
        update testOrders; // Met à jour les commandes dans la base de données, ce qui déclenche le déclencheur OrderUpdateTrigger

        // Ici, vous pouvez ajouter des assertions pour vérifier que le déclencheur OrderUpdateTrigger a fonctionné comme prévu
    }
}