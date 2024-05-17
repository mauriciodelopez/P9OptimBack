/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Création des données de test 
        List<Account> accounts = TestDataFactory.createAccounts(200);
        insert accounts;

        // Crear órdenes para las cuentas
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);

        // Crear un producto
        Product2 product = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Crear una entrada de lista de precios para el producto
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100);

        // Crear un ítem de orden para cada orden
        TestDataFactory.createOrderItems(orders, pbe.Id, 1, 100);

        // Prendre les ID des Accounts ans une liste
        List<Id> accountIds = getAccountIds(accounts);
    }

    @is

    

  
}
