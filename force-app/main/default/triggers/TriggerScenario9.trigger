trigger TriggerScenario9 on Account (after update) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isAfter && trigger.isUpdate){
        if(!trigger.new.isEmpty()){
            for(Account acc : trigger.new){
                accIds.add(acc.Id);
            }
        }
    }

    if(!accIds.isEmpty()){
        List<Opportunity> oppList = [Select Id, StageName, CloseDate, Test_Created_Date__c, AccountId from Opportunity where AccountId IN: accIds AND StageName !='Closed Won'];

        Date days30 = date.today() - 30;
        List<Opportunity> oppListToBeUpdated = new List<Opportunity>();
        for(Opportunity opp : oppList){
            if(opp.Test_Created_Date__c < days30){
                opp.StageName = 'Closed Lost';
                opp.CloseDate = date.today();
                oppListToBeUpdated.add(opp);
            }
        }

        if(!oppListToBeUpdated.isEmpty()){
            update oppListToBeUpdated;
        }
    }
}