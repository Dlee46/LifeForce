@isTest
public class DuplicateLeadsControllerTest {

    @isTest
    public static void getDuplicateLeadsTest(){
        
        // Dummy data
        // Create accounts and contacts to add to leads using custom lookup functionality
        Account a = new Account(Name = 'Test Account');
        insert a;
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert c;
        Product2 p1 = new Product2(Name = 'Test Product');
        insert p1;
        Product2 p2 = new Product2(Name = 'Test Product');
        insert p2;
        
        
        // Create a lead that will be used as the context lead
        Lead l = new Lead(FirstName = 'Test', LastName = 'Lead 1',
                          Email = 'test@email.com', Account__c = a.Id,
                          Company = 'Test Company 1', Contact__c = c.Id);
        insert l;
        
        // Create a lead that should have 100% duplicity level with first lead
        Lead ltest100 = new Lead(FirstName = 'Test', LastName = 'Lead 2',
                                 Email = 'test@email.com', Account__c = a.Id,
                                 Company = 'Test Company 2', Contact__c = c.Id);
        
        // Allow for duplicates to be inserted in order to test all code 
        // (duplicate emails will be blocked otherwise)
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true; 
        Database.SaveResult sr = Database.insert(ltest100, dml);
        
        // Create a lead that should have 50% duplicity level with first lead
        Lead ltest50 = new Lead(FirstName = 'Test', LastName = 'Lead 1',
                          Email = 'differentTest1@email.com', Account__c = a.Id,
                          Company = 'Test Company 1', Contact__c = c.Id);
        insert ltest50;
        // Create a lead that should have 0% duplicity levels
        Lead ltest0 = new Lead(FirstName = 'Test', LastName = 'Lead 3',
                               Email = 'differentTest2@email.com', Company = 'Test Company 3');
        insert ltest0;
        
        // Make product_interests that connect the leads with products with the custon junction object
        Product_Interest__c pi1 = new Product_Interest__c(Lead__c = l.Id, Product__c = p1.Id);
        insert pi1;
        Product_Interest__c pi2 = new Product_Interest__c(Lead__c = ltest100.Id, Product__c = p1.Id);
        insert pi2;
        Product_Interest__c pi3 = new Product_Interest__c(Lead__c = l.Id, Product__c = p2.Id);
        
        Product_Interest__c pi4 = new Product_Interest__c(Lead__c = ltest100.Id, Product__c = p2.Id);
        insert pi4;
        insert pi3;
        
        // Test the method and assert that the expected values are correct
        List<DuplicateLead> dupes = DuplicateLeadsController.getDuplicateLeads(l.id);
        System.assertEquals(dupes[0].duplicityLevel, 100);
        System.assertEquals(dupes[1].duplicityLevel, 50);
    }
}