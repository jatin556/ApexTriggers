trigger TriggerScenario024 on OpportunityLineItem (after insert, after delete) {
    Set<Id> oppIds = new Set<Id>();

    if(trigger.isAfter) {
        if(trigger.isInsert) {
            for(OpportunityLineItem oli : trigger.new) {
                oppIds.add(oli.OpportunityId);
            }
        }

        if(trigger.isDelete) {
            for(OpportunityLineItem oli : trigger.old) {
                oppIds.add(oli.OpportunityId);
            }
        }
    }

    if(!oppIds.isEmpty()) {
        List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity WHERE Id IN: oppIds];

        Map<Id, Decimal> accProdCountMap = new Map<Id,Decimal>();

        if(!oppList.isEmpty()) {
            for(Opportunity opp : oppList) {
                accProdCountMap.put(opp.AccountId, 0);
            }
        }

        for(AggregateResult agr : [SELECT COUNT(Id) oli, Opportunity.AccountId accId FROM OpportunityLineItem WHERE OpportunityId IN: oppIds AND ListPrice > 50000 Group By Opportunity.AccountId]) {
            accProdCountMap.put((Id) agr.get('accId'), (Decimal) agr.get('oli'));
        }

        List<Account> accList = [SELECT Id, Number_Of_Products__c FROM Account WHERE Id IN: accProdCountMap.keySet()];
        List<Account> accListToBeUpdated = new List<Account>();

        if(!accList.isEmpty()) {
            for(Account acc : accList) {
                Account upAcc = new Account();
                upAcc.Id = acc.Id;
                upAcc.Number_Of_Products__c = accProdCountMap.get(acc.Id);
                accListToBeUpdated.add(upAcc);
            }
        }

        if(!accListToBeUpdated.isEmpty()) {
            update accListToBeUpdated;
        }
    }
}