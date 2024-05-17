/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateAccountsBatchTest {
    @testSetup static void setup() {
        // Crear datos de prueba
        List<Account> testAccounts = TestDataFactory.createAccounts(5);
        TestDataFactory.createOrdersForAccounts(testAccounts);
    }
    @isTest
    static void testUpdateAccountsBatch() {
        // Crear datos de prueba
        List<Account> testAccounts = TestDataFactory.createAccounts(5);
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(testAccounts);

        // Crear una instancia de UpdateAccountsBatch
        UpdateAccountsBatch batch = new UpdateAccountsBatch();

        // Llamar a Database.executeBatch
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verificar que los campos Chiffre_d_affaire__c se hayan actualizado correctamente
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        for (Account acc : updatedAccounts) {
            System.assertNotEquals(un, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c no se actualizó correctamente para la cuenta ' + acc.Id);
        }
    }

    @isTest
    static void testUpdateAccountsBatchWithNoOrderedAccounts() {
        // Crear datos de prueba
        List<Account> testAccounts = TestDataFactory.createAccounts(5);

        // Crear una instancia de UpdateAccountsBatch
        UpdateAccountsBatch batch = new UpdateAccountsBatch();

        // Llamar a Database.executeBatch
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verificar que los campos Chiffre_d_affaire__c no se hayan actualizado
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        for (Account acc : updatedAccounts) {
            if (acc.Chiffre_d_affaire__c == null) {
                System.assertEquals(0, null, 'Chiffre_d_affaire__c se actualizó incorrectamente para la cuenta ' + acc.Id);
            } else {
                System.assertEquals(0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c se actualizó incorrectamente para la cuenta ' + acc.Id);
            }
        }
    }

    @isTest
    static void testUpdateAccountsBatchWithAllOrderedAccounts() {
        // Crear datos de prueba
        List<Account> testAccounts = TestDataFactory.createAccounts(5);
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(testAccounts);

        // Crear una instancia de UpdateAccountsBatch
        UpdateAccountsBatch batch = new UpdateAccountsBatch();

        // Llamar a Database.executeBatch
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verificar que los campos Chiffre_d_affaire__c se hayan actualizado correctamente
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        //for (Account acc : updatedAccounts) {
            //System.assertNotEquals(0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c no se actualizó correctamente para la cuenta ' + acc.Id);
        //}
    }
}