trigger TriggerScenario05 on Contact (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();
    if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete)) {
        for(Contact con : trigger.new) {
            if(con.AccountId != null) {
                accIds.add(con.AccountId);
            }
        }
    }

    if(trigger.isAfter && trigger.isUpdate) {
        for(Contact con : trigger.new) {
            if(con.AccountId != null && con.AccountId != trigger.oldMap.get(con.Id).AccountId) {
                accIds.add(con.AccountId);
                accIds.add(trigger.oldMap.get(con.Id).AccountId);
            } else if(con.AccountId != null) {
                accIds.add(con.AccountId);
            }
        }
    }

    if(trigger.isAfter && trigger.isDelete) {
        for(Contact con : trigger.old) {
            if(con.AccountId != null) {
                accIds.add(con.AccountId);
            }
        }
    }

    if(!accIds.isEmpty()) {
        List<Account> accList = [Select Id, Number_of_Contacts__c, (Select Id from Contacts) from Account Where Id IN: accIds];
        List<Account> accListToBeUpdated = new List<Account>();

        if(!accList.isEmpty()) {
            for(Account acc : accList) {
                acc.Number_of_Contacts__c = acc.Contacts.size();
                accListToBeUpdated.add(acc);
            }
        }

        if(!accListToBeUpdated.isEmpty()) {
            update accListToBeUpdated;
        }
    }
}