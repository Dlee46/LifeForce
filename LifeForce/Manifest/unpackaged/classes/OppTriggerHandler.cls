public class OppTriggerHandler {
    public void handleWonOpp(List<Id> wonOppId){
        List<Opportunity> oppList = [SELECT CloseDate, Id, AccountId, pricebook2Id, Account.BillingCity, Account.BillingCountry,
                                    Account.BillingState, Account.BillingStreet FROM Opportunity
                                    WHERE id IN :wonOppId];
        //create order records from opportunity
        List<Order> newOrders = new List<Order>();
        //use value of the opportunity to create an order record and add it to newOrders list
        for(Opportunity opp : oppList){
            Order ord = new Order(EffectiveDate = opp.closeDate, Status = 'Draft', OpportunityId= opp.id,
                                  AccountId = opp.AccountId, PriceBook2Id = opp.priceBook2Id, BillingCity = opp.Account.BillingCity,
                                  BillingCountry = opp.Account.BillingCountry, BillingState = opp.Account.BillingState, 
                                  BillingStreet = opp.Account.BillingStreet);
            newOrders.add(ord);
        }
        System.debug('ORdrs: '+ newOrders);
        // insert order records
        if(newOrders.size() > 0){
            insert newOrders; 
        }
        
        
        //get the related Opportunities Id 
       /* List<Id> oppsId = new List<Id>();
        for(Order o: newOrders){
            oppsId.add(o.OpportunityId);
        }*/
        
        //get the products related to that opportunity
        List<OpportunityLineItem> relatedProducts = [SELECT Name, Product2Id, OpportunityId, Quantity, UnitPrice, PriceBookEntryId
                                                     FROM OpportunityLineItem
                                                     WHERE OpportunityId IN :wonOppId];
        System.debug('related prod:' +relatedProducts);       
        
        //create order item record and associate it those products
        List<OrderItem> itemsToInsert = new List<OrderItem>();
        for(Order ord : newOrders){
            for(OpportunityLineItem ol: relatedProducts){
                OrderItem item = new OrderItem();
                item.OrderId = ord.id;
                item.Product2Id = ol.Product2Id;
                item.Quantity = ol.Quantity;
                item.UnitPrice = ol.UnitPrice;
                item.PricebookEntryId = ol.PricebookEntryId;
                itemsToInsert.add(item);
            }
        }
        // insert order item records
        if(itemsToInsert.size() > 0){
            insert itemsToInsert;
        }     
    }
}