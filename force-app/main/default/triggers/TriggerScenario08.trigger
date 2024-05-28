/**
 * Scenario : Trigger to find sum of all related opportunities Amount of an Account.
 */

trigger TriggerScenario08 on Opportunity (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUndelete) {
            for(Opportunity opp : trigger.new) {
                if(opp.AccountId != null) {
                    accIds.add(opp.AccountId);
                }
            }
        }

        if(trigger.isUpdate) {
            for(Opportunity opp : trigger.new) {
                Opportunity oldOpp = trigger.oldMap.get(opp.Id);
                if(opp.AccountId != null) {
                    if(oldOpp.AccountId != null && opp.AccountId != oldOpp.AccountId) {
                        accIds.add(opp.AccountId);
                        accIds.add(oldOpp.AccountId);
                    } else {
                        accIds.add(opp.AccountId);
                    }
                }
            }
        }

        if(trigger.isDelete) {
            for(Opportunity opp : trigger.old) {
                if(opp.AccountId != null) {
                    accIds.add(opp.AccountId);
                }
            }
        }
    }

    if(!accIds.isEmpty()) {
        List<AggregateResult> oppList = [Select AccountId accId, SUM(Amount) totalAmount from Opportunity Where AccountId IN: accIds Group By AccountId];
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Sum_Of_All_Opps_Via_Trigger__c from Account Where Id IN: accIds]);
        List<Account> accListToBeUpdated = new List<Account>();

        if(!oppList.isEmpty()) {
            for(AggregateResult aggr : oppList) {
                if(accMap.containsKey((Id) aggr.get('accId'))){
                    Account acc = accMap.get((Id) aggr.get('accId'));
                        acc.Sum_Of_All_Opps_Via_Trigger__c = (Decimal) aggr.get('totalAmount');
                        accListToBeUpdated.add(acc);
                    
                }
            }
        } else {
            for(Id accId : accIds) {
                Account acc = new Account();
                acc.Id = accId;
                acc.Sum_Of_All_Opps_Via_Trigger__c = 0;
                accListToBeUpdated.add(acc);
            }
        }
        

        if(!accListToBeUpdated.isEmpty()) {
            update accListToBeUpdated;
        }
    }
}