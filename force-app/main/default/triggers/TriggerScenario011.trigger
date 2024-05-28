/**
 * Scenario : Trigger to show an error if there are already two contacts present on an account and the user tries to add one more contact on it.
 */

trigger TriggerScenario011 on Contact (before insert) {
    Set<Id> accIds = new Set<Id>();

    if(trigger.isBefore && trigger.isInsert){
        for(Contact con : trigger.new){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
    }

    if(!accIds.isEmpty()) {
        List<AggregateResult> aggResList = [Select AccountId, COUNT(Id) conCount from Contact where AccountId In: accIds group by AccountId];

        Map<Id, Integer> accMap = new Map<Id, Integer>();

        if(!aggResList.isEmpty()) {
            for(AggregateResult agr : aggResList) {
                accMap.put((Id) agr.get('AccountId'), (Integer) agr.get('conCount'));
            }
        }

        for(Contact con : trigger.new) {
            if(con.AccountId != null && accMap.containsKey(con.AccountId) && accMap.get(con.AccountId) >= 2) {
                con.addError('There are already two contacts attach to this account, cannot create more than 2 contacts on an account!');
            }
        }
    }
}