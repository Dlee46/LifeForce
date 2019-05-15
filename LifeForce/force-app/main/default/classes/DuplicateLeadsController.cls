public class DuplicateLeadsController {
    
    @AuraEnabled
    public static List<DuplicateLead> getDuplicateLeads(ID cID){
        
        // Get the current lead from the ID
        Lead currentLead = [SELECT Id, Name, Email, Account__c, Contact__c 
                            FROM Lead WHERE Id =: cID 
                            LIMIT 1];
        
        // Get a list of all the leads except for the current lead
        List<Lead> allLeads = [SELECT Id, Name, Email, Account__c, Contact__c 
                               FROM Lead WHERE Id != :currentLead.Id];
        
        // Get a list of product interests related to current lead
        List<Product_Interest__c> currentProdInterests = [SELECT Id, Lead__c, Product__c
                                                          FROM Product_Interest__c WHERE Lead__c =: cID
                                                          ORDER BY Id ASC]; // Make sure lists are ordered for equality testing

        List<ID> interestedProdIds = new List<ID>();
        for(Product_Interest__c c : currentProdInterests){
            interestedProdIds.add(c.Product__c);
        }
        interestedProdIds.sort();
        
        // Get a list of all product interests
        List<Product_Interest__c> allProdInterests = [SELECT Id, Lead__c, Product__c
                                                      FROM Product_Interest__c WHERE Lead__c !=: cID
                                                      ORDER BY Id ASC]; // Make sure lists are ordered for equality testing
        
        // Create a map of all leads (except the current) with associated products of interest
        Map<ID, List<ID>> leadsWithProds = new Map<ID, List<ID>>();
        for(Product_Interest__c p : allProdInterests){
            // If the lead already exists in the map
            if(!leadsWithProds.containsKey(p.Lead__c)){
                List<ID> l = new List<ID>();
                l.add(p.Product__c);
                leadsWithProds.put(p.Lead__c, l);
            } else {
                List<ID> l = leadsWithProds.get(p.Lead__c);
                l.add(p.Product__c);
            }
		}
        
        // Calculate duplicity level of leads, add 25% for each exact duplicates of account, contact, products and email
        List<DuplicateLead> duplicateLeads = new List<DuplicateLead>();
        //Map<Lead, Integer> duplicateLeads = new Map<Lead, Integer>();
        Integer duplicityLevel = 0;
        
        for(Lead l : allLeads){
            // Test to see if leads have same associated account
            if(l.Account__c != null && (l.Account__c == currentLead.Account__c)){
                duplicityLevel += 25;
            }
            // Test to see if leads have same associated contact
            if(l.Contact__c != null && (l.Contact__c == currentLead.Contact__c)){
                duplicityLevel += 25;
            }
            // Test to see if leads have same associated email
            if(l.Email != null && (l.Email == currentLead.Email)){
                duplicityLevel += 25;
            }
            // Add duplicity rule for products
            if(!currentProdInterests.isEmpty() && !allProdInterests.isEmpty() &&
               leadsWithProds.get(l.Id) != null && interestedProdIds != null) {
                leadsWithProds.get(l.Id).sort();
                if(interestedProdIds.equals(leadsWithProds.get(l.Id))){
                    duplicityLevel += 25;
                }
            }
            if(duplicityLevel > 0){
                duplicateLeads.add(new DuplicateLead(l.Name, duplicityLevel));
            }
            duplicityLevel = 0;
        }
        
        return duplicateLeads;
    }
}