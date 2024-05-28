/**
 *
 * Scenario : update techfirm's fields max salary and min salary whenever its child employee__c is inserted, updated deleted or undeleted.
 */

trigger TriggerScenario015 on Employee__c (after insert, after update, after delete, after undelete) {
    Set<Id> parentIds = new Set<Id>();

    if(trigger.isAfter) {
        if(trigger.isInsert ||trigger.isUndelete) {
            for(Employee__c emp : trigger.new) {
                if(emp.Tech_Firm__c != null) {
                    parentIds.add(emp.Tech_Firm__c);
                }
            }
        }

        if(trigger.isUpdate) {
            for(Employee__c emp : trigger.new) {
                Employee__c oldEmp = trigger.oldMap.get(emp.Id);
                if(emp.Tech_Firm__c != null) {
                    if(oldEmp.Tech_Firm__c != null && emp.Tech_Firm__c != oldEmp.Tech_Firm__c) {
                        parentIds.add(emp.Tech_Firm__c);
                        parentIds.add(oldEmp.Tech_Firm__c);
                    } else {
                        parentIds.add(emp.Tech_Firm__c);
                    }
                }
            }
        }

        if(trigger.isDelete) {
            for(Employee__c emp : trigger.old) {
                if(emp.Tech_Firm__c != null) {
                    parentIds.add(emp.Tech_Firm__c);
                }
            }
        }
    }

    if(!parentIds.isEmpty()) {
        List<AggregateResult> aggResList = [Select Tech_Firm__c tfId, MAX(Salary__c) maxSalary, MIN(Salary__c) minSalary From Employee__c Where Tech_Firm__c IN: parentIds Group By Tech_Firm__c];

        List<Tech_Firm__c> listToBeUpdated = new List<Tech_Firm__c>();

        if(!aggResList.isEmpty()) {
            for(AggregateResult ag : aggResList) {
                Tech_Firm__c tf = new Tech_Firm__c();
                tf.Id = (Id) ag.get('tfId');
                tf.Max_Salary__c = (Decimal) ag.get('maxSalary');
                tf.Min_Salary__c = (Decimal) ag.get('minSalary');
                listToBeUpdated.add(tf);
            }
        } else {
            for(Id pId : parentIds) {
                Tech_Firm__c tf = new Tech_Firm__c();
                tf.Id = pId;
                tf.Max_Salary__c = 0;
                tf.Min_Salary__c = 0;
                listToBeUpdated.add(tf);
            }
        }

        if(!listToBeUpdated.isEmpty()) {
            update listToBeUpdated;
        }
    }
}