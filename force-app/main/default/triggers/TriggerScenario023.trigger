// Scenario 23: Write an Apex Trigger that create or update Tasks based on oppportunity stage changes

trigger TriggerScenario023 on Opportunity (after update) {
    Set<Id> oppIds = new Set<Id>();
    List<Task> taskListToBeUpdated = new List<Task>();
    List<Task> taskListToBeInserted = new List<Task>();

    if(trigger.isAfter && trigger.isUpdate){
        for(Opportunity opp : trigger.new) {
            Opportunity oldOpp = trigger.oldMap.get(opp.Id);
            if(opp.StageName != oldOpp.StageName) {
                oppIds.add(opp.Id);
            }
        }
    }

    if(!oppIds.isEmpty()) {
        List<Task> taskList = [SELECT Id, WhatId, Description FROM Task WHERE WhatId IN: oppIds];
        Map<Id, Task> taskMap = new Map<Id, Task>();

        if(!taskList.isEmpty()) {
            for(Task tsk : taskList) {
                taskMap.put(tsk.WhatId, tsk);
            }
        }

        if(!trigger.new.isEmpty()) {
            for(Opportunity opp : trigger.new) {
                Opportunity oldOpp = trigger.oldMap.get(opp.Id);
                if(opp.StageName != oldOpp.Stagename) {
                    Task newTask;

                    if(taskMap.containsKey(opp.Id)) {
                        newTask = taskMap.get(opp.Id);
                        newTask.Description = 'Opportunity ' + opp.Name + 'has been updated to Stage: ' + opp.StageName +'. Please follow accordingly.';
                        taskListToBeUpdated.add(newTask);
                    } else {
                        newTask = new Task();
                        newTask.WhatId = opp.Id;
                        newTask.Description = 'Opportunity ' + opp.Name + 'has been updated to Stage: ' + opp.StageName +'. Please follow accordingly.';
                        taskListToBeInserted.add(newTask);
                    }
                }
            }
        }

        if(!taskListToBeInserted.isEmpty()) {
            insert taskListToBeInserted;
        }

        if(!taskListToBeUpdated.isEmpty()) {
            update taskListToBeUpdated;
        }
    }
}