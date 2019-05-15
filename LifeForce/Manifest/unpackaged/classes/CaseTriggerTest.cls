@isTest
public class CaseTriggerTest {
    
    @isTest
    public static void testCaseTriggerSingle(){
        
        // Create a new case and associate it with attachments (ContentDocumentLink)
        // casecomments, tasks and events
        Case c1 = new Case(Status = 'Closed');
        insert c1;
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion_1;
        ContentDocument documents = [SELECT Id FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink cdl1 = new ContentDocumentLink(ContentDocumentId = documents.Id, LinkedEntityId = c1.Id,
                                                           ShareType = 'V');
        insert cdl1;
        CaseComment cc1 = new CaseComment(ParentId = c1.Id);
        insert cc1;
        CaseComment cc2 = new CaseComment(ParentId = c1.Id);
        insert cc2;
        Event e1 = new Event(WhatId = c1.Id, DurationInMinutes = 10, ActivityDateTime = DateTime.now());
        insert e1;
        Task t1 = new Task(WhatId = c1.Id);
        insert t1;
        Task t2 = new Task(WhatId = c1.Id);
        insert t2;
        
        
        Case clonedC1 = c1.clone();
        insert clonedC1;
        
        Case clonedCase1 = [SELECT Id,
                            (SELECT Id FROM ContentDocumentLinks) ,
                            (SELECT Id FROM CaseComments),
                            (SELECT Id FROM Events),
                            (SELECT Id FROM Tasks)
                            FROM Case 
                            WHERE Id =:clonedC1.Id
                            LIMIT 1];
        
        System.assertNotEquals(clonedCase1.Id, c1.Id);
        System.assertEquals(clonedCase1.ContentDocumentLinks.size(), 1);
        System.assertEquals(clonedCase1.CaseComments.size(), 2);   
        System.assertEquals(clonedCase1.Events.size(), 1);   
        System.assertEquals(clonedCase1.Tasks.size(), 2);
    }
    
    @isTest
    public static void testCaseTriggerNegatives(){
        
        // Testing negative cases
        Case c2 = new Case(); // Case where status isn't closed
        insert c2;
        
        Task t2 = new Task(WhatId = c2.Id);
        insert t2;
        
        // Related lists should not get copied over because source isn't closed
        Case clonedC2 = c2.clone();
        insert clonedC2;
        
        Case clonedCase2 = [SELECT Id,
                            (SELECT Id FROM Tasks)
                            FROM Case 
                            WHERE Id =:clonedC2.Id
                            LIMIT 1];
        
        // Task should not have been copied over
        System.assertEquals(clonedCase2.Tasks.size(), 0);      
    }
}