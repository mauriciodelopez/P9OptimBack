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

        List<Product2> products = TestDataFactory.createProducts(1);
        Product2 product = products[0];
        Decimal unitPrice = 100; // prix unitaire pour les produits crées
        List<PricebookEntry> pricebookEntries = TestDataFactory.createPricebookEntries(products, unitPrice); // Passe le prix unitaire ici
        PricebookEntry pricebook = pricebookEntries[0];

        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        insert orders;

        
        
        
        
        
        
        
        

    }

    @isTest
    static void testAccountsCreation() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        System.assertEquals(200, accounts.size(), 'Número incorrecto de cuentas creadas');
    }

    // Test passed OK
    /*@isTest
    static void testAccountsCreation() { 
        // Verificar la creación de cuentas
        List<Account> accounts = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account WHERE Name LIKE 'TestAccount%'];

        System.assertEquals(200, accounts.size(), 'Número incorrecto de cuentas creadas');
        for(Account acc : accounts) {
            System.assertNotEquals(null, acc.Id, 'El Id de la cuenta no debe ser nulo después de la inserción');
        }
    }*/

    //Test passed OK
    @isTest
    static void testOrdersCreation() {
        // Verifier la creation des accounts 
        List<Account> accounts = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account WHERE Name LIKE 'TestAccount%'];
        List<Id> accountIds = getAccountIds(accounts);
        List<Order> ordersFromDb = [SELECT Id, AccountId, EffectiveDate, Status, PriceBook2Id FROM Order WHERE AccountId IN :accountIds];

        System.assertEquals(200, ordersFromDb.size(), 'Número incorrecto de órdenes creadas');
        for(Order ord : orders) {
            System.assertNotEquals(null, ord.Id, 'El Id de la orden no debe ser nulo después de la inserción');
        }
    }

    //Test passed OK
    @isTest
    static void testProductCreation() {
        // Récupérer le produit 'Chemise Verte longue XYX'
        Product2 chemiseVerte = [SELECT Id, Name, Family FROM Product2 WHERE Name = 'Product' LIMIT 1];
        PricebookEntry pricebook = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice, IsActive  FROM PricebookEntry WHERE Product2Id = :chemiseVerte.Id AND UnitPrice = 100.0 LIMIT 1];
        System.assertNotEquals(null, chemiseVerte.Id, 'El Id del producto no debe ser nulo después de la inserción');
    }

    //Test passed OK
    @isTest
    static void testPricebookCreation() {
        // Verificar la creación de entradas en el catálogo de precios
        Product2 chemiseVerte = [SELECT Id, Name, Family FROM Product2 WHERE Name = 'Chemise Verte longue XYX' LIMIT 1];
        PricebookEntry pricebook = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice, IsActive  FROM PricebookEntry WHERE Product2Id = :chemiseVerte.Id AND UnitPrice = 100.0 LIMIT 1];
        System.assertNotEquals(null, pricebook.Id, 'El Id de la entrada en el catálogo de precios no debe ser nulo después de la inserción');
    }
    //Test passed OK
    @isTest
    static void testOrderItemsCreation() {
        // Récuperer tout les accounts dont le nom commence avec 'TestAccount'
        List<Account> accounts = [SELECT Id, Name, Chiffre_de_affaire__c FROM Account WHERE Name LIKE 'TestAccount%'];

        // Obtenir les IDs des acoounts qu'ont été récupérés
        List<Id> accountIds = getAccountIds(accounts);

        // Récupérer le produit 'Chemise Verte longue XYX'
        Product2 chemiseVerte = [SELECT Id, Name, Family FROM Product2 WHERE Name = 'Chemise Verte longue XYX' LIMIT 1];

        // Récupérer l'entrée de catalogue de prix pour le produit récupéré avec un prix unitaire de 100.0
        PricebookEntry pricebook = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice, IsActive  FROM PricebookEntry WHERE Product2Id = :chemiseVerte.Id AND UnitPrice = 100.0 LIMIT 1];

        // Récupérer les commandes pour les comptes récupérés
        List<Order> ordersFromDb = [SELECT Id, AccountId, EffectiveDate, Status, PriceBook2Id FROM Order WHERE AccountId IN :accountIds];

        // Récupérer les éléments de commande pour les commandes récupérées
        List<OrderItem> orderItemsFromDB = [SELECT Id, OrderId, Product2Id, Quantity, UnitPrice FROM OrderItem WHERE OrderId IN :new List<Id>{orders[0].Id, orders[1].Id}];
        
        // Vérifier que se sont crées deux éléments de commande
        System.assertEquals(2, orderItemsFromDB.size(), 'Nombre  incorrect des elements de order crées');

        // Vérifier que l'ID de chaque élément de commande n'est pas nul
        for(OrderItem item : orderItemsFromDB) {
            System.assertNotEquals(null, item.Id, 'LId del elemento de orden no debe ser nulo después de la inserción');
        }
    }


    @isTest
    static void testOrderValueUpdatesAccount() {
        // Récuperer tout les accounts dont le nom commence avec 'TestAccount'
        List<Account> accounts = [SELECT Id, Name, Chiffre_de_affaire__c FROM Account WHERE Name LIKE 'TestAccount%'];
        
        // Obtenir les IDs des acoounts qu'ont été récupérés
        List<Id> accountIds = getAccountIds(accounts);

        // Récupérer le produit 'Chemise Verte longue XYX'
        Product2 chemiseVerte = [SELECT Id, Name, Family FROM Product2 WHERE Name = 'Chemise Verte longue XYX' LIMIT 1];

        // Récupérer l'entrée de catalogue de prix pour le produit récupéré avec un prix unitaire de 100.0
        PricebookEntry pricebook = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice, IsActive  FROM PricebookEntry WHERE Product2Id = :chemiseVerte.Id AND UnitPrice = 100.0 LIMIT 1];
        
        // Récupérer les commandes pour les comptes récupérés
        List<Order> ordersFromDb = [SELECT Id, AccountId, EffectiveDate, Status, PriceBook2Id FROM Order WHERE AccountId IN :accountIds];

        // Récuperer les éléments de commande    
        List<OrderItem> retrievedOrderItems = [SELECT Id, OrderId, Product2Id, Quantity, UnitPrice FROM OrderItem WHERE OrderId IN :orderIds];
    
        Test.startTest();
        order.Status = 'Activated';
        update order;
        Test.stopTest();
    
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(100.00, acc.Chiffre_d_affaire__c, 'Account Chiffre_d_affaire__c should be updated with the total value of the order');
    }
  
}
