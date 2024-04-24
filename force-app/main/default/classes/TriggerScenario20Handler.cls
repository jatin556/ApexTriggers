public with sharing class TriggerScenario20Handler {
    @future
    public static void tgrMethod(Set<Id> deactivatedUserIds, Map<Id,Id> managerIds) {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Opportunity opp : [Select Id, IsClosed, OwnerId from Opportunity where OwnerId IN : deactivatedUserIds AND IsClosed = false]) {
            Id newOwnerId = managerIds.get(opp.OwnerId);
            if(newOwnerId != null) {
                opp.OwnerId = newOwnerId;
                oppList.add(opp);
            }
        }

        if (!oppList.isEmpty()) {
            update oppList;
        }
    }
}