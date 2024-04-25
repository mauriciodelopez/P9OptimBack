/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory {   
    public static List<Account> createAccounts(Integer numAccounts) {
        if (!Schema.sObjectType.Account.isCreateable()) {
            throw new SecurityException('You do not have permission to create account records.');
        }
        for (Integer i = 0; i < numAccounts; i++) {
            //code pour créer 
            Account a = new Account(Name = 'Test Account ' + i);
            accounts.add(a);
        }
        insert accounts;
        return accounts;
    }

public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer numOrdersPerAccount) {
    if (!Schema.sObjectType.Order.isCreateable()) {
        throw new SecurityException('You do not have permission to create order records.');
    }

    List<Order> orders = new List<Order>();
    for(Account acc : accounts) {
        for(Integer i = 0; i < numOrdersPerAccount; i++) {
            orders.add(new Order(AccountId = acc.Id, EffectiveDate = System.today(), Status = 'Draft'));
        }
    }
    insert orders;
    return orders;
}

public static List<Order> createOrders(List<Account> accounts, Integer numOrders) {
    if (!Schema.sObjectType.Order.isCreateable()) {
        throw new SecurityException('You do not have permission to create order records.');
    }

    List<Order> orders = new List<Order>();
    Integer numAccounts = accounts.size();
    for(Integer i = 0; i < numOrders; i++) {
        Integer randomIndex = Math.mod(i, numAccounts);
        orders.add(new Order(AccountId = accounts[randomIndex].Id, EffectiveDate = System.today(), Status = 'Draft'));
    }
    insert orders;
    return orders;        
}

public static List<OrderItem> createOrderItems(List<Order> orders, Double unitPricePerItem, Integer quantityPerItem, Integer numItemsPerOrder) {
    if (!Schema.sObjectType.OrderItem.isCreateable()) {
        throw new SecurityException('You do not have permission to create order item records.');
    }

    if (orders == null || orders.isEmpty() || unitPricePerItem == null || quantityPerItem == null || numItemsPerOrder == null) {
        throw new IllegalArgumentException('Invalid input parameters.');
    }

    List<OrderItem> orderItems = new List<OrderItem>();
    for(Order ord : orders) {
        for(Integer i = 0; i < numItemsPerOrder; i++) {
            orderItems.add(new OrderItem(OrderId = ord.Id, UnitPrice = unitPricePerItem, Quantity = quantityPerItem));
        }
    }
    insert orderItems;
    return orderItems;
}

public static void updateChiffreDAffaire(List<Account> accounts) {
    List<Order> orders = [SELECT Id, TotalAmount, AccountId FROM Order WHERE AccountId IN :accounts];
    Map<Id, Double> accountTotals = new Map<Id, Double>();
    for(Order o : orders) {
        if(!accountTotals.containsKey(o.AccountId)) {
            accountTotals.put(o.AccountId, 0.0);
        }
        accountTotals.put(o.AccountId, accountTotals.get(o.AccountId) + o.TotalAmount);
    }

    for(Account ac : accounts) {
        ac.Chiffre_d_affaire__c = accountTotals.get(ac.Id);
    }
    update accounts;
}

public static List<Account> createMassiveData(Integer numAccounts, Integer ordersPerAccount) {
    List<Account> accounts = new List<Account>();
    List<Order> orders = new List<Order>();
    List<OrderItem> orderItems = new List<OrderItem>();

    for (Integer i = 0; i < numAccounts; i++) {
        accounts.add(new Account(Name = 'Test Account ' + i));
    }
    insert accounts;

    for (Account acc : accounts) {
        for (Integer i = 0; i < ordersPerAccount; i++) {
            Order ord = new Order(AccountId = acc.Id);
            orders.add(ord);
        }
    }
    insert orders;

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

public static Order createOrderWithAmount(Decimal totalAmount) {
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;

    Order testOrder = new Order(AccountId = testAccount.Id);
    insert testOrder;

    OrderItem item = new OrderItem(
        OrderId = testOrder.Id,
        UnitPrice = totalAmount,
        Quantity = 1
    );
    insert item;

    return testOrder;
}

public static List<Account> createMassiveAccounts(Integer numAccounts) {
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < numAccounts; i++) {
        Account a = new Account(Name = 'Test Account ' + i);
        accounts.add(a);
    }
    insert accounts;
    return accounts;
}

public static void createOrderItemsForAccounts(List<Account> accounts, Integer itemsPerAccount) {
    List<OrderItem> orderItems = new List<OrderItem>();
    List<Order> allOrders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :accounts];
    Map<Id, List<Order>> accountOrdersMap = new Map<Id, List<Order>>();
    for (Order ord : allOrders) {
        if (!accountOrdersMap.containsKey(ord.AccountId)) {
            accountOrdersMap.put(ord.AccountId, new List<Order>());
        }
        accountOrdersMap.get(ord.AccountId).add(ord);
    }

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