@isTest
public class OrderTriggerTest {

    @isTest
    static void testOrderTriggerHandler(){
        Account acct = new Account(Name = 'Test Account',BillingCity = 'Reston', BillingCountry = 'United States', BillingState = 'Virginia');
        insert acct;
        
        Contract c = new Contract(AccountId = acct.id, Status = 'Draft', StartDate = Date.today(), ContractTerm = 12);
        insert c;
        
        Order ord = new Order(EffectiveDate = Date.today(), Status = 'Draft',
                                  AccountId = acct.id, ContractId = c.id, PriceBook2Id = Test.getStandardPricebookId(), BillingCity = acct.BillingCity,
                                  BillingCountry = acct.BillingCountry, BillingState = acct.BillingState, 
                                  BillingStreet =acct.BillingStreet);
        insert ord;
        
        Product2 prod =  new Product2(Name = 'Product One'); 
        insert prod;
        
        PriceBookEntry pe = new PriceBookEntry(PriceBook2Id = Test.getStandardPricebookId(), Product2Id = prod.id, UnitPrice = 100, isActive = True);
        insert pe;
        
        OrderItem item = new OrderItem(OrderId = ord.id,Product2Id = prod.id,Quantity = 3,UnitPrice = 10,
                                       PricebookEntryId = pe.id);
        insert item;
        Test.startTest();
        Integer beforeCount = [SELECT count() FROM Asset];
        
        c.Status = 'Activated';
        update c;
        
        ord.Status = 'Activated';
        update ord;
        System.debug('update order');
        
        Integer afterCount = [SELECT count() FROM Asset];
        System.assertNotEquals(beforeCount, AfterCount);
        Test.stopTest();
    }
    
}