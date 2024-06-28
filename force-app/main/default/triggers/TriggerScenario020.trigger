trigger TriggerScenario020 on OpportunityLineItem (after insert, after delete) {
    Set<Id> oppIds = new Set<Id>();
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            if(!trigger.new.isEmpty()) {
                for(OpportunityLineItem oli : trigger.new) {
                    oppIds.add(oli.OpportunityId);
                }
            }
        }

        if(trigger.isDelete) {
            if(!trigger.old.isEmpty()){
                for(OpportunityLineItem oli : trigger.old) {
                    oppIds.add(oli.OpportunityId);
                }
            }
        }
    }

    List<Account> accList = new List<Account>();

    if(!oppIds.isEmpty()) {
        List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity WHERE Id IN: oppIds];
        Map<Id, Decimal> accProductCountMap = new Map<Id, Decimal>();

        if(!oppList.isEmpty()) {
            for(Opportunity opp : oppList) {
                accProductCountMap.put(opp.AccountId, 0);
            }

            for(AggregateResult agr : [SELECT COUNT(ID) products, Opportunity.AccountID accId FROM OpportunityLineItem WHERE Opportunity.AccountId IN: accProductCountMap.keySet() GROUP BY Opportunity.AccountId]) {
                accProductCountMap.put((Id) agr.get('accId'), (Decimal) agr.get('products'));
            }

            for(Id accId : accProductCountMap.keySet()) {
                Account acc = new Account();
                acc.Id = accId;
                acc.Number_Of_Products__c = accProductCountMap.get(accId);
                accList.add(acc);
            }
        }
    }

    if(!accList.isEmpty()) {
        update accList;
    }
}