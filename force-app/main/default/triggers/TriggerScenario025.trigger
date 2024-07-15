// Trigger to update Account's description by OpportunityLineItem's description which is associated with Opportunity.

trigger TriggerScenario025 on OpportunityLineItem (after insert, after update, after delete) {
    Set<Id> oppIds = new Set<Id>();
    
    if(trigger.isAfter) {
        if(trigger.isInsert && trigger.isUpdate) {
            for(OpportunityLineItem oli : trigger.new) {
                if(String.isNotBlank(oli.Description)) {
                    oppIds.add(oli.OpportunityId);
                }
            }
        }

        if(trigger.isDelete) {
            for(OpportunityLineItem oli : trigger.old) {
                if(String.isNotBlank(oli.Description)) {
                    oppIds.add(oli.OpportunityId);
                }
            }
        }
    }

    if(!oppIds.isEmpty()) {
        Map<Id, String> accDescMap = new Map<Id, String>();
        List<OpportunityLineItem> oliList = [Select Description, Opportunity.AccountId from OpportunityLineItem Order By LastModifiedDate Desc Limit 1];

        if(!oliList.isEmpty()) {
            for(OpportunityLineItem oli : oliList) {
                
                    if(String.isNotBlank(oli.Description)) {
                        accDescMap.put(oli.Opportunity.AccountId, oli.Description);
                    }
                
             }
        }
        

        List<Account> accList = new List<Account>();

        
        for(Id accId : accDescMap.keySet()) {
            Account acc = new Account();
            acc.Id = accId;

            String latestDesc = accDescMap.get(accId);

            if(String.isNotBlank(latestDesc)) {
                acc.Description = latestDesc;
                accList.add(acc);
            }
            
        }
        

        if(!accList.isEmpty()) {
            update accList;
        }
    }
}