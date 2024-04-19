/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
/**
 * 
 * 
**/
/**
 * Déclaration de la classe TestDataFactory avec le modificateur 'with sharing'. 
 * Cela signifie que la classe respecte les règles de partage de l'objet pour lequel elle est utilisée.
 */
@isTest
public with sharing class TestDataFactory {

    /**
     * Méthode pour créer un certain nombre de comptes.
     * 
     * @param numAccounts Le nombre de comptes à créer.
     * @return Une liste contenant les comptes créés.
     */
    public static List<Account> createAccounts(Integer numAccounts) {
        // Vérifie si l'utilisateur a la permission de créer des comptes
        if (!Schema.sObjectType.Account.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements de compte.');
        }

        // Crée une liste pour stocker les comptes
        List<Account> accounts = new List<Account>();
        
        // Boucle pour créer le nombre spécifié de comptes
        for(Integer i = 0; i < numAccounts; i++) {
            // Ajoute un nouveau compte à la liste
            accounts.add(new Account(Name = 'Compte de Test ' + i));
        }
        
        // Insère les comptes dans la base de données
        insert accounts;
        
        // Retourne la liste des comptes créés
        return accounts;
    }

    /**
     * Méthode pour créer un certain nombre de commandes pour chaque compte.
     * 
     * @param accounts Une liste de comptes auxquels les commandes doivent être associées.
     * @param numOrdersPerAccount Le nombre de commandes à créer pour chaque compte.
     * @return Une liste contenant les commandes créées.
     */
    public static List<Order> createOrders(List<Account> accounts, Integer numOrdersPerAccount) {
        // Vérifie si l'utilisateur a la permission de créer des commandes
        if (!Schema.sObjectType.Order.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements de commande.');
        }

        // Crée une liste pour stocker les commandes
        List<Order> orders = new List<Order>();
        
        // Boucle sur chaque compte
        for(Account acc : accounts) {
            // Pour chaque compte, crée le nombre spécifié de commandes
            for(Integer i = 0; i < numOrdersPerAccount; i++) {
                // Ajoute une nouvelle commande à la liste
                orders.add(new Order(AccountId = acc.Id));
            }
        }
        
        // Insère les commandes dans la base de données
        insert orders;
        
        // Retourne la liste des commandes créées
        return orders;
    }

    /**
     * Méthode pour créer un certain nombre d'éléments de commande pour chaque commande.
     * 
     * @param orders Une liste de commandes auxquelles les éléments de commande doivent être associés.
     * @param unitPricePerItem Le prix unitaire de chaque élément de commande.
     * @param quantityPerItem La quantité de chaque élément de commande.
     * @param numItemsPerOrder Le nombre d'éléments de commande à créer pour chaque commande.
     * @return Une liste contenant les éléments de commande créés.
     */
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

    /**
     * Méthode pour mettre à jour le chiffre d'affaires pour chaque compte.
     * 
     * @param accounts Une liste de comptes pour lesquels le chiffre d'affaires doit être mis à jour.
     */
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
        for(Account a : accounts) {
            a.Chiffre_d_affaire__c = accountTotals.get(a.Id);
        }
        update accounts;
    }

    // Méthode pour créer un grand nombre de comptes et de commandes pour tester les batches et les triggers

    // Método para crear una orden con un monto específico
    public static Order createOrderWithAmount(Decimal totalAmount) {
        // Creamos una cuenta asociada a la orden
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Creamos la orden con el monto especificado y la asociamos a la cuenta
        Order testOrder = new Order(AccountId = testAccount.Id, TotalAmount = totalAmount);
        insert testOrder;
        
        return testOrder;
    }
}


