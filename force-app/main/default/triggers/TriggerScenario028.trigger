trigger TriggerScenario028 on Case (after insert, after delete, after update, after undelete) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUndelete) {
            if(!trigger.new.isEmpty()) {
                for(Case cs : trigger.new) {
                    if(cs.AccountId != null) {
                        accIds.add(cs.AccountId);
                    }
                }
            }
        }

        if(trigger.isUpdate) {
            if(!trigger.new.isEmpty()) {
                for(Case cs : trigger.new) {
                    Case oldCs = trigger.oldMap.get(cs.Id);
                    if(cs.AccountId != null) {
                        if(oldCs.AccountId != null && cs.AccountId != oldCs.AccountId) {
                            accIds.add(cs.AccountId);
                            accIds.add(OldCs.AccountId);
                        } else {
                            accIds.add(cs.AccountId);
                        }
                    }
                }
            }
        }

        if(trigger.isDelete) {
            if(!trigger.old.isEmpty()) {
                for(Case cs : trigger.old) {
                    accIds.add(cs.AccountId);
                }
            }
        }

        if(!accIds.isEmpty()) {
            Map<Id, Decimal> accNewCaseMap = new Map<Id, Decimal>();
            Map<Id, Decimal> accWorkingCaseMap = new Map<Id, Decimal>();
            Map<Id, Decimal> accEsclatedCaseMap = new Map<Id, Decimal>();

            Map<Id, Account> accMapToBeUpdated = new Map<Id, Account>();

            for(AggregateResult agr : [Select COUNT(Id) csIds, AccountId accId From Case Where Status = 'New' And AccountId IN: accIds Group By AccountId]) {
                accNewCaseMap.put((Id) agr.get('accId'), (Decimal) agr.get('csIds'));
            }

            for(AggregateResult agr : [Select COUNT(Id) csIds, AccountId accId From Case Where Status = 'Working' And AccountId IN: accIds Group By AccountId]) {
                accWorkingCaseMap.put((Id) agr.get('accId'), (Decimal) agr.get('csIds'));
            }

            for(AggregateResult agr : [Select COUNT(Id) csIds, AccountId accId From Case Where Status = 'Escalated' And AccountId IN: accIds Group By AccountId]) {
                accEsclatedCaseMap.put((Id) agr.get('accId'), (Decimal) agr.get('csIds'));
            }

            for(Id acId : accIds) {
                Account upAcc = new Account();
                upAcc.Id = acId;
                if(accNewCaseMap.containskey(acId)) {
                    upAcc.Number_of_New_Cases__c = accNewCaseMap.get(acId);
                    accMapToBeUpdated.put(acId,upAcc);
                } else {
                    upAcc.Number_of_New_Cases__c = 0;
                    accMapToBeUpdated.put(acId,upAcc);
                }
                if(accWorkingCaseMap.containsKey(acId)) {
                    upAcc.Number_of_Working_Cases__c = accWorkingCaseMap.get(acId);
                    accMapToBeUpdated.put(acId,upAcc);
                } else {
                    upAcc.Number_of_Working_Cases__c = 0;
                    accMapToBeUpdated.put(acId,upAcc);
                }
                if (accEsclatedCaseMap.containsKey(acId)) {
                    upAcc.Number_of_Esclated_Cases__c = accEsclatedCaseMap.get(acId);
                    accMapToBeUpdated.put(acId,upAcc);
                } else {
                    upAcc.Number_of_Esclated_Cases__c = 0;
                    accMapToBeUpdated.put(acId,upAcc);
                }
            }

            update accMapToBeUpdated.values();
        }
    }
}