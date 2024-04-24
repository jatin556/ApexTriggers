trigger TriggerScenario42 on Account (before update) {
    Set<Id> accids = new Set<Id>();
    if(trigger.isBefore && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Contact con : [Select Id, isActive__c, AccountId from Contact where isActive__c = true AND AccountId IN : trigger.newMap.keySet()]) {
                accids.add(con.AccountId);
            }
        }
    }

   
        for(Account acc : trigger.newMap.values()){
            Account oldAcc = trigger.oldMap.get(acc.Id);
            if(oldAcc.Status__c == 'Active'){
                if(acc.Status__c == 'Inactive' && accids.contains(acc.Id)){
                    acc.addError('Cannot delete an account with an active contact!');
                }
            }
        }
    
}