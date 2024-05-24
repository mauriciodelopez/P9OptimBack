/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Création de 50 comptes de test
        List<Account> accounts = TestDataFactory.createAccounts(50);


    @isTest
    static void testUpdateChiffreDAffaire() {
        // Obtenez les comptes créés dans la méthode @testSetup
        List<Account> accounts = [SELECT Id, Name FROM Account];

        

        // Créez une instance de Controller (AccountController()) et appelez la méthode updateChiffreDAffaire
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Vérifiez que le champ Chiffre_d_affaire__c a été mis à jour correctement
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c ne doit pas être null');
            System.assertEquals(100.0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c doit être 100.0');
        }
    }    
}