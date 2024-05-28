/**
 * Scebario : Update the Parent Account field with the Opportunity Name that has the highest Amount
 */

trigger TriggerScenario016 on Opportunity (after insert, after update, after delete, after undelete) {
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
                    if(oldOpp.AccountId != null && oldOpp.AccountId != opp.AccountId) {
                        accIds.add(oldOpp.AccountId);
                        accIds.add(opp.AccountId);
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

    // if(!accIds.isEmpty()) {
    //     List<Account> accList = [Select Highest_Opp_Name__c, (Select Name, Amount from Opportunities Where Amount != null Order By Amount Desc Limit 1) From Account Where Id IN: accIds];

    //     List<Account> accListToBeUpdated = new List<Account>();

    //     if(!accList.isEmpty()) {
    //         for(Account acc : accList) {
    //             if(!acc.Opportunities.isEmpty()) {
    //                 acc.Highest_Opp_Name__c = acc.Opportunities[0].Name;
    //                 accListToBeUpdated.add(acc);
    //             } else {
    //                 acc.Highest_Opp_Name__c = '';
    //                 accListToBeUpdated.add(acc);
    //             }
    //         }
    //     }

    //     if(!accListToBeUpdated.isEmpty()) {
    //         update accListToBeUpdated;
    //     }
    // }

    // if(!accIds.isEmpty()) {
    //     List<AggregateResult> aggResList = [Select AccountId, Max(Amount) maxAmount from Opportunity Where AccountId IN: accIds Group By AccountId];

    //     Map<Id, Decimal> maxOppAmtMap = new Map<Id,Decimal>();

    //     List<Account> accListToBeUpdated = new List<Account>();

    //     if(!aggResList.isEmpty()) {
    //         for(AggregateResult aggRes : aggResList) {
    //             maxOppAmtMap.put((Id) aggRes.get('AccountId'), (Decimal) aggRes.get('maxAmount'));
    //         }
    //     }

    //     System.debug('maxOppAmtMap : ' + maxOppAmtMap);

    //     if(!maxOppAmtMap.isEmpty()) {
    //         for(Account acc : accIds) {
    //             if(maxOppAmtMap.containsKey(acc.AccountId)) {
    //                 System.debug('Account ID : ' + opp.AccountId);
    //                 System.debug('inside opportunity for loop : '+ maxOppAmtMap.containsKey(opp.AccountId) + ' ' +  maxOppAmtMap.get(opp.AccountId));
    //                 Account acc = new Account();
    //                 acc.Id = opp.AccountId;
    //                 acc.Highest_Opp_Name__c = opp.Name;
    //                 accListToBeUpdated.add(acc);
    //             }
    //         }
    //     } else {
    //         for(Id accId : accIds) {
    //             Account acc = new Account();
    //             acc.Id = accId;
    //             acc.Highest_Opp_Name__c = '';
    //             accListToBeUpdated.add(acc);
    //         }
    //     }

    //     if(!accListToBeUpdated.isEmpty()) {
    //         update accListToBeUpdated;
    //     }
    // }
}