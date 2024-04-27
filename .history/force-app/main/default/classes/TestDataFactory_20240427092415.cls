/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-27-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * @description       : Classe utilitaire pour générer des données de test dans Salesforce.
 * @author            : [Ton nom ou pseudo]
 * @group             : [Nom du groupe de travail]
 * @last modified on  : 04-27-2024
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
    
    // Méthode pour créer des commandes pour des comptes spécifiés
    public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer numOrdersPerAccount) {
        if (!Schema.sObjectType.Order.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements de commande.');
        }
    
        List<Order> orders = new List<Order>();
        // Boucler à travers les comptes spécifiés
        for(Account acc : accounts) {
            // Créer le nombre spécifié de commandes pour chaque compte
            for(Integer i = 0; i < numOrdersPerAccount; i++) {
                orders.add(new Order(AccountId = acc.Id, EffectiveDate = System.today(), Status = 'Draft'));
            }
        }
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
    
    // Méthode pour mettre à jour le chiffre d'affaires des comptes en fonction des commandes associées
    public static void updateChiffreDAffaire(List<Account> accounts) {
        List<Order> orders = [SELECT Id, TotalAmount, AccountId FROM Order WHERE AccountId IN :accounts];
        Map<Id, Decimal> accountTotals = new Map<Id, Decimal>();
        // Calculer le chiffre d'affaires pour chaque compte
        for(Order o : orders) {
            if(!accountTotals.containsKey(o.AccountId)) {
                accountTotals.put(o.AccountId, 0.0);
            }
            accountTotals.put(o.AccountId, accountTotals.get(o.AccountId) + o.TotalAmount);
        }
    
        // Mettre à jour le chiffre d'affaires de chaque compte
        for(Account ac : accounts) {
            ac.Chiffre_d_affaire__c = accountTotals.get(ac.Id);
        }
        update accounts;
    }
    
    // Méthode pour créer un volume massif de données de test
    public static List<Account> createMassiveData(Integer numAccounts, Integer ordersPerAccount) {
        List<Account> accounts = new List<Account>();
        List<Order> orders = new List<Order>();
        List<OrderItem> orderItems = new List<OrderItem>();
    
        // Créer le nombre spécifié de comptes
        for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Compte de test ' + i));
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
    
    // Méthode pour créer une commande avec un montant spécifié
    public static Order createOrderWithAmount(Decimal totalAmount, Date effectiveDate, String status) {
        //Create a new Order
        Order order = new Order();

        //Set the Order properties
        order.EffectiveDate = effectiveDate;
        order.Status = status;
        order.AccountId = accountId

        // Insert the new Order
        insert order;

        // Create a new OrderItem with a UnitPrice equal to the desired totalAmount
        OrderItem item = new OrderItem();
        item.OrderId = order.Id;
        item.UnitPrice = totalAmount;
        item.Quantity = 1;

        // Insert the new OrderItem
        insert item;

        // Return the new Order
        return order;
    }        
    

    // Méthode pour créer un volume massif de comptes de test
    public static List<Account> createMassiveAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        // Créer le nombre spécifié de comptes
        for (Integer i = 0; i < numAccounts; i++) {
            Account a = new Account(Name = 'Compte de test ' + i);
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
    }
}
