/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * Ce code est un  gestionnaire de déclencheur Apex.
 * Il définit des actions à effectuer avant et après la mise à jour des enregistrements Order.
 **/

// Déclaration d'une classe avec le modificateur 'inherited sharing'. Cela signifie que la classe respecte les règles de partage de l'objet pour lequel elle est utilisée.
public inherited sharing class OrderTriggerHandler {

    // Méthode qui est appelée avant la mise à jour des enregistrements Order
    public static void beforeUpdate(List<Order> newOrders, Map<Id, Order> oldMap) {
        // Boucle sur la liste des nouveaux enregistrements Order
        for(Order ord : newOrders) {
            // Calcule le montant net en soustrayant le coût d'expédition du montant total
            if(ord.Tota)    
            ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
        }
    }

    // Méthode qui est appelée après la mise à jour des enregistrements Order
    public static void afterUpdate(List<Order> newOrders, Map<Id, Order> oldMap) {
        // Crée un ensemble pour stocker les Ids des comptes
        Set<Id> accountIds = new Set<Id>();
        // Boucle sur la liste des nouveaux enregistrements Order
        for(Order ord : newOrders) {
            // Vérifie si le statut de l'ordre est 'Ordered' et si le statut précédent n'était pas 'Ordered'
            if(ord.Status == 'Ordered' && oldMap.containsKey(ord.Id) && (oldMap.get(ord.Id).Status != 'Ordered')) {
                // Ajoute l'Id du compte à l'ensemble des Ids de compte
                accountIds.add(ord.AccountId);
            }
        }

        // Vérifie si l'ensemble des Ids de compte n'est pas vide
        if(!accountIds.isEmpty()) {
            // Exécute une requête SOQL pour obtenir les comptes et leurs commandes correspondantes
            Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c, (SELECT Id, TotalAmount FROM Orders WHERE Status = 'Ordered') FROM Account WHERE Id IN :accountIds]);
            // Boucle sur les comptes
            for(Account acc : accounts.values()) {
                // Réinitialise le chiffre d'affaires du compte
                acc.Chiffre_d_affaire__c = 0;
                // Boucle sur les commandes du compte
                for(Order ord : acc.Orders) {
                    // Ajoute le montant total de la commande au chiffre d'affaires du compte
                    acc.Chiffre_d_affaire__c += ord.TotalAmount;
                }
            }

            // Met à jour les comptes dans la base de données
            update accounts.values();
        }
    }
}
