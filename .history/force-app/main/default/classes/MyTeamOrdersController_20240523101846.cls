/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Calcule la somme des montants totaux des commandes 'Ordered' pour l'équipe de 
//l'utilisateur et l'utilisateur lui-même (si l'objet User est accessible).
public without sharing class MyTeamOrdersController {
    public Decimal sumOrders { get; set; } 

    public MyTeamOrdersController() {
        // Vérifie si l'objet User est accessible
        if (Schema.sObjectType.User.isAccessible()) {
            sumOrders = getSumOrders();
        } else {
            // Gère le cas où l'utilisateur actuel n'a pas accès en lecture à l'objet User
            System.debug('L\'utilisateur actuel n\'a pas accès en lecture à l\'objet User');
        }
    }

    public Decimal getSumOrders() {
        Id userId = UserInfo.getUserId();

        //Selectionner les enregistrement de Account Team Member 
        List<AccountTeamMember> members = [SELECT Id, AccountId FROM AccountTeamMember WHERE UserId = :userId];
        
        //Obtenir tous les Id des Accounts
        Set<Id> accountIds = new Set<Id>();
        for(AccountTeamMember member : members){
            accountIds.add(member.AccountId);
        }

        //Calculer la somme du montant total pour l'équipe de l'utilisateur en ligne
        List<Account> acc = [SELECT Id FROM Account WHERE Id IN :accountIds OR OwnerId = :userId];
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE AccountId IN :acc AND status ='Ordered'];
        return (decimal)groupedResults.get('total');
    }
}