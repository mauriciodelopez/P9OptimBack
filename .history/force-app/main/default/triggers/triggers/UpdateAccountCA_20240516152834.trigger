/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/













/*
trigger UpdateAccountCA on Order (after update) {
    // Crear un mapa para almacenar el total de cada cuenta
    Map<Id, Double> accountTotals = new Map<Id, Double>();

    // Recorrer las órdenes
    for(Order ord : Trigger.new) {
        // Añadir el total de la orden al total de la cuenta en el mapa
        if(accountTotals.containsKey(ord.AccountId)) {
            accountTotals.put(ord.AccountId, accountTotals.get(ord.AccountId) + ord.TotalAmount);
        } else {
            accountTotals.put(ord.AccountId, ord.TotalAmount);
        }
    }

    // Consultar las cuentas
    List<Account> accountsToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountTotals.keySet()];
    // Actualizar las cuentas
    for(Account acc : accountsToUpdate) {
        acc.Chiffre_d_affaire__c += accountTotals.get(acc.Id);
    }
    update accountsToUpdate;
}