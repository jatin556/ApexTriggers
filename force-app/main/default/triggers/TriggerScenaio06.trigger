trigger TriggerScenaio06 on Account (before insert, before update) {
    Set<String> accNames = new Set<String>();
    if(trigger.isBefore) {

        if(trigger.isInsert || trigger.isUpdate) {
            for(Account acc : trigger.new) {
                if(acc.Name != null) {
                    accNames.add(acc.Name);
                }
            }
        }
    }

    if(!accNames.isEmpty()) {
        Map<String, Account> accMap = new Map<String, Account>([Select Name, Id from Account where Name IN: accNames]);

        if(!accMap.isEmpty()) {
            for(Account acc : trigger.new) {
                if(accMap.containsKey(acc.Name)) {
                    acc.addError('This Account name already exists!');
                }
            }
        }
    }
}