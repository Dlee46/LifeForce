trigger cloneAttachments on Case(After Update){
     Map<Id, Id> parentCaseIdMap = new Map<Id, Id>();
     for(Case c : Trigger.New){
         if(c.ParentId!=null)parentCaseIdMap.put(c.Id, c.ParentId);
     }
     // Fetch all the attachments related to the child case
     List<Attachment> attachmentList = new List<Attachment>();
     List<Attachment> attachmentToBeCloned = new List<Attachment>();
     attachmentList = [Select Id, Name, ParentId, Body From Attachment Where ParentId in:parentCaseIdMap.keySet()];
     for(Attachment att : attachmentList){
         Attachment a = att.clone();
         if(parentCaseIdMap.containsKey(att.ParentId)){
            a.ParentId = parentCaseIdMap.get(att.ParentId);
            attachmentToBeCloned.add(a); 
         } 
    }
    if(attachmentToBeCloned!=null && attachmentToBeCloned.size()>0){
        insert attachmentToBeCloned;
    }    
}