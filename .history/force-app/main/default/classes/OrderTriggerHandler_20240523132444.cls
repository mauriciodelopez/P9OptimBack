/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * Ce code est un  gestionnaire de déclencheur Apex.
 * Il définit des actions à effectuer avant et après la mise à jour des enregistrements Order.
 **/

// Déclaration d'une classe avec le modificateur 'inherited sharing'. Cela signifie que la classe respecte les règles de partage de l'objet pour lequel elle est utilisée.
public inherited sharing class OrderTriggerHandler {
    //Ce code analyse chaque order dans une liste et s'assure que les champs
    //"Net Amount" y "Shipment Cost" no estén vacíos, y luego calcula el "Net Amount" restando el "Shipment Cost" del "Total Amount" para cada pedido. 
    // Méthode qui est appelée avant la mise à jour des enregistrements Order
    public static void beforeUpdate(List<Order> newOrders, Map<Id, Order> oldMap) {
        for(Order ord : newOrders){
            if(ord.NetAmount__c == null){
                ord.NetAmount__c = 0;
            }    
            if(ord.ShipmentCost__c == null){
                ord.ShipmentCost__c = 0;
            }
            
            // Update the "Net Amount" field using the formula NetAmount = TotalAmount - ShipmentCost
            if(ord.TotalAmount != null){
                ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
            } 
        }
    }

    // Méthode qui est appelée après la mise à jour des enregistrements Order
    public static void afterUpdate(List<Order> newOrders, Map<Id, Order> oldMap) {
        // Crée un ensemble pour stocker les Ids des comptes
        Set<Id> accountIds = new Set<Id>();
        // Boucle sur la liste des nouveaux enregistrements Order
        for(Order ord : newOrders) {
            // Vérifie si le statut de l'ordre est 'Ordered' et si le statut précédent n'était pas 'Ordered'
            if(ord.Status == 'Ordered' && oldMap.containsKey(ord.Id) && oldMap.get(ord.Id) != null && oldMap.get(ord.Id).Status != 'Ordered') {
                // Ajoute l'Id du compte à l'ensemble des Ids de compte
                if(ord.AccountId != null) {
                    accountIds.add(ord.AccountId);
                }
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
                    if(ord.TotalAmount != null) {
                        // Ajoute le montant total de la commande au chiffre d'affaires du compte
                        acc.Chiffre_d_affaire__c += ord.TotalAmount;
                    }
                }
                // Debug statement to log the updated Chiffre_d_affaire__c for each account
                System.debug('Updated Chiffre_d_affaire__c for Account with Id ' + acc.Id + ': ' + acc.Chiffre_d_affaire__c);
            }
        
            // Met à jour les comptes dans la base de données
            update accounts.values();
        } else {
            // Debug statement to log when there are no account IDs
            System.debug('No account IDs found in updated Orders');
        }   
        
    }
}
