trigger LeadTrigger on Lead (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        // get converted leads into a list 
        // following code from https://github.com/douglascayers/sfdc-preserve-chatter-files-on-lead-conversion/
        List <Lead> convertedLeads = new List<Lead>();
        for ( Lead newRecord : (List<Lead>) Trigger.new ) {
            
            Lead oldRecord = (Lead) Trigger.oldMap.get( newRecord.id );
            // check if lead was converted, if converted add to the list
            if ( newRecord.isConverted && !oldRecord.isConverted ) {
                convertedLeads.add( newRecord );
            }
            
        }
        // if there is any converted lead call handler to copy related products to Opp
        if ( convertedLeads.size() > 0 ) {
            LeadTriggerHandler leadHandler = new LeadTriggerHandler();
            leadHandler.handleConvertedLeads( convertedLeads );
        }
    }
}