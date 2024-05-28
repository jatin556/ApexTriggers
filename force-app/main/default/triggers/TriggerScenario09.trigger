/**
 * Scenario:
 * Trigger on the Account when the account is updated, check all the opportunities related to the account. Update all the opportunities stage to closed lost if an opportunity created date is greater than 30 days from today and stage is not equal to close won.
 */

trigger TriggerScenario09 on Account (after update) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isAfter && trigger.isUpdate) {
        for(Account acc : trigger.new) {
            accIds.add(acc.Id);
        }
    }

    if(!accIds.isEmpty()) {
        List<Opportunity> oppList = new List<Opportunity>([Select AccountId, CloseDate, Opportunity_Created_Date__c, StageName from Opportunity where AccountId IN: accIds And StageName Not In ('Closed Won')]);

        List<Opportunity> oppListToBeUpdated = new List<Opportunity>();
        Date days30 = date.today() - 30;
        if(!oppList.isEmpty()) {
            for(Opportunity opp : oppList) {
                
                if(opp.Opportunity_Created_Date__c < days30 && opp.StageName != 'Closed Won') {
                    opp.StageName = 'Closed Lost';
                    opp.CloseDate = date.today();
                    oppListToBeUpdated.add(opp);
                }
            }
        }

        if(!oppListToBeUpdated.isEmpty()) {
            update oppListToBeUpdated;
        }

    }

}