/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class MyTeamOrdersControllerTest {
    // Méthode de configuration des données de test utilisant @testSetup
    @testSetup
    static void setupTestData() {
        // Création d'une commande de test avec un montant spécifique
        Decimal montantTest = 100.00;
        TestDataFactory.createOrderWithAmount(montantTest);
    }

    // Test de la logique du contrôleur
    @isTest
    static void testControllerLogic() {
        // Création d'une instance du contrôleur que nous testons
        MyTeamOrdersController controller = new MyTeamOrdersController();
        
        // Vérification que la somme des montants des commandes est égale au montant de la commande de test
        System.assertEquals(100.00, controller.sumOrders, 'La somme des montants des commandes n\'est pas correcte');
    }

    @
}
