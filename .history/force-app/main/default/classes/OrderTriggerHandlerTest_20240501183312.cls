/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest // Cette annotation indique que cette classe est une classe de test.
public class OrderTriggerHandlerTest {
    @testSetup // Cette annotation indique que la méthode suivante est utilisée pour configurer les données de test.
    static void setup() {
        // Créez un compte
        Account acc = new Account(Name='Test Account'); // Crée un nouvel objet compte avec le nom 'Test Account'.
        insert acc; // Insère le compte dans la base de données.

        // Créez une commande pour le compte
        Order ord = new Order(AccountId=acc.Id, Status='Draft', ShipmentCost__c=10, EffectiveDate=System.today()); // Crée un nouvel objet commande lié au compte précédemment créé, avec un statut 'Draft', et des frais de livraison de 10, et une date effective d'aujourd'hui.
        insert ord; // Insère la commande dans la base de données.
    }

    @isTest // Cette annotation indique que la méthode suivante est une méthode de test.
    static void testBeforeUpdateV1(){
        // Créez un compte et une commande
        Account acc = [SELECT Id, Name FROM Account];
        Order ord = [SELECT Id, Status, TotalAmount, ShipmentCost__c FROM Order LIMIT 1];

        // Llamar al metodo beforeUpdate
        OrderTriggerHandler.beforeUpdate(new List<Order>{ord}, new Map<Id, Order>{});//representa el mapeo(diccionario) de l'id de cada pedido
        System.assertEquals(-10, ord.NetAmount__c, 'El montant net no coincide con el esperado');
    }

        
    
    @isTest 
    static void testBeforeUpdate() {
        // Récupérez la commande
        Order ord = [SELECT Id, ShipmentCost__c, NetAmount__c FROM Order LIMIT 1]; // Récupère la première commande de la base de données.

        // Mettez à jour la commande

        if (ord != null) {
            ord.ShipmentCost__c = 20;

            Test.startTest();
            update ord;
            Test.stopTest();

            Order updatedOrder = [SELECT Id, TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :ord.Id];

            if (updatedOrder != null && updatedOrder.NetAmount__c != null) {
                System.assertEquals(180, updatedOrder.NetAmount__c, 'Le montant net n\'a pas été correctement calculé dans la méthode beforeUpdate');
            }
        }
    }

    @isTest
    public static void testAfterUpdateV1(){
        Order testOrder = new Order(Status='Draft', ShipmentCost__c=10, EffectiveDate=System.today());
        Account testAccount = new Account(Name='Test Account');

        insert testAccount;

        //Asignar la cuenta al pedido

        testOrder.AccountId = testAccount.Id; //igualar los ids para que se conceten para que se relacione la cuenta con el pedido ,

        insert testOrder;

        //crear un map de order para verificar el estado anterior de los pedidos
        Map<Id,Order> orderMap = new Map<Id,Order>();

        orderMap.put(testOrder.Id, new Order(Status = 'Draft'));

        //utilizamos el metodo de afterUpdate dans un trigger

        Test.startTest();
        OrderTriggerHandler.afterUpdate(new List<Order>{testOrder}, orderMap);
        Test.stopTest();

        //verificar que el chiffre d'affaires se actualizo
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        system.assertEquals(null, updatedAccount.Chiffre_d_affaire__c, 'Le chiffre d\'affaire n\'a pas été correctement calculé dans la méthode afterUpdate');
        //Intentar hacer este System.assertEquals(testOrder.TotalAmount, updatedAccount.Chiffre_d_affaire__c, 'Le chiffre d\'affaires a été correctement calculé dans la méthode afterUpdate');
    }

    @isTest
    public static void testAfterUpdateV2(){

        //Obtenir la commande de test
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        System.assertNotEquals(null, testAccount, 'Il n\'y a pas de compte de test');

        //Obtenir l'order de test crée da testSetup
        Order ord = [SELECT Id, Status, TotalAmount FROM Order LIMIT 1];
        System.assertNotEquals(null, ord, 'Il n\'y a pas de commande de test');

        // Créer un produit et l'associer à la commande
        Product2 prod = TestDataFactory.createProduct('Test Product', 'Test Family', 100);
        
        // Récupérer l'ID du PricebookEntry associé au produit
        Lits<PricebookEntry> pbeList = [SELECT Id FROM PricebookEntry WHERE Product2Id = :prod.Id LIMIT 1];
        
        if(!pbe)
        OrderItem ordItem = new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100);

        insert ordItem;

        //Vérifier que l'ordre s'est crée correctement avec le status Draft
        System.assertEquals('Draft', ord.Status, 'Le statut de la commande n\'est pas Draft');

        //Change le status de l'order à Activated
        ord.Status = 'Activated';

        // Lancement du trigger afterUpdate afin de changer le status de la commande
        Test.startTest();
        update ord;
        Test.stopTest();

        //Vérifier que le status de l'order est bien Activated
        ord = [SELECT Status FROM Order WHERE Id = :ord.Id];
        System.assertEquals('Activated', ord.Status, 'Le statut de la commande n\'est pas Activated');
        
        //Changer le statud de l'order à Ordered
        ord.Status = 'Ordered';

        // Lancement du trigger afterUpdate afin de changer le status de la commande
        Test.startTest();
        update ord;
        Test.stopTest();

        //Vérifier que le status de l'order est bien Ordered
        ord = [SELECT Status FROM Order WHERE Id = :ord.Id];
        System.assertEquals('Ordered', ord.Status, 'Le statut de la commande n\'est pas Ordered');

        //Appeler le trigger afterUpdate du trigger OrderTriggerHandler afin de mettre à jour le Chiffre_d_affaire__c du compte associé à l'order
        Test.startTest();
        OrderTriggerHandler.afterUpdate(new List<Order>{ord}, new Map<Id, Order>{ord.Id => ord});
        Test.stopTest();

        //Vérifier que le Chiffre_d_affaire__c du compte a été mis à jour
        testAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(null, testAccount.Chiffre_d_affaire__c, 'Le chiffre d\'affaire du compte n\'a pas été mis à jour');
    }

    
    @isTest // Cette annotation indique que la méthode suivante est une méthode de test.
    static void testAfterUpdate() {
        // Récupérez la commande
        Order ord = [SELECT Id, AccountId, Status, TotalAmount FROM Order LIMIT 1]; // Récupère la première commande de la base de données.

        // Mettez à jour la commande
        if (ord != null) {
            ord.Status = 'Ordered';

            Test.startTest();
            update ord;
            Test.stopTest();

            Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :ord.AccountId];

            if (updatedAccount != null && updatedAccount.Chiffre_d_affaire__c != null) {
                System.assertEquals(ord.TotalAmount, updatedAccount.Chiffre_d_affaire__c, 'Le chiffre d\'affaires n\'a pas été correctement calculé dans la méthode afterUpdate');
            }
        }
    }
}