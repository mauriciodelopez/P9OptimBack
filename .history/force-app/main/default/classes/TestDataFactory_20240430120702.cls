/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : Classe utilitaire pour générer des données de test dans Salesforce.
 * @author            : [Ton nom ou pseudo]
 * @group             : [Nom du groupe de travail]
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {
    
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
        // Vérifier si la création d'enregistrements Order est autorisée
        if (!Schema.sObjectType.Order.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements de commande.');
        }
    
        List<Order> orders = new List<Order>();
        Integer numAccounts = accounts.size();
        // Boucler pour créer le nombre spécifié de commandes
        for(Integer i = 0; i < numOrders; i++) {
            // Choisir un index aléatoire pour sélectionner un compte
            Integer randomIndex = Math.mod(i, numAccounts);
            orders.add(new Order(AccountId = accounts[randomIndex].Id, EffectiveDate = System.today(), Status = 'Brouillon'));
        }
        insert orders;
        return orders;        
    }
    
    // Méthode pour créer des articles de commande pour des commandes spécifiées
    public static List<OrderItem> createOrderItems(List<Order> orders, Decimal unitPricePerItem, Integer quantityPerItem, Integer numItemsPerOrder) {
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
    
    // Méthode pour créer des articles de commande pour les comptes spécifiés
    public static void createOrderItemsForAccounts(List<Account> accounts, Integer itemsPerAccount) {
        List<OrderItem> orderItems = new List<OrderItem>();
        List<Order> allOrders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :accounts];
        Map<Id, List<Order>> accountOrdersMap = new Map<Id, List<Order>>();
        // Organiser les commandes par compte
        for (Order ord : allOrders) {
            if (!accountOrdersMap.containsKey(ord.AccountId)) {
                accountOrdersMap.put(ord.AccountId, new List<Order>());
            }
            accountOrdersMap.get(ord.AccountId).add(ord);
        }
    
        // Créer des articles de commande pour chaque compte
        for (Account acc : accounts) {
            List<Order> orders = accountOrdersMap.get(acc.Id);
            if (orders != null) {
                for (Order ord : orders) {
                    for (Integer i = 0; i < itemsPerAccount; i++) {
                        orderItems.add(new OrderItem(OrderId = ord.Id, UnitPrice = 100, Quantity = 1));
                    }
                }
            }
        }
        insert orderItems;
        //Cette methode n'a pas besoin de faire return car elle insere directement la liste d'items de commande dans la base de donnees
    }

    public static void createTeamOrdersTestData() {
        // Create a user with the 'Commercial' role
        UserRole r = new UserRole(DeveloperName = 'Commercial', Name = 'Commercial');
        insert r;
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com',
                        UserRole = r);
        insert u;

        // Create an order for the user
        Order o = new Order(OwnerId = u.Id, TotalAmount = 100.0);
        insert o;
    }
}