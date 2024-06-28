trigger TriggerScenario022 on OpportunityLineItem (before insert) {
    Set<Id> oppIds = new Set<Id>();
    Set<id> pIds = new Set<Id>();

    if(trigger.isBefore && trigger.isInsert) {
        if(!trigger.new.isEmpty()) {
            for(OpportunityLineItem oli : trigger.new) {
                oppIds.add(oli.OpportunityId);
                pIds.add(oli.Product2Id);
            }
        }
    }

    if(!oppIds.isEmpty() && !pIds.isEmpty()) {
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, Product_Family__c FROM Opportunity WHERE ID IN: oppIds]);

        Map<Id, Product2> prodMap = new Map<Id, Product2>([SELECT Id, Family FROM Product2 WHERE ID IN: pIds]);

        if(!trigger.new.isEmpty()) {
            for(OpportunityLineItem oli : trigger.new) {
                if(oppMap.containsKey(oli.OpportunityId) && prodMap.containsKey(oli.Product2Id) && oppMap.get(oli.OpportunityId).Product_Family__c != prodMap.get(oli.Product2Id).Family) {
                    oli.addError('Product Family and Family are not same!');
                }
            }
        }
    }
}