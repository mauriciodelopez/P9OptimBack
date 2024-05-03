/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : Classe utilitaire pour générer des données de test dans Salesforce.
 * @author            : [Ton nom ou pseudo]
 * @group             : [Nom du groupe de travail]
 * @last modified on  : 05-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {

    //methode pour créer une order line item
    public static Order createOrderWithProduct(String productName, String productCode, Integer numItemsPerOrder) {
        // Create Product (check for existing first)
        List<Product2> existingProducts = [SELECT Id FROM Product2 WHERE Name = :productName LIMIT 1];
        Product2 product;
        if (existingProducts.isEmpty()) {
        product = new Product2(Name = productName, isActive = true);
        insert product;
        } else {
        product = existingProducts[0];
        }
    
        // Create Pricebook Entry
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pricebookEntry = new PricebookEntry(
        Pricebook2Id = pricebookId,
        Product2Id = product.Id,
          UnitPrice = 100.00, // adjust as needed
        IsActive = true,
        UseStandardPrice = false
        );
        insert pricebookEntry;
    
        // Create Account (Optional, replace with your logic)
        Account acc = new Account(Name = 'SFDCPanther.com', Rating = 'Hot', Industry = 'Banking', Phone = '9087654321');
        insert acc;
    
        // Create Order
        Order order = new Order(
        AccountId = acc.Id,
        EffectiveDate = System.today(),
        Status = 'Draft',
        PriceBook2Id = pricebookId
        );
        insert order;
    
        // Create Order Items
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i < numItemsPerOrder; i++) {
        orderItems.add(new OrderItem(
            OrderId = order.Id,
            UnitPrice = 100.00, // adjust as needed based on pricebook entry
            Quantity = 1
        ));
        }
        insert orderItems;
    
        return order;
    }
            

    // Méthode pour créer une liste d'objets Account avec un nombre spécifié
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        // Vérifier si la création d'enregistrements Account est autorisée
        if (!Schema.sObjectType.Account.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements de compte.');
        }
        // Boucler pour créer le nombre spécifié de comptes
        for(Integer i = 0; i < numAccounts; i++) {
            Account a = new Account();
            a.Name = 'Test Account ' + (i + 1);
            // Configurer d'autres champs si nécessaire
            accounts.add(a);
        }
        return accounts;
    }


    public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer numOrdersPerAccount, Decimal pricePerOrder) {
        List<Order> orders = new List<Order>();
    
        // Iterar sobre cada cuenta para crear el número especificado de órdenes por cuenta
        for (Account acc : accounts) {
            for (Integer i = 0; i < numOrdersPerAccount; i++) {
                Order ord = new Order();
                ord.AccountId = acc.Id;
                ord.EffectiveDate = Date.today();
                ord.Status = 'Draft'; // Puedes ajustar el estado según tus necesidades
                ord.NetAmount__c = pricePerOrder; // Establecer el precio de la orden
    
                orders.add(ord); // Agregar la orden a la lista de órdenes
            }
        }
    
        // Insertar todas las órdenes para obtener sus Ids
        insert orders;
    
        return orders;
    }



    // Méthode pour créer des commandes pour un nombre spécifié de fois
    // en les associant de manière aléatoire à des comptes spécifiés
    public static List<Order> createOrders(List<Account> accounts, Integer numOrders) {
        
        List<Order> orders = new List<Order>();

        // creation d'un pricebook dans la class de test
        Pricebook2 pricebookClass = new Pricebook2(Name = 'Platinium');
        insert pricebookClass;
        
        // Vérifier si la création d'enregistrements Order est autorisée
        if (!Schema.sObjectType.Order.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements de commande.');
        }
    
    
        Integer numAccounts = accounts.size();
        // Boucler pour créer le nombre spécifié de commandes
        for(Integer i = 0; i < numOrders; i++) {
            // Choisir un index aléatoire pour sélectionner un compte
            Integer randomIndex = Math.mod(i, numAccounts);
            orders.add(new Order(AccountId = accounts[randomIndex].Id, 
            PriceBook2Id = Test.getStandardPricebookId(), EffectiveDate = System.today(), Status = 'Brouillon'));
        }
        insert orders;

        //créer les order items
        createOrderItems(orders, 50.00, 1, 2, pricebookClass);
        return orders;
    }

    
    // Méthode pour créer des articles de commande pour des commandes spécifiées
    public static List<OrderItem> createOrderItems(List<Order> orders, Decimal unitPricePerItem, Integer quantityPerItem, Integer numItemsPerOrder, Pricebook2 pricebook) {

        // Vérifier si la création d'enregistrements OrderItem est autorisée
        if (!Schema.sObjectType.OrderItem.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements d\'article de commande.');
        }
    
        // Vérifier les paramètres d'entrée
        if (orders == null || orders.isEmpty() || unitPricePerItem == null || quantityPerItem == null || numItemsPerOrder == null) {
            throw new IllegalArgumentException('Paramètres d\'entrée non valides.');
        }
    
        List<OrderItem> orderItems = new List<OrderItem>();
        // Boucler à travers les commandes spécifiées
        for(Order ord : orders) {
            // Créer le nombre spécifié d'articles de commande pour chaque commande
            for(Integer i = 0; i < numItemsPerOrder; i++) {
                orderItems.add(new OrderItem(OrderId = ord.Id, UnitPrice = unitPricePerItem, Quantity = quantityPerItem));
            }
        }
        insert orderItems;
        return orderItems;
    }

        
    // Méthode pour créer un volume massif de données de test
    public static List<Account> createMassiveData(Integer numAccounts, Integer ordersPerAccount) {
        List<Account> accounts = new List<Account>();
        List<Order> orders = new List<Order>();
        List<OrderItem> orderItems = new List<OrderItem>();
    
        // Créer le nombre spécifié de comptes
        for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Test Account' + i));
        }
        insert accounts;
    
        // Créer le nombre spécifié de commandes pour chaque compte
        for (Account acc : accounts) {
            for (Integer i = 0; i < ordersPerAccount; i++) {
                Order ord = new Order(AccountId = acc.Id);
                orders.add(ord);
            }
        }
        insert orders;
    
        // Créer un article de commande pour chaque commande créée
        for (Order ord : orders) {
            OrderItem item = new OrderItem(
                OrderId = ord.Id,
                UnitPrice = 100,
                Quantity = 1
            );
            orderItems.add(item);
        }
        insert orderItems;
    
        return accounts;
    }
        

    // Méthode pour créer un volume massif de comptes de test
    public static List<Account> createMassiveAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        // Créer le nombre spécifié de comptes
        for (Integer i = 0; i < numAccounts; i++) {
            Account a = new Account(Name = 'Test Account' + i);
            accounts.add(a);
        }
        insert accounts;
        return accounts;
    }
    
    // Méthode pour créer un produit
    public static Product2 createProduct(String productName, String productFamily, Decimal unitPrice) {
        
        // Vérifier si un produit avec le même nom existe déjà
        List<Product2> existingProducts = [SELECT Id FROM Product2 WHERE Name = :productName LIMIT 1];
        Product2 newProduct;
        if (existingProducts.isEmpty()) {
            // Créer le produit avec les valeurs spécifiées et l'insérer dans la base de données
            newProduct = new Product2(Name = productName, Family = productFamily);
            insert newProduct;
        } else {
            newProduct = existingProducts[0];
        }

                // Créer le prix du produit et l'associer au produit

        
                PricebookEntry standardPrice = new PricebookEntry();
                standardPrice.Pricebook2Id = Test.getStandardPricebookId();
                standardPrice.Product2Id = newProduct.Id;
                standardPrice.UnitPrice = unitPrice;
                standardPrice.IsActive = True;
                
                insert standardPrice ;
                

            
        
        
        return newProduct;
    }

    public static Order createOrderWithItems(String productName, String productCode, Integer numItems) {
        
        // Create or retrieve the product
        Product2 product = getProduct(productName, productCode);
    
        // Create a pricebook entry for the product (optional, adjust based on your needs)
        PricebookEntry pricebookEntry = createPricebookEntry(product.Id, yourPrice);
    
        // Create the order
        Order order = new Order(
        AccountId = [SELECT Id FROM Account LIMIT 1].Id, // Replace with your logic to get the account ID
        EffectiveDate = System.today(),
        Status = 'Draft'
        );
        insert order;
    
        // Create the specified number of order items associated with the order
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i < numItems; i++) {
        orderItems.add(new OrderItem(OrderId = order.Id, PricebookId = pricebookEntry.Id, Quantity = 1, Product2Id = product.Id));
        }
        insert orderItems;
    
        return order;
        }
    }
    
        // Créer un produit pour les articles de commande DONE MLO
    public static void createOrderItemsForAccounts(List<Account> accounts, Integer itemsPerAccount) {
        // Create a product for the order items
        Product2 product = createProduct('cycle test', 'Test Product Family', 100);

        // Loop through each account
        for (Account acc : accounts) {
            // Create an order using TestDataFactory
            Order order = TestDataFactory.createOrderWithProduct(product.Name, product.ProductCode, itemsPerAccount);
              // No need to iterate and create individual order items
              // The createOrderWithProduct method now handles creating the specified number of order items
            }
        }
        // Methode to create commercial role DONE MLO 
        public static void createTeamOrdersTestData() {
            // Create an account
            Account a = new Account(Name = 'Test Account');
            insert a;
        
            // Create a user with the 'Commercial' role (assuming logic exists for this)
            // ... (your logic to create the 'Commercial' user role)
        
            String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
                            TimeZoneSidKey='America/Los_Angeles', UserName=uniqueUserName);
            insert u;
        
            // Use TestDataFactory to create an order for the new user and account
            TestDataFactory.createOrderWithProduct('Test Product', 'ABC', 1); // adjust product details and number of items as needed
        }
    }
}


