/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateAccountsBatchTest {

    // Méthode de test pour vérifier que le batch peut gérer un grand volume de données
    @isTest
    static void testBatchHandlesMassiveData() {
        // Créer un grand volume de données de test
        TestDataFactory.createMassiveData(200, 100);

        // Lancer le batch
        Test.startTest();
        UpdateAccountsBatch batch = new UpdateAccountsBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Effectuer des assertions pour vérifier le comportement attendu
        
        // Vérifier que les comptes ont été mis à jour correctement
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(0, acc.Chiffre_d_affaire__c, 'Le chiffre d\'affaires du compte ' + acc.Name + ' n\'a pas été mis à jour.');
        }
        
        // Vérifier que le nombre total de comptes mis à jour est égal au nombre de comptes créés
        Integer numUpdatedAccounts = [SELECT COUNT() FROM Account WHERE Chiffre_d_affaire__c > 0];
        System.assertEquals(200, numUpdatedAccounts, 'Le nombre de comptes mis à jour est incorrect.');
        
        // Vérifier que le batch a terminé avec succès
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status = 'Completed'];
        System.assertEquals(1, jobs.size(), 'Le batch n\'a pas été exécuté avec succès.');
        
        // Ajoute d'autres assertions au besoin pour vérifier d'autres aspects du comportement du batch
        // ...
    }
}
