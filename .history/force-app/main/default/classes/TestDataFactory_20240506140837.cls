    /**
     * @description       : 
     * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
     * @group             : 
     * @last modified on  : 05-06-2024
     * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
    **/
    /**
     * @description       : Classe utilitaire pour générer des données de test dans Salesforce.
     * @author            : [Ton nom ou pseudo]
     * @group             : [Nom du groupe de travail]
     * @last modified on  : 05-06-2024
     * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
    **/
    @isTest
    public with sharing class TestDataFactory {

        //methode pour créer une order line item
        public static Order createOrderWithProduct(String productName, String productCode, Integer quantity, Id) {
            Integer numItemsPerOrder = 5; // Declare the variable at the start of the method

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
            Account acc = new Account(Name = 'Test Account ' + System.now().getTime()); // Generate unique name 
            insert acc;
        
            // Create Order
            Order order = new Order(
                AccountId = acc.Id,
                EffectiveDate = System.today(),
                Status = 'Draft',
                PriceBook2Id = Test.getStandardPricebookId()
            );
            insert order;
        
            // Create Order Items with desired unit price
            List<OrderItem> orderItems = new List<OrderItem>();
            for (Integer i = 0; i < numItemsPerOrder; i++) {    
                orderItems.add(new OrderItem(
                    OrderId = order.Id,
                    PricebookEntryId = pricebookEntry.Id, // Add this line
                    UnitPrice = unitPrice, // adjust as needed based on pricebook entry
                    Quantity = 1
                ));
            }
            insert orderItems;
        
            return order;
        }
        
        
        // DONE MLO
        public static List<Account> createAccountsWithOrders(Integer numAccounts, Integer ordersPerAccount, String productName, String productCode) {
            List<Account> accounts = new List<Account>();
        
            // Create the specified number of accounts with orders
            for (Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account ' + (i + 1);
            accounts.add(acc);
        
            // Create orders for this account using createOrderWithProduct
            for (Integer j = 0; j < ordersPerAccount; j++) {
                createOrderWithProduct(productName, productCode, 1, acc.Id); // 1 item per order
            }
        }
        
            // Insert accounts (if not already inserted in createOrderWithProduct)
            if (!accounts.isEmpty() && !accounts[0].Id != null) {
            insert accounts;
            }
        
            return accounts;
        }
        //DONE MLO
        public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer numOrdersPerAccount, String productName, String productCode, Decimal pricePerItem) {
            List<Order> orders = new List<Order>();
        
            // Loop to create orders with a single item per order using createOrderWithProduct
            for (Account acc : accounts) {
            for (Integer i = 0; i < numOrdersPerAccount; i++) {
                orders.add(createOrderWithProduct(productName, productCode, 1, acc.Id, pricePerItem)); // 1 item per order
            }
            }
        
            return orders;
        }
            
        // Méthode pour créer un volume massif de données de test DONE MLO
        public static List<Account> createMassiveData(Integer numAccounts, Integer ordersPerAccount, String productName, String productCode) {
            List<Account> accounts = new List<Account>();
        
            // Create the specified number of accounts
            for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Test Account' + i));
            }
            insert accounts;
        
            // Create orders with items for each account using createOrderWithProduct
            for (Account acc : accounts) {
                for (Integer i = 0; i < ordersPerAccount; i++) {
                TestDataFactory.createOrderWithProduct(productName, productCode, 1); // Assuming 1 item per order
                }
            }
        
            return accounts;
        }        

        // Méthode pour créer un volume massif de comptes de test DONE MLO
        public static List<Account> createMassiveAccounts(Integer numAccounts) {
            List<Account> accounts = new List<Account>();
            
            // Create the specified number of accounts
            for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Test Account' + i));
            }
            insert accounts;
            return accounts;
        }        

        // Method to create order items for the order DONE MLO
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


