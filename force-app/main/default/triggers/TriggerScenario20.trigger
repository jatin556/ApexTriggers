trigger TriggerScenario20 on User (after update) {
    Set<Id> deactivatedUserIds = new Set<Id>();
    Map<Id,Id> managerIds = new Map<Id,Id>();
    
    for (User user : trigger.new) {
        if(user.IsActive == false && trigger.oldMap.get(user.Id).IsActive == true) {
            deactivatedUserIds.add(user.Id);
        }   
    }

    if(deactivatedUserIds.isEmpty()){
        return;
    }

    for(User user : [Select Id, ManagerId from User where Id In : deactivatedUserIds]) {
        if(user.ManagerId != null) {
            managerIds.put(user.Id, user.ManagerId);
        }
    }

    if(managerIds.isEmpty()){
        return;
    }

    TriggerScenario20Handler.tgrMethod(deactivatedUserIds, managerIds);
}