/**
 *
 * Scenario :  Enforce single Primary Contact on Account
 */

trigger TriggerScenario017 on Contact (before insert, before update) {
    Set<Id> accIds = new Set<Id>();
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            for(Contact con : )
        }
    }
}