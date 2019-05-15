public class ProductSelectionController {
        
        @AuraEnabled
        public static List<Product2> getProducts(String searchKeyword){
            String searchKey = searchKeyword + '%';
            List<Product2> prodList = new List<Product2>();
            List<Product2> result = Database.query('SELECT Id, Name FROM Product2 WHERE Name LIKE : searchKey LIMIT 50');
                for (Product2 p : result){    
                    prodList.add(p);
                }
                return prodList;
            }
            
            @AuraEnabled
            public static void addProdToCase (String ParentId, List<String> listProdIds){        
                List<Product_Selection__c> listProds = new List<Product_Selection__c>();
                for(String prodId : listProdIds){
                    Product_Selection__c prod = new Product_Selection__c();
                    prod.Product__c = prodId;
                    prod.Case__c = ParentId;
                    listProds.add(prod);
                }
                insert listProds;
            }
            
            @AuraEnabled
            public static void addProdToLead (String ParentId, List<String> listProdIds){        
                List<Product_Interest__c> listProds = new List<Product_Interest__c>();
                for(String prodId : listProdIds){
                    Product_Interest__c prod = new Product_Interest__c();
                    prod.Product__c = prodId;
                    prod.Lead__c = ParentId;
                    listProds.add(prod);
                }
                insert listProds;
            }
            
        }