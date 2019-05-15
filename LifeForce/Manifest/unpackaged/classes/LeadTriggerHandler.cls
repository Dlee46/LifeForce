public with sharing class LeadTriggerHandler {
    
    public void handleConvertedLeads(List<Lead> convertedLeads){
        //get products related to converted leads
        List<Product_Interest__c> relatedProducts = [SELECT Name,Product__r.id,Lead__r.id, Lead__r.convertedOpportunityId 
                                                     FROM Product_Interest__c
                                                     WHERE Lead__r.id IN :convertedLeads];
        //list of products to insert into opp line item
        List<OpportunityLineItem> itemsToInsert = new List<OpportunityLineItem>();
        
        
        //loop through related product and store it into a opporutuniy Line Item list
        // with opp id and product id
        for(Product_Interest__c prodInterest: relatedProducts ){
            
            OpportunityLineItem oppProduct = new OpportunityLineItem(OpportunityId = prodInterest.Lead__r.convertedOpportunityId, Product2Id = prodInterest.Product__c, Quantity = 1, TotalPrice = 100 );
            itemsToInsert.add(oppProduct);
            
        }
        // 
        if(itemsToInsert.size() > 0)
        	insert itemsToInsert;
    }
    
}