trigger TriggerScenario6 on Account (before insert, before update) {
    Set<String> accNames = new Set<String>();
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            if(!trigger.new.isEmpty()){
                for(Account acc : trigger.new){
                    if(acc.Name != null){
                        accNames.add(acc.Name);
                    }
                }
            }
        }

        if(!accNames.isEmpty()){
            Map<String,Account> existingAccMap = new Map<String,Account>();
            List<Account> accList = [Select Id, Name from Account where Name In: accNames];

            if(!accList.isEmpty()){
                for(Account acc : accList){
                    existingAccMap.put(acc.Name, acc);
                }
            }

            if(!existingAccMap.isEmpty()){
                for(Account acc : trigger.new){
                    if(existingAccMap.containsKey(acc.Name)){
                        acc.addError('An account with the same name exists already!');
                    }
                }
            }
            
            
        }
    }
}