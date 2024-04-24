/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {
    // Méthode pour créer un certain nombre de comptes
    public static List<Account> createAccounts(Integer numAccounts) {
        // Vérifie si l'utilisateur a la permission de créer des comptes
        if (!Schema.sObjectType.Account.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements de compte.');
        }

        // Crée une liste pour stocker les comptes
        List<Account> accounts = new List<Account>();
        
        // Boucle pour créer le nombre spécifié de comptes
        for(Integer i = 0; i < numAccounts; i++) {
            Account a = new Account(Name = 'Test Account' + i);
            acc.Name = 'Test Account ' + (i + 1);
            // Assurez-vous de ne pas attribuer une valeur à acc.Id ici
            accounts.add(a);
        }
        // Retourne la liste des comptes créés
        return accounts;
    }

    // Méthode pour créer un certain nombre de commandes pour chaque compte
    public static List<Order> createOrders(Integer numOrders) {
        // Vérifie si l'utilisateur a la permission de créer des commandes
        if (!Schema.sObjectType.Order.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements de commande.');
        }

        // Crée une liste pour stocker les commandes
        List<Order> orders = new List<Order>();
        
        // Boucle sur chaque compte
        for(Integer i = 0; i < numOrders; i++) {
            orders.add(new Order(   
                EffectiveDate = System.today(),
                Status = 'Draft'
            ));
            }
        }
        // Retourne la liste des commandes créées
        return orders;
    
    }

    // Méthode pour créer un certain nombre d'éléments de commande pour chaque commande
    public static List<OrderItem> createOrderItems(List<Order> orders, Double unitPricePerItem, Integer quantityPerItem, Integer numItemsPerOrder) {
        // Vérifie si l'utilisateur a la permission de créer des éléments de commande
        if (!Schema.sObjectType.OrderItem.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements d\'élément de commande.');
        }

        // Vérifie si les paramètres d'entrée sont valides
        if (orders == null || orders.isEmpty() || unitPricePerItem == null || quantityPerItem == null || numItemsPerOrder == null) {
            throw new IllegalArgumentException('Paramètres d\'entrée non valides.');
        }

        // Crée une liste pour stocker les éléments de commande
        List<OrderItem> orderItems = new List<OrderItem>();
        
        // Boucle sur chaque commande
        for(Order ord : orders) {
            // Pour chaque commande, crée le nombre spécifié d'éléments de commande
            for(Integer i = 0; i < numItemsPerOrder; i++) {
                // Ajoute un nouvel élément de commande à la liste
                orderItems.add(new OrderItem(OrderId = ord.Id, UnitPrice = unitPricePerItem, Quantity = quantityPerItem));
            }
        }
        
        // Insère les éléments de commande dans la base de données
        insert orderItems;
        
        // Retourne la liste des éléments de commande créés
        return orderItems;
    }

    // Méthode pour mettre à jour le chiffre d'affaires pour chaque compte
    public static void updateChiffreDAffaire(List<Account> accounts) {
        // Récupère toutes les commandes pour les comptes donnés
        List<Order> orders = [SELECT Id, TotalAmount, AccountId FROM Order WHERE AccountId IN :accounts];

        // Crée une map pour stocker le total de TotalAmount pour chaque compte
        Map<Id, Double> accountTotals = new Map<Id, Double>();
        for(Order o : orders) {
            if(!accountTotals.containsKey(o.AccountId)) {
                accountTotals.put(o.AccountId, 0.0);
            }
            accountTotals.put(o.AccountId, accountTotals.get(o.AccountId) + o.TotalAmount);
        }

        // Met à jour le chiffre d'affaires pour chaque compte
        for(Account ac : accounts) {
            a.Chiffre_d_affaire__c = accountTotals.get(a.Id);
        }
        update accounts;
    }

    // Méthode pour créer un grand nombre de comptes et de commandes pour tester les batches et les triggers
    public static List<Account> createMassiveData(Integer numAccounts, Integer ordersPerAccount) {
        List<Account> accounts = new List<Account>();
        List<Order> orders = new List<Order>();
        List<OrderItem> orderItems = new List<OrderItem>();
    
        // Créer un grand nombre de comptes
        for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
    
        // Créer un grand nombre de commandes pour chaque compte
        for (Account acc : accounts) {
            for (Integer i = 0; i < ordersPerAccount; i++) {
                Order ord = new Order(AccountId = acc.Id);
                orders.add(ord);
            }
        }
        insert orders;
    
        // Créer un OrderItem pour chaque Order
        for (Order ord : orders) {
            OrderItem item = new OrderItem(
                OrderId = ord.Id,
                UnitPrice = 100,
                Quantity = 1
            );
            orderItems.add(item);
        }
        insert orderItems;
    }

    // Méthode pour créer une commande avec un montant spécifique
    public static Order createOrderWithAmount(Decimal totalAmount) {
        // Nous créons un compte associé à la commande
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    
        // Nous créons la commande et l'associons au compte
        Order testOrder = new Order(AccountId = testAccount.Id);
        insert testOrder;

        // Nous créons un OrderItem pour la commande avec le montant spécifié
        OrderItem item = new OrderItem(
            OrderId = testOrder.Id,
            UnitPrice = totalAmount,
            Quantity = 1
        );
        insert item;
    
        return testOrder;
    }

    // Méthode pour créer un grand nombre de comptes
    public static List<Account> createMassiveAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            Account a = new Account(Name = 'Test Account ' + i);
            accounts.add(a);
        }
        //Fait une unique opération d'insertion en dehors du boucle
        insert accounts;
        return accounts;
    }

// Méthode pour créer des éléments de commande pour une liste de comptes
public static void createOrderItemsForAccounts(List<Account> accounts, Integer itemsPerAccount) {
    List<OrderItem> orderItems = new List<OrderItem>();

    // Récupère toutes les commandes pour tous les comptes en une seule requête
    List<Order> allOrders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :accounts];

    // Trie les commandes dans une Map avec l'ID du compte comme clé
    Map<Id, List<Order>> accountOrdersMap = new Map<Id, List<Order>>();
    for (Order ord : allOrders) {
        if (!accountOrdersMap.containsKey(ord.AccountId)) {
            accountOrdersMap.put(ord.AccountId, new List<Order>());
        }
        accountOrdersMap.get(ord.AccountId).add(ord);
    }

    // Crée les éléments de commande
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

    // Insère les éléments de commande dans la base de données
    insert orderItems;
    }
}    