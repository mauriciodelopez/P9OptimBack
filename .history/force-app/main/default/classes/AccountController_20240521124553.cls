/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-21-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

//AccountController, contains a method updateChiffreDAffaire that updates the Chiffre_d_affaire__c field in Account records.
public with sharing class AccountController {
    //Method to update Chiffre_d_affaire__c field les enregistrements de Compte.
    public void updateChiffreDAffaire(List<Account> accounts) {
         // checks if the list of accounts passed to the method is null or empty.
        if (accounts == null || accounts.isEmpty()) {
            System.debug('No accounts to update');
            return;
        }
        
        // Mappe les comptes par leur Id pour faciliter la mise à jour
        Map<Id, Account> accountMap = new Map<Id, Account>(accounts);

        // Consulte les commandes associées aux comptes fournis
        List<Order> orders = [SELECT Id, TotalAmount, AccountId FROM Order WHERE AccountId IN :accountMap.keySet()];

        // Initialize Chiffre_d_affaire__c to zero for accounts that have orders
        Set<Id> accountIdsWithOrders = new Set<Id>();
        for(Order ord : orders) {
            accountIdsWithOrders.add(ord.AccountId);
        }
        for(Id accountId : accountIdsWithOrders) {
            Account acc = accountMap.get(accountId);
            if(acc != null) {
                acc.Chiffre_d_affaire__c = 0;
            }
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
