public class CaseTriggerHelper {
    
    // Clone: Attachments, CaseComments, Events, Tasks to new cases
    public static void copyRelatedLists(List<Case> clones){
        
        // Create a map that relates the source record id to its clone
        Map<Id, Id> sourceToCloneIds = new Map<Id, Id>();
        for(Case c : clones){
            sourceToCloneIds.put(c.getCloneSourceId(), c.Id);
        }
        
        // Query for all related lists in cases whose Id is one of the source Ids
        List<Case> sourceCaseRelatedLists = [SELECT Id,
                                             (SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp, ShareType, Visibility FROM ContentDocumentLinks),
                                             (SELECT Id, CommentBody FROM CaseComments),
                                             (SELECT Id, Subject, Location, StartDateTime, EndDateTime, ActivityDateTime, Description, DurationInMinutes, IsAllDayEvent FROM Events),
                                             (SELECT Id, Subject, Description, Status, Priority, TaskSubtype, CompletedDateTime, ActivityDate FROM Tasks)
                                             FROM Case 
                                             WHERE Id IN :sourceToCloneIds.keySet()];
        
        // Create lists where we will add the new related records to insert
        List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();
        List<CaseComment> commentsToInsert = new List<CaseComment>();
        List<Event> eventsToInsert = new List<Event>();
        List<Task> tasksToInsert = new List<Task>();
        
        // Loop through all source cases and their related lists.
        // For each record in related lists, clone record and
        // re-parent to the newly cloned record
        for(Case c : sourceCaseRelatedLists){ // Looping through all source cases
            System.debug('Made it here...');
            System.debug('Size: ' + c.ContentDocumentLinks.size());
            for(ContentDocumentLink cdl : c.ContentDocumentLinks){ // Looping through each related list in source case
                System.debug('CDL ID: '+cdl.id);
                ContentDocumentLink newCDL = cdl.clone(); // Cloning record
                System.debug('NewCDL: '+newCDL);
                newCDL.LinkedEntityId = sourceToCloneIds.get(c.Id); // Re-parenting new cloned record to cloned case
                cdlToInsert.add(newCDL); // Adding it to list to insert later
            }
            for(CaseComment cc : c.CaseComments){
                CaseComment newC= cc.clone();
                newC.ParentId = sourceToCloneIds.get(c.Id);
                commentsToInsert.add(newC);
            }
            for(Event e : c.Events){
                Event newE = e.clone();
                newE.WhatId = sourceToCloneIds.get(c.Id);
                eventsToInsert.add(newE);
            }
            for(Task t : c.Tasks){
                Task newT = t.clone();
                newT.WhatId = sourceToCloneIds.get(c.Id);
                tasksToInsert.add(newT);
            }
        }
        
        // Insert all new related recordss
        insert cdlToInsert;
        insert commentsToInsert;
        insert eventsToInsert;
        insert tasksToInsert; 
    }
}