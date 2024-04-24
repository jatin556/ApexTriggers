trigger TriggerScenario43 on Account (after insert, after update) {
    Map<Id, Account> accMap = new Map<Id, Account>();
    Set<Id> accIds = new Set<Id>();
    List<Contact> conList = new List<Contact>();
    if(trigger.isAfter){
        if(trigger.isInsert){
            if(!trigger.new.isEmpty()){
                for(Account acc : trigger.new){
                    if(acc.Create_Contact__c == true) {
                        Contact con = new Contact();
                        con.FirstName = acc.Name;
                        con.LastName = 'Contact';
                        con.AccountId = acc.Id;
                        conList.add(con);
                    }
                }
            }
        }
        else if(trigger.isUpdate){
            if(!trigger.new.isEmpty()){
                for(Account acc : trigger.new){
                    if(acc.Create_Contact__c == true && trigger.oldMap.get(acc.Id).Create_Contact__c == false) {
                        Contact con = new Contact();
                        con.FirstName = acc.Name;
                        con.LastName = 'Contact';
                        con.AccountId = acc.Id;
                        conList.add(con);
                    }
                }
            }
        }

        if(!conList.isEmpty()){
            insert conList;
        }
    }
}