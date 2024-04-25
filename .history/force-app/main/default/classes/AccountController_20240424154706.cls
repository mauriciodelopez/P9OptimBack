/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

//Classe contrôleur pour mettre à jour le champ Chiffre_d_affaire__c dans les enregistrements de Compte.
public with sharing class AccountController {
    //Méthode pour mettre à jour le champ Chiffre_d_affaire__c dans les enregistrements de Compte.
    public void updateChiffreDAffaire(List<Account> accounts) {
        // Vérifie si l'utilisateur actuel a des autorisations de mise à jour sur l'objet Compte    
        if (!Schema.sObjectType.Account.isUpdateable()) {
            // Gère le cas où l'utilisateur actuel n'a pas d'accès en écriture à l'objet Compte
            System.debug('Current user does not have update access to the Account object');
            return;
        }
        // Vérifie si l'utilisateur actuel a des autorisations de lecture sur l'objet Commande
        if (!Schema.sObjectType.Order.isAccessible()) {
            // Handle the case where the current user does not have read access to the Order object
            System.debug('Current user does not have read access to the Order object');
            return;
        }
        // Mappe les comptes par leur Id pour faciliter la mise à jour
        Map<Id, Account> accountMap = new Map<Id, Account>(accounts);
        // Consulte les commandes associées aux comptes fournis
        List<Order> orders = [SELECT Id, TotalAmount, AccountId FROM Order WHERE AccountId IN :accountMap.keySet()];

        // Initialise le champ Chiffre_d_affaire__c à zéro pour tous les comptes
        for(Account acc : accountMap.values()) {
            acc.Chiffre_d_affaire__c = 0;
        }

        // Itère sur les commandes et ajoute le TotalAmount à Chiffre_d_affaire__c dans les comptes correspondants
        for(Order ord : orders) {
            Account acc = accountMap.get(ord.AccountId);
            if(acc != null) {
                acc.Chiffre_d_affaire__c += ord.TotalAmount;
            }
        }

        try {
            // Tente de mettre à jour les comptes dans Salesforce
            update accountMap.values();
        } catch (DmlException e) {
            // Handle the case where the update operation fails
            System.debug('Failed to update accounts: ' + e.getMessage());
        }
    }
}
