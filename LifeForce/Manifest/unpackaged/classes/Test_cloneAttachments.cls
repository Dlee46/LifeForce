@isTest 
private class Test_cloneAttachments{
   
    @isTest
    private static void testCloneAttatchment(){
      // Insert Parent Case
      Case parentCase = new Case();
      parentCase.Status = 'New';
      parentCase.Origin = 'Email';
      insert parentCase;
      // Insert Child Case.
      Case childCase = new Case();
      childCase.Status = 'New';
      childCase.Origin  = 'Email';
      childCase.ParentId = parentCase.Id;
      insert childCase;
      // Insert Attachment to child Case
      Attachment attTest = new Attachment();
      attTest.Name ='Test Attachment';
      attTest.Body = Blob.ValueOf('Test Cotent');
      attTest.ParentId = childCase.Id;
      insert attTest;
      // Update Child Case in order to test the functionality of trigger.
      childCase.Origin = 'Web';
      update childCase;
   }
}