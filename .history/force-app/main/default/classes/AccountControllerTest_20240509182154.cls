/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class AccountControllerTest {
    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(2);
        Product2 product = TestDataFactory.createProduct();
        PricebookEntry pricebook = TestDataFactory.createPricebookEntry(product);
        List<Order> orders = TestDataFactory.createOrdersForAccounts(accounts);
        TestDataFactory.createOrderItems(
            new List<Id>{orders[0].Id, orders[1].Id},
            new List<Id>{product.Id, product.Id},
            new List<Id>{pricebook.Id, pricebook.Id},
            new List<Decimal>{1, 2},
            new List<Decimal>{100, 200}
        );
    }
