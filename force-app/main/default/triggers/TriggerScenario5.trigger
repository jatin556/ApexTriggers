trigger TriggerScenario5 on Contact (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();
    if(trigger.isAfter){
        if(trigger.isInsert|| trigger.isUndelete){
            if(!trigger.new.isEmpty()){
                for(Contact con : trigger.new){
                    if(con.AccountId != null){
                        accIds.add(con.AccountId);
                    }
                }
            }
        }

        else if(trigger.isUpdate){
            if(!trigger.new.isEmpty()){
                for(Contact con : trigger.new){
                    if(con.AccountId != trigger.oldMap.get(con.Id).AccountId){
                        if(trigger.oldMap.get(con.Id).AccountId != null){
                            accIds.add(trigger.oldMap.get(con.Id).AccountId);
                        }
                        if(con.AccountId != null){
                            accIds.add(con.AccountId);
                        }
                    }
                }
            }
        }

        else if(trigger.isDelete){
            if(!trigger.old.isEmpty()){
                for(Contact con : trigger.old){
                    if(con.AccountId != null){
                        accIds.add(con.AccountId);
                    }
                }
            }
        }
    }

    if(!accIds.isEmpty()){
        List<Account> accList = [Select Id, Contact_Size__c, (Select Id from Contacts) from Account Where Id in : accIds];
        List<Account> accsToUpdate = new List<Account>();

        if(!accList.isEmpty()){
            for(Account acc : accList){
                acc.Contact_Size__c = acc.Contacts.size();
                accsToUpdate.add(acc);
            }
        }
        
        if(!accsToUpdate.isEmpty()){
            update accsToUpdate;
        }
    }
}