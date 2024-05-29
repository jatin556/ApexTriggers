/**
 *
 * Scenario :  Enforce single Primary Contact on Account
 */

trigger TriggerScenario017 on Contact (before insert, before update) {
    Set<Id> accIds = new Set<Id>();
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            for(Contact con : trigger.new) {
                if(con.AccountId != null) {
                    accIds.add(con.AccountId);
                }
            }
        }

        if(trigger.isUpdate) {
            for(Contact con : trigger.new) {
                Contact oldCon = trigger.oldMap.get(con.Id);
                if(con.AccountId != null) {
                    if(oldCon.AccountId != null && oldCon.AccountId != con.AccountId) {
                        accIds.add(oldCon.AccountId);
                        accIds.add(con.AccountId);
                    } else {
                        accIds.add(con.AccountId);
                    }
                }
            }
        }
    }

    if(!accIds.isEmpty()) {
        List<Contact> conList = [Select Id, AccountId, Primary_Contact__c From Contact Where Primary_Contact__c = true AND AccountId IN: accIds];

        Map<Id, Integer> conMap = new Map<Id, Integer>();

        if(!conList.isEmpty()) {
            for(Contact con : conList) {
                conMap.put(con.AccountId, conList.size());
            }
        }

        if(!conMap.isEmpty()) {
            for(Contact con : trigger.new) {
                if(con.Primary_Contact__c == true && conMap.containsKey(con.AccountId) && conMap.get(con.AccountId) > 0) {
                    con.addError('This Account already has one primary contact, cannot have more than one primary contact on an account!');
                }
            }
        }
    }
}