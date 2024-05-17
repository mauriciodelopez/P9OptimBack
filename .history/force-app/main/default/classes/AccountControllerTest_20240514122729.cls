/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest 
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        // Création des données de test 
        List<Account> accounts = TestDataFactory.createAccounts(200);
        insert accounts;

        // Prendre les ID des Accounts ans une liste
        List<Id> accountIds = getAccountIds(accounts);

        Product2 product = TestDataFactory.createProduct();
        Decimal unitPrice = 100; // prix unitaire pour les produits crées
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(product, unitPrice); // Passe le prix unitaire ici
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        insert orders;

        List<OrderItem> orderItems = TestDataFactory.createOrderItems(
            new List<Id>{orders[0].Id, orders[1].Id},
            new List<Id>{product.Id, product.Id},
            new List<Id>{pricebook.Id, pricebook.Id},
            new List<Decimal>{1, 2},
            new List<Decimal>{100, 200}
        );
        insert orderItems;
    }

    private static List<Id> getAccountIds(List<Account> accounts) {
        List<Id> accountIds = new List<Id>();
        for(Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        return accountIds;
    }

    // Test passed OK
    @isTest
    static void testAccountsCreation() { 
        // Verificar la creación de cuentas
        List<Account> accounts = [SELECT Id, Name, Chiffre_de_affaire__c FROM Account WHERE Name LIKE 'TestAccount%'];

        System.assertEquals(200, accounts.size(), 'Número incorrecto de cuentas creadas');
        for(Account acc : accounts) {
            System.assertNotEquals(null, acc.Id, 'El Id de la cuenta no debe ser nulo después de la inserción');
        }
    }
    //Test passed OK
    @isTest
    static void testOrdersCreation() {
        // Verifier la creation des accounts 
        List<Account> accounts = [SELECT Id, Name, Chiffre_de_affaire__c FROM Account WHERE Name LIKE 'TestAccount%'];
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
        Product2 chemiseVerte = [SELECT Id, Name, Family FROM Product2 WHERE Name = 'Chemise Verte longue XYX' LIMIT 1];
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
        List<OrderItem> orderItemsFromDb = [SELECT Id, OrderId, Product2Id, Quantity, UnitPrice FROM OrderItem WHERE OrderId IN :new List<Id>{orders[0].Id, orders[1].Id}];
        
        // Vérifier que se sont crées deux éléments de commande
        System.assertEquals(2, orderItemsFromDb.size(), 'Nombre  incorrect des elements de order crées');

        // Vérifier que l'ID de chaque élément de commande n'est pas nul
        for(OrderItem item : orderItemsFromDb) {
            System.assertNotEquals(null, item.Id, 'LId del elemento de orden no debe ser nulo después de la inserción');
        }
    }


    @isTest
    static void testOrderValueUpdatesAccount() {
    
        List<Account> accList = testDataFactory.createAccounts(numAccounts);
        Account acc = accList[0]; // Get the first account from the list
        Product2 testProduct = testDataFactory.createProduct();
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = testDataFactory.createPricebookEntry(testProduct, 100);
    
        Order order = testDataFactory.createOrder(acc.Id, 'Draft');
    
        List<Id> orderIds = new List<Id>{order.Id};
        List<Id> productIds = new List<Id>{testProduct.Id};
        List<Id> pricebookEntryIds = new List<Id>{standardPrice.Id};
        List<Decimal> quantities = new List<Decimal>{2};
        List<Decimal> unitPrices = new List<Decimal>{standardPrice.UnitPrice};
    
        List<OrderItem> orderItems = testDataFactory.createOrderItems(orderIds, productIds, pricebookEntryIds, quantities, unitPrices);
    
        Test.startTest();
        order.Status = 'Activated';
        update order;
        Test.stopTest();
    
        acc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(200.00, acc.Chiffre_d_affaire__c, 'Account Chiffre_d_affaire__c should be updated with the total value of the order');
    }
    /*
    @isTest
    static void testUpdateChiffreDAffaire() {
        // Crear cuentas con un valor específico en Chiffre_d_affaire__c
        List<Account> accounts = TestDataFactory.createAccounts(5);
        for (Account acc : accounts) {
            acc.Chiffre_d_affaire__c = 500; // Establecer un valor inicial conocido
        }
        insert accounts; // Insertar las cuentas en la base de datos
        
        // Verificar que el campo Chiffre_d_affaire__c se actualiza correctamente para todas las cuentas
        Test.startTest();
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);
        Test.stopTest();
    
        // Verificar que los valores de Chiffre_d_affaire__c se han actualizado correctamente
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        
        Decimal expectedTotal = 5 * 500; // 5 cuentas con un valor inicial de 500
        for (Account acc : updatedAccounts) {
            System.assertEquals(expectedTotal, acc.Chiffre_d_affaire__c, 'El valor de Chiffre_d_affaire__c no se ha actualizado correctamente');
        }
    } 
    */ 
    
    /*
    //Test pour vérifier que les comptes se mettent à jour correctement, lors qu'il n'ya pas des orders associées
    @isTest
    static void testUpdateCAWithoutOrders(){
        //Préparation de l'environnement de test 
        //Création des données de test donc des comptes & modifier la methode pour création de 5 comptes
        List<Account> accounts = TestDataFactory.createAccounts(5);
    
        // Initier le contexte de test
        Test.startTest();
    
        //Appeler la methode AccountController afin d'actualiser le CA
        AccountController controller = new AccountController();
        controller.updateChiffreDAffaire(accounts);
    
        // Stop le context de test
        Test.stopTest();
    
        //Vérifier les résultats attendues 
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for (Account acc : updatedAccounts) {
            System.assertEquals(0, acc.Chiffre_d_affaire__c, 'Le champ Chiffre_d_affaire__c naurai du changer ');
        }
    }*/   
}
