/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class MyTeamOrdersController {
    public List<User> teamMembers { get; set; }
    public Map<Id, Decimal> sumOrdersByUser { get; set; }
    public Decimal sumOrders { get; set; } // Nouvelle propriété pour stocker la somme totale des commandes

    public MyTeamOrdersController() {
        // Vérifie si l'objet User est accessible
        if (Schema.sObjectType.User.isAccessible()) {
            // Récupérer tous les membres de l'équipe
            teamMembers = [SELECT Id FROM User WHERE UserRole.Name = 'Commercial' AND IsActive = true];
        } else {
            // Gère le cas où l'utilisateur actuel n'a pas accès en lecture à l'objet User
            System.debug('L\'utilisateur actuel n\'a pas accès en lecture à l\'objet User');
            return;
        }

        // Initialiser la map pour stocker la somme des commandes pour chaque commercial
        sumOrdersByUser = new Map<Id, Decimal>();

        // Vérifie si l'objet Order est accessible
        if (Schema.sObjectType.Order.isAccessible()) {
            // Exécuter une requête SOQL pour obtenir la somme du champ TotalAmount des commandes associées à chaque commercial
            List<AggregateResult> groupedResults = [SELECT OwnerId, SUM(TotalAmount) total FROM Order WHERE OwnerId IN :teamMembers GROUP BY OwnerId];
            // Stocker la somme des commandes dans la map, avec l'Id du commercial comme clé
            for (AggregateResult ar : groupedResults) {
                sumOrdersByUser.put((Id)ar.get('OwnerId'), (Decimal)ar.get('total'));
            }
            // Calculer la somme totale des commandes
            sumOrders = 0;
            for (Decimal amount : sumOrdersByUser.values()) {
                sumOrders += amount;
            }
        } else {
            // Gère le cas où l'utilisateur actuel n'a pas accès en lecture à l'objet Order
            System.debug('L\'utilisateur actuel n\'a pas accès en lecture à l\'objet Order');
        }
    }
}
