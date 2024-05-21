/*
    Scenario : Update Account's description field whenever related contact field is updated
*/

trigger TriggerScenario4 on Contact (after update) {
    Set<Id> accIds = new Set<Id>();
    if(trigger.isAfter && trigger.isUpdate) {
        if(!trigger.new.isEmpty()) {
            for(Contact con : trigger.new) {
                if(con.AccountId != null) {
                    if(con.Description != trigger.oldMap.get(con.Id).Description) {
                        accIds.add(con.AccountId);
                    }
                }
            }
        }
    }

    if(!accIds.isEmpty()) {
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Description From Account Where Id IN: accIds]);
        List<Account> accToBeUpdated = new List<Account>();

        if(!accMap.isEMpty()) {
            for(Contact con : trigger.new) {
                if(con.AccountId != null) {
                    if(con.Description != trigger.oldMap.get(con.Id).Description) {
                        if(accMap.containsKey(con.AccountId)) {
                            Account acc = accMap.get(con.AccountId);
                            acc.Description = con.Description;
                            accToBeUpdated.add(acc);
                        }
                    }
                }
            }
        }

        if(!accToBeUpdated.isEmpty()) {
            update accToBeUpdated;
        }
    }
}
