/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-17-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class UpdateAccountsBatchTest {
    // Método para crear una orden con estado 'Ordered' para cada cuenta
    public static List<Order> createOrderedOrdersForAccounts(List<Account> accounts) {
        List<Order> orders = new List<Order>();
        for(Account acc : accounts) {
            Order ord = new Order(AccountId = acc.Id, EffectiveDate = Date.today(), Status = 'Ordered', Pricebook2Id = Test.getStandardPricebookId());
            orders.add(ord);
        }
        insert orders;
        return orders;
    }
    @testSetup static void setup() {
        // Crear datos de prueba
        List<Account> testAccounts = TestDataFactory.createAccounts(5);
        // create orders witch status 'Ordered' for each account
        List<Order> orderedOrders = createOrderedOrdersForAccounts(testAccounts);
        
    }

    @isTest
    static void testBatchExecution() {
        // Obtener IDs de cuentas para verificar después
        List<Account> testAccounts = [SELECT Id FROM Account LIMIT 5];
        List<Id> accountIds = new List<Id>();
        for(Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }
        
        // Iniciar el trabajo en lotes
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        // Verificar que los datos se actualizaron correctamente
        List<Account> updatedAccounts = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds];
        for(Account acc : updatedAccounts) {
            System.assertNotEquals(0, acc.Chiffre_d_affaire__c, 'El campo Chiffre_d_affaire__c no se actualizó correctamente para la cuenta: ' + acc.Name);
        }
    }

    @isTest
    static void testExecuteCalculatesTurnoverCorrectly() {
        // Obtener las cuentas y las órdenes de la base de datos
        List<Account> testAccounts = [SELECT Id FROM Account];
        List<Order> testOrders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :testAccounts];    
    
        // Crear un producto
            Product2 product = new Product2(Name = 'Test Product', IsActive = true);
        insert product;

        // Crear una entrada de lista de precios para el producto
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100.0);

        // Crear una lista para recoger los OrderItems
        List<OrderItem> itemsToInsert = new List<OrderItem>();

        // Asignar cantidades conocidas a las órdenes
        for(Order ord : testOrders) {
            // Crear un OrderItem para la orden
            OrderItem item = new OrderItem(
            OrderId = ord.Id,
            UnitPrice = 100.0,
            Quantity = 1,
            PricebookEntryId = pbe.Id
            );
            // Añadir el OrderItem a la lista
            itemsToInsert.add(item);
        }
        
        // Insertar todos los OrderItems a la vez
        insert itemsToInsert;

        // Iniciar el trabajo en lotes
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.QueryLocator ql = batchJob.start(null);
        Database.BatchableContext bc;
        batchJob.execute(bc, testAccounts);
        Test.stopTest();

        // Verificar que la cifra de negocios se calculó correctamente
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        for(Account acc : updatedAccounts) {
        System.assertEquals(100.0, acc.Chiffre_d_affaire__c, 'La cifra de negocios no se calculó correctamente para la cuenta: ' + acc.Id);
        }
    }
}    
