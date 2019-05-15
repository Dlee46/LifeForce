@isTest
public class OppTriggerTest {
    @isTest
    static void testSingle(){
        Account acct = new Account(Name = 'Test Account',BillingCity = 'Reston', BillingCountry = 'United States', BillingState = 'Virginia');
        insert acct;
        
        Product2 p =  new Product2(Name = 'Product One'); 
        insert p;
        
        PriceBookEntry pe = new PriceBookEntry(PriceBook2Id = Test.getStandardPricebookId(), Product2Id = p.id, UnitPrice = 100, isActive = True);
        insert pe;
        
        Opportunity op = new Opportunity( StageName = 'Qualification',
                                         CloseDate = Date.parse('05/09/2019'),
                                         Name = 'Test Opportunity Triggers',
                                         AccountId = acct.Id);
        
        insert op;
        
        OpportunityLineItem oppItem = new OpportunityLineItem(OpportunityId = op.id, Product2Id = p.id ,Quantity = 1, TotalPrice = 100);
        insert oppItem;
        
        Test.startTest();
        Integer numOfOrderBefore = [SELECT Count() FROM Order];
        Integer numOfOrderItemBefore = [SELECT Count() FROM OrderItem];
        
        op.StageName = 'Closed Won';
        try{
            update op;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
        Integer numOfOrderAfter = [SELECT Count() FROM Order];
        Integer numOfOrderItemAfter = [SELECT Count() FROM OrderItem];
        
        System.assertNotEquals(numOfOrderBefore,numOfOrderAfter);
        System.assertNotEquals(numOfOrderItemBefore,numOfOrderItemAfter);
        Test.stopTest();
    }
    @isTest
    static void bulkTest(){
        Account acct = new Account(Name = 'Test Account',BillingCity = 'Reston', BillingCountry = 'United States', BillingState = 'Virginia');
        insert acct;
        
        Product2 p =  new Product2(Name = 'Product One'); 
        insert p;
        
        PriceBookEntry pe = new PriceBookEntry(PriceBook2Id = Test.getStandardPricebookId(), Product2Id = p.id, UnitPrice = 100, isActive = True);
        insert pe;
        Opportunity op1 = new Opportunity( StageName = 'Qualification',
                                          CloseDate = Date.parse('05/09/2019'),
                                          Name = 'Test Opportunity 1',
                                          AccountId = acct.Id);
        Opportunity op2 = new Opportunity( StageName = 'Qualification',
                                          CloseDate = Date.parse('05/09/2019'),
                                          Name = 'Test Opportunity 2',
                                          AccountId = acct.Id);
        Opportunity op3 = new Opportunity( StageName = 'Qualification',
                                          CloseDate = Date.parse('05/09/2019'),
                                          Name = 'Test Opportunity 3',
                                          AccountId = acct.Id);
        List<Opportunity> opps = new List<Opportunity>{op1,op2,op3};
            insert opps;
        
        OpportunityLineItem oppItem1 = new OpportunityLineItem(OpportunityId = op1.id, Product2Id = p.id ,Quantity = 1, TotalPrice = 100);
        OpportunityLineItem oppItem2 = new OpportunityLineItem(OpportunityId = op2.id, Product2Id = p.id ,Quantity = 1, TotalPrice = 100);
        OpportunityLineItem oppItem3 = new OpportunityLineItem(OpportunityId = op3.id, Product2Id = p.id ,Quantity = 1, TotalPrice = 100);
        List<OpportunityLineItem> oppLineItems = new List<opportunityLineItem> {oppItem1, oppItem2, oppItem3};
        insert oppLineItems;
        
        Test.startTest();
        Integer numOfOrderBefore = [SELECT Count() FROM Order];
        Integer numOfOrderItemBefore = [SELECT Count() FROM OrderItem];
        for(Opportunity op: Opps){
        	op.StageName = 'Closed Won';
        }
        try{
            update opps;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
        Integer numOfOrderAfter = [SELECT Count() FROM Order];
        Integer numOfOrderItemAfter = [SELECT Count() FROM OrderItem];
        
        System.assertNotEquals(numOfOrderBefore,numOfOrderAfter);
        System.assertNotEquals(numOfOrderItemBefore,numOfOrderItemAfter);
        Test.stopTest();
    }
    
}