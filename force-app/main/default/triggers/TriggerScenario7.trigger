trigger TriggerScenario7 on Account (after insert, after update) {
    List<Contact> conListToUpdate = new List<Contact>();

    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            if(!trigger.new.isEmpty()){
                for(Account acc : trigger.new){
                    if(acc.Phone != null && acc.Create_Contact_With_Phone__c == true){
                        Contact con = new Contact();
                        con.FIrstName = acc.Name;
                        con.LastName = 'Contact';
                        con.Phone = acc.Phone;
                        con.AccountId = acc.Id;
                        conListToUpdate.add(con);
                    }
                }
            }
        }
        if(!conListToUpdate.isEmpty()){
            insert conListToUpdate;
        }
    }
}

    