/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-21-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Creation of test accounts 
        List<Account> accounts = TestDataFactory.createAccounts(200);
        

        // Creation orders for tha accounts 
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);

        // Creation a product
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Creation a pricebookentry for the product
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100);

        // Creation a order Item for each order 
        TestDataFactory.createOrderItems(orders, pbe.Id, 1, 100);

    }

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Get created accounts in @testSetup method
        List<Account> accounts = [SELECT Id, Name FROM Account];

        // CreatCrear una instancia del controlador y llamar al método updateChiffreDAffaire
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Verificar que el campo Chiffre_d_affaire__c se ha actualizado correctamente
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should not be null');

        }
    }    

    @isTest
    static void testUpdateCAWithOrder() {

        // Recuperar las cuentas creadas en el método @testSetup
        List<Account> accounts = [SELECT Id, Name FROM Account];

        // Crear una instancia del controlador y llamar al método updateChiffreDAffaire
        AccountController controller = new AccountController();
        Test.startTest();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();

        // Vérifeir que le champ Chiffre_d_affaire__c ce met a jour 
        for(Account acc : accounts) {
            System.assertEquals(100.0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be 100.0');
        }
    }

          

    
}















