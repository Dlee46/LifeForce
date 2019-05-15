@isTest
public class Test_Service_AddProduct {
    
    @isTest
    public static void testGetProduct(){
        // insert product
        Product2 prod = new Product2();
        prod.Name='SLA: Gold';
        insert prod;
        // call on a method and query
        test.startTest();
        List<Product2> listProd = ProductSelectionController.getProducts('SLA');
        System.assert(listProd.size()>0);
        test.stopTest();
        
    }
    
    @isTest
    public static void testAddToCase(){
        Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Email';
        insert c;
        String parentId = c.Id;
        
        Product2 prod = new Product2();
        prod.Name='SLA: Gold';
        List<String> listProdIds = new List<String>();
        listProdIds.add(prod.Id);
        insert Prod;
        
        Product_Selection__c ps = new Product_Selection__c();
        ps.Name = 'Test';
        ps.Case__c = c.Id;
        ps.Product__c = prod.Id;
        insert ps; 
        
        test.startTest();
        ProductSelectionController.addProdToCase(parentId, listProdIds);
        System.assertEquals(2,[SELECT Id FROM Product_Selection__c].size());
        test.stopTest();
    }
    
    @isTest
    public static void testAddToLead(){
        Lead l = new Lead();
        l.LastName = 'New';
        l.Company = 'Email';
        l.Status = 'Open - Not Contacted';
        insert l;
        String parentId = l.Id;
        
        Product2 prod = new Product2();
        prod.Name='SLA: Gold';
        List<String> listProdIds = new List<String>();
        listProdIds.add(prod.Id);
        insert Prod;
        
        Product_Interest__c pi = new Product_Interest__c();
        pi.Lead__c = l.Id;
        pi.Product__c = prod.Id;
        insert pi; 
        
        test.startTest();
        ProductSelectionController.addProdToLead(parentId, listProdIds);
        System.assertEquals(2,[SELECT Id FROM Product_Interest__c].size());
        test.stopTest();
    }
    
}