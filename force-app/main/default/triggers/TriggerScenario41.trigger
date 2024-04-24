trigger TriggerScenario41 on Opportunity (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete) {
            if(!trigger.new.isEmpty()){
                for(Opportunity opp : trigger.new){
                    if(opp.AccountId != null) {
                        accids.add(opp.AccountId);
                    }
                }
            }
        } 
        else if(trigger.isUpdate){
            if(!trigger.new.isEmpty()){
                for(Opportunity opp : trigger.new){
                    if(opp.AccountId != null){
                        if(trigger.oldMap.get(opp.Id).AccountId != null && opp.AccountId != trigger.oldMap.get(opp.Id).AccountId) {
                            accIds.add(opp.AccountId);
                            accIds.add(trigger.oldMap.get(opp.Id).AccountId);
                        }
                         else {
                            accIds.add(opp.AccountId);
                         }
                    }
                }
            }
        }

        else if(trigger.isDelete){
            if(!trigger.old.isEmpty()){
                for(Opportunity opp : trigger.old){
                    if(opp.AccountId != null){
                        accIds.add(opp.AccountId);
                    }
                }
            }
        }
        
    }

    Map<Id, Decimal> accMap = new Map<Id, Decimal>();
    List<Account> accListToBeUpdated = new List<Account>();

    if(!accIds.isEmpty()){
        List<Opportunity>  oppList = [Select Id, Amount, IsClosed, AccountId from Opportunity where IsClosed = true AND AccountId IN : accIds];

        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                Decimal maxAmount =  accMap.get(opp.AccountId);
                if(maxAmount == null || maxAmount < opp.Amount){
                    maxAmount = opp.Amount;
                    accMap.put(opp.AccountId, maxAmount);
                }
            }
        }
    }

    for (Id accId : accIds) {
        Decimal maxAmt = accMap.get(accId);

        maxAmt = (maxAmt != null) ? maxAmt : 0;

        Account acc = new Account(Id=accId, Max_Closed_Opp_Amount__c=maxAmt);
        accListToBeUpdated.add(acc);
    }

    if(!accListToBeUpdated.isEmpty()){
        update accListToBeUpdated;
    }

}