trigger TriggerScenario1 on Account (before insert) {
    if(trigger.isBefore && trigger.isInsert) {
        if(!trigger.new.isEmpty()) {
            for(Account acc : trigger.new) {
                if(acc.Phone == null) {
                    acc.addError('Phone flied cannot be empty!');
                }
            }
        }
    }
}