/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class MyTeamOrdersController {
    // Déclaration d'une variable publique pour stocker la somme des commandes
    public Decimal sumOrders { get; set; }

    public MyTeamOrdersController() {
        // Vérifie si l'objet Order est accessible
        if (Schema.sObjectType.Order.isAccessible()) {
            try {
                // Exécute une requête SOQL pour obtenir la somme du champ TotalAmount de tous les enregistrements Order
                AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
                // Convertit le résultat en Decimal et le stocke dans la variable sumOrders
                sumOrders = (Decimal)groupedResults.get('total');
            } catch (Exception e) {
                // Gère l'exception comme il convient pour votre cas d'utilisation
                System.debug('Une erreur s\'est produite: ' + e.getMessage());
            }
        } else {
            // Gère le cas où l'utilisateur actuel n'a pas accès en lecture à l'objet Order
            System.debug('L\'utilisateur actuel n\'a pas accès en lecture à l\'objet Order');
        }
    }
}
