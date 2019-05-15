trigger createAssetOnAcct on Order (after Update) {

    for(Order o : Trigger.new){
        if(o.Status == 'Activated'){
            String acctId = o.AccountId;
            String oId = o.Id;
            Account acct = [SELECT Id, Name FROM Account WHERE Id = :acctId];
            Asset[] asst = new Asset[]{};
            Asset a = new Asset();
            
        }
    }
}