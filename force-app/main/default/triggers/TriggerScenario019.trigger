trigger TriggerScenario019 on Account (after insert) {
    List<Contact> conList = new List<Contact>();
    Map<Id, Account> accMap = new Map<Id, Account>();
    Set<Id> accIds = new Set<Id>();
    if(trigger.isAfter && trigger.isInsert) {
        if(!trigger.new.isEmpty()) {
            for(Account acc : trigger.new) {
                Contact con = new Contact();
                con.LastName = 'Test Con 27/6' + acc.Name;
                con.AccountId = acc.Id;
                conList.add(con);
                accIds.add(acc.Id);
            }
            if(!conList.isEmpty()) {
                insert conList;
            }
        }
    }
    List<Account> accListToBeUpdated = new List<Account>();

    if(!accIds.isEmpty()) {
        List<Account> accList = [SELECT ID, Client_Contact__c FROM Account WHERE Id IN: accIds];

        for(Account acc : accList) {
            accMap.put(acc.Id, acc);
        }
    }

    if(!conList.isEmpty()) {
        for(Contact con : conList) {
            if(accMap.containsKey(con.AccountId)) {
                Account acc = accMap.get(con.AccountId);
                acc.Client_Contact__c = con.Id;
                accListToBeUpdated.add(acc);
            }
        }
    }

    if(!accListToBeUpdated.isEmpty()) {
        update accListToBeUpdated;
    }
}