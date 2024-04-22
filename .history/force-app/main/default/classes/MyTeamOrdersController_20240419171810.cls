/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class MyTeamOrdersController {
    public List<User> teamMembers { get; set; }
    public Map<Id, Decimal> sumOrdersByUser { get; set; }

    public MyTeamOrdersController() {
        // Récupérer tous les membres de l'équipe
        teamMembers = [SELECT Id FROM User WHERE UserRole.Name = 'Commercial' AND IsActive = true];

        // Initialiser la map pour stocker la somme des commandes pour chaque commercial
        sumOrdersByUser = new Map<Id, Decimal>();

        // Parcourir tous les membres de l'équipe
        for (User u : teamMembers) {
            // Exécuter une requête SOQL pour obtenir la somme du champ TotalAmount des commandes associées à chaque commercial
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE OwnerId = :u.Id];
            // Stocker la somme des commandes dans la map, avec l'Id du commercial comme clé
            sumOrdersByUser.put(u.Id, (Decimal)groupedResults.get('total'));
        }
    }
}
