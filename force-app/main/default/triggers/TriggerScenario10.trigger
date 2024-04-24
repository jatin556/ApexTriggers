trigger TriggerScenario10 on Account (before delete) {
    if(trigger.isBefore && trigger.isDelete){
        if(!trigger.old.isEmpty()){
            for(Account acc : trigger.old){
                if(acc.Is_Account_Active__c == true){
                    acc.addError('Cannot delete an active account!');
                }
            }
        }
    }
}