/**
 * Scenario : When a case is inserted on any account, put the latest case number on the account in Latest Case Inserted field.
 */

trigger TriggerScenario012 on Case (after insert) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isAfter && trigger.isInsert) {
        for(Case cs : trigger.new) {
            if(cs.AccountId != null) {
                accIds.add(cs.AccountId);
            }
        }
    }

    if(!accIds.isEmpty()) {
        Map<Id, Account> accMap = new Map<Id, Account>();

        List<Account> accList = [Select Id, Latest_Case_Number__c from Account where Id IN: accIds];
        List<Account> accListToBeUpdated = new List<Account>();

        if(!accList.isEmpty()) {
            for(Account acc : accList) {
                accMap.put(acc.Id, acc);
            }
        }

        for(Case cs : trigger.new){
            if(cs.AccountId != null && accMap.containsKey(cs.AccountId)) {
                Account acc = accMap.get(cs.AccountId);
                acc.Latest_Case_Number__c = cs.CaseNumber;
                accListToBeUpdated.add(acc);
            }
        }

        if(!accListToBeUpdated.isEmpty()){
            update accListToBeUpdated;
        }
    }
}