trigger CaseTrigger on Case (after insert) {
    
    if(Trigger.isInsert && Trigger.isAfter){
        
        // Create and populate a map of all cloned cases and their source case id
        //List<Case> clonedCases = new List<Case>();        
        Map<Id, Case> sourceToCloneIds = new Map<Id, Case>();
        for(Case c : Trigger.new){
            if(c.isClone()){
                sourceToCloneIds.put(c.getCloneSourceId(), c);
            }
        }
        
        // Only do the following if there are any cloned cases at all
        if(sourceToCloneIds.size() > 0){
            // Query a list of source cases
            List<Case> closedSourceCases = [SELECT Id, IsClosed FROM Case WHERE Id IN :sourceToCloneIds.keySet()];
            // Create a list of cloned cases whose source is closed
            List<Case> clonedCasesFromClosedSources = new List<Case>();
            for(Case c : closedSourceCases){
                if(c.IsClosed){
                    clonedCasesFromClosedSources.add(sourceToCloneIds.get(c.Id));
                }
            }
            // Copy the related list of the source cases to the cloned cases
            CaseTriggerHelper.copyRelatedLists(clonedCasesFromClosedSources);
        }
    }
}