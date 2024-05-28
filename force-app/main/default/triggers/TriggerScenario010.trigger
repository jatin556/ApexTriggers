/**
 *  Scenario : Trigger to prevent a user from deleting an Active account.
 */

trigger TriggerScenario010 on Account (before delete) {
    if(trigger.isBefore && trigger.isDelete) {
        for(Account acc : trigger.old) {
            if(acc.Active_Account__c == true) {
                acc.addError('Cannot delete an active active!');
            }
        }
    }
}