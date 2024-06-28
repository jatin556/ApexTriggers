trigger TriggerScenario018 on Account (after update) {
    Set<Id> accIds = new Set<Id>();
    if(trigger.isAfter && trigger.isUpdate) {
        if(!trigger.new.isEmpty()) {
            for(Account acc : trigger.new) {
                if(acc.Close_All_Opps__c == true && 
                    trigger.oldMap.containsKey(acc.Id) &&
                    trigger.oldMap.get(acc.Id).Close_All_Opps__c == false) {
                        accIds.add(acc.Id);
                    }
            }
        }
    }

    if(!accIds.isEmpty()) {
        List<Opportunity> oppList = [SELECT AccountId, Id, StageName, Probability FROM Opportunity WHERE AccountId IN: accIds AND StageName != 'Closed Won' AND Probability >= 70];

        List<Opportunity> listToBeUpdated = new List<Opportunity>();

        for (Opportunity opp : oppList) {
            opp.StageName = 'Closed Won';
            opp.CloseDate = date.today();
            listToBeUpdated.add(opp);
        }

        if(!listToBeUpdated.isEmpty()) {
            update listToBeUpdated;
        }
    }
}