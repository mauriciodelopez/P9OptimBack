/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * Ce code est une classe Apex qui implémente l'interface Database.Batchable<sObject>.
 * Cette interface est utilisée pour définir des travaux qui peuvent être traités en lots par Salesforce. 
 * Les travaux en lots sont utiles lorsque vous devez traiter un grand nombre d'enregistrements
 * comme des mises à jour de données en masse.
 * En résumé, ce travail en lots parcourt tous les comptes et pour chaque compte, il calcule le chiffre d'affaires en sommant le montant total de toutes les commandes liées à ce compte.
 **/

// Déclaration de la classe qui implémente l'interface Database.Batchable<sObject>
public class UpdateAccountsBatch implements Database.Batchable<sObject> {

    // La méthode start est appelée au début du travail en lots. Elle doit retourner un Database.QueryLocator qui spécifie les enregistrements à traiter.
    public Database.QueryLocator start(Database.BatchableContext info) { 
        // Ici, nous sélectionnons tous les comptes qui ont au moins une commande avec le statut "Ordered"
        return Database.getQueryLocator(
            'SELECT Id ' +
            'FROM Account ' +
            'WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')'
        );
    }
    
    // La méthode execute est appelée pour chaque lot d'enregistrements. Elle effectue l'opération principale du travail en lots.
    public void execute(Database.BatchableContext info, List<Account> scope) {
        // Crée une instance de AccountController
        AccountController controller = new AccountController();
        // Appelle la méthode updateChiffreDAffaire avec les comptes du lot actuel
        controller.updateAccountsWithOrderValue();
    }    
    
    // La méthode finish est appelée à la fin du travail en lots. Elle peut être utilisée pour effectuer des opérations de nettoyage ou pour envoyer des notifications.
    public void finish(Database.BatchableContext info) {
        // Ici, nous enregistrons simplement un message dans le journal de débogage
        System.debug('Batch process finished.');
    } 
}