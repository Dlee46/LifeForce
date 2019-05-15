@isTest
public class LeadTriggerTest {
    
    @isTest
    static void singleTest (){
        Lead newLead = new Lead(LastName= 'Doe', Company = 'LifeForce Inc.');
        insert newLead;
        
        Product2 p =  new Product2(Name = 'Product One'); 
        insert p;
        
        Product_Interest__c newProd = new Product_Interest__c(Lead__c = newLead.id, Product__c = p.id);
        insert newProd;
        
        Id stdpb = Test.getStandardPricebookId();
        
        PricebookEntry pe = new PricebookEntry(pricebook2id=stdpb, product2id=p.id,unitprice= 100, isActive=true );
        insert pe;
        //get number of records in oppLineItem before lead conversion
        Integer numBefore = [SELECT Count() FROM OpportunityLineItem ];
        
        Database.LeadConvert lc = new Database.LeadConvert(); 
        lc.setLeadId(newLead.id);
        
        Test.startTest();
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        Integer numAfter = [SELECT Count() FROM OpportunityLineItem ];
        
        System.assertEquals(numBefore + 1, numAfter);
        Test.stopTest();
        
    }
    @isTest
    static void bulkTest(){
        Lead leadOne = new Lead(LastName= 'Doe', Company = 'LifeForce Inc.');
        Lead leadTwo = new Lead(LastName= 'Dane', Company = 'AssignForce');
        List<Lead> listOfLeads = new List<Lead>{leadOne,leadTwo};
            insert listOfLeads;
        
        
        Product2 p1 =  new Product2(Name = 'Product One'); 
        Product2 p2 =  new Product2(Name = 'Product Two'); 
        Product2 p3 =  new Product2(Name = 'Product Three');
        List<Product2> listOfProducts = new List<Product2> {p1,p2,p3};
            insert listOfProducts;
        
        Product_Interest__c pi1 = new Product_Interest__c(Lead__c = leadOne.id, Product__c = p1.id);
        Product_Interest__c pi2 = new Product_Interest__c(Lead__c = leadOne.id, Product__c = p2.id);
        Product_Interest__c pi3 = new Product_Interest__c(Lead__c = leadTwo.id, Product__c = p3.id);
        List<Product_Interest__c> listOfPI = new List<Product_Interest__c> {pi1,pi2,pi3};
            insert listOfPI;
        
        Id stdpb = Test.getStandardPricebookId();
        
        PricebookEntry pe1 = new PricebookEntry(pricebook2id=stdpb, product2id=p1.id,unitprice= 100, isActive=true );
        PricebookEntry pe2 = new PricebookEntry(pricebook2id=stdpb, product2id=p2.id,unitprice= 100, isActive=true );
        PricebookEntry pe3 = new PricebookEntry(pricebook2id=stdpb, product2id=p3.id,unitprice= 100, isActive=true );
        List<PriceBookEntry> listOfPE = new List<PriceBookEntry>{pe1,pe2,pe3};
            insert listOfPE;            
        
        //get number of records in oppLineItem before lead conversion
        Integer numBefore = [SELECT Count() FROM OpportunityLineItem ];
        
        Database.LeadConvert lc1 = new Database.LeadConvert(); 
        lc1.setLeadId(leadOne.id);
        
        Database.LeadConvert lc2 = new Database.LeadConvert(); 
        lc2.setLeadId(leadTwo.id);
        
        List<Database.LeadConvert> lcList = new List<Database.LeadConvert>{lc1,lc2};
        
        Test.startTest();
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc1.setConvertedStatus(convertStatus.MasterLabel);
        lc2.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.convertLead(lcList);
        
        Integer numAfter = [SELECT Count() FROM OpportunityLineItem];
        
        System.assertEquals(numBefore + 3, numAfter);
        Test.stopTest();
    }
}