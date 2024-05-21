/*
    Scenario : Update Contact's phone whenever it;s parent Account Phone number is updated.
*/

trigger TriggerScenario3 on Account (after update) {
    Map<Id, Account> accMap = new Map<Id, Account>();

    if(trigger.isAfter && trigger.isUpdate) {
        if(!trigger.new.isEmpty()) {
            for(Account acc : trigger.new) {
                if(acc.Phone != null) {
                    if(acc.phone != trigger.oldMap.get(acc.Id).Phone) {
                        accMap.put(acc.Id, acc);
                    }
                }
            }
        }
    }

    if(!accMap.isEmpty()) {
        List<Contact> conList = [Select Id, AccountId, Phone from Contact Where AccountId IN : accMap.keySet()];
        List<Contact> conListToBeUpdated = new List<Contact>();

        if(!accMap.isEmpty()) {
            for(Contact con : conList) {
                if(accMap.containsKey(con.AccountId)) {
                    con.Phone = accMap.get(con.AccountId).Phone;
                    conListToBeUpdated.add(con);
                }
            }
        }

        if(!conListToBeUpdated.isEmpty()) {
            update conListToBeUpdated;
        }
    }
}