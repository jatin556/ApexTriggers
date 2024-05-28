/**
 * Scenario :
 * Trigger to create a related contact of Account with the same phone as Account’s phone if custom checkbox field on Account is checked.
 */

trigger TriggerScenario07 on Account (after insert, after update) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isAfter) {
        if(trigger.isInsert) {
            for(Account acc : trigger.new) {
                if(acc.Phone != null && acc.Create_Contact__c == true) {
                    accIds.add(acc.Id);
                }
            }
        }

        if(trigger.isUpdate) {
            for(Account acc : trigger.new) {
                Account oldAcc = trigger.oldMap.get(acc.Id);

                if(acc.Phone != null && acc.Create_Contact__c == true && oldAcc.Create_Contact__c == false) {
                    accIds.add(acc.Id);
                }
            }
        }
    }

    if(!accIds.isEmpty()) {
        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Name, Phone from Account Where Id IN: accIds]);
        List<Contact> conListToBeUpdated = new List<Contact>();

        if(!accMap.isEmpty()) {
            for(Account acc : trigger.new) {
                if(accMap.containsKey(acc.Id)) {
                    Contact con = new Contact();
                    con.AccountId = acc.Id;
                    con.FirstName = acc.Name;
                    con.LastName = 'Conatct 21/05';
                    con.Phone = acc.Phone;
        
                    conListToBeUpdated.add(con);
                }
            }
        }
        

        if(!conListToBeUpdated.isEmpty()) {
            insert conListToBeUpdated;
        }
    }
}