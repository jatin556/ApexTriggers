trigger TriggerScenario8 on Opportunity (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            if(!trigger.new.isEmpty()){
                for(Opportunity opp : trigger.new){
                    if(opp.AccountId != null){
                        accIds.add(opp.AccountId);
                    }
                }
            }
        }

        else if(trigger.isUpdate){
            if(!trigger.new.isEmpty()){
                for(Opportunity opp : trigger.new){
                        if(trigger.oldMap.get(opp.Id).AccountId != null && trigger.oldMap.get(opp.Id).AccountId != opp.AccountId) {
                            accIds.add(trigger.oldMap.get(opp.Id).AccountId);
                            accIds.add(opp.AccountId);
                        } else {
                            accIds.add(opp.AccountId);
                        }   
                }
            }
        }

        else if(trigger.isDelete){
            if(!trigger.old.isEmpty()){
                for(opportunity opp : trigger.old){
                    if(opp.AccountId != null){
                        accIds.add(opp.AccountId);
                    }
                }
            }
        }
    }

    if(!accIds.isEmpty()){
        Map<Id,Decimal> accMap = new Map<Id, Decimal>();
        List<Account> accListToUpdate = new List<Account>();
        List<AggregateResult> aggResult = [Select AccountId, Sum(Amount) totalAmt from Opportunity where Accountid IN: accIds Group By AccountId];

        for(AggregateResult agr : aggResult){
            Id accId = (Id) agr.get('AccountId');
            Decimal totalAmount = (Decimal) agr.get('totalAmt');
            accMap.put(accId, totalAmount);
        }

        if(!accMap.isEmpty()){
            for(Id accountId : accIds){
                if(accMap.containsKey(accountId)){
                    Account acc = new Account(Id=accountId, Sum_Of_Opportunities__c=accMap.get(accountId));
                    accListToUpdate.add(acc);
                }
            }
        }

        if(!accListToUpdate.isEmpty()){
            update accListToUpdate;
        }

    }
}