trigger OppTrigger on Opportunity (before insert, after update) {
    if(Trigger.isBefore && Trigger.isInsert){
        Id stdPriceBookId;
        //if testing standard price book cannot be queried
        if(Test.isRunningTest()){stdPriceBookId = Test.getStandardPricebookId();}else{ stdPriceBookId =[select id, name from Pricebook2 where isStandard = true limit 1].id; }
        for(Opportunity opp : Trigger.new){
            if(opp.PriceBook2ID == null){
                opp.PriceBook2ID = stdPriceBookId;
            }
        }
    }
    //when opp stage is updated to be closed won
      if(Trigger.isAfter && Trigger.isUpdate){
        List<ID> wonOppId = new List<ID>();
        for ( Opportunity newRecord : (List<Opportunity>) Trigger.new ) {
            Opportunity oldRecord = (Opportunity) Trigger.oldMap.get( newRecord.id );
            // check if opportunity was won, if won add to the list
            if ( newRecord.stageName == 'Closed Won' && oldRecord.stageName != 'Closed Won') {
                wonOppId.add( newRecord.Id );
            }  
        } 
        if(wonOppId.size() > 0){
            OppTriggerHandler oppHandler = new OppTriggerHandler();
            oppHandler.handleWonOpp(wonOppId);
        }
    }
}