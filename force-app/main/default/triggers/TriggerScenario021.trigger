trigger TriggerScenario021 on OpportunityLineItem (after insert) {
    Set<Id> oppId = new Set<Id>();
    List<Asset> assetList = new List<Asset>();
    
    if(trigger.isAfter && trigger.isInsert) {
        if(!trigger.new.isEmpty()) {
            for(OpportunityLineItem oli : trigger.new) {
                oppId.add(oli.OpportunityId);
            }
        }
    }

    if(!oppId.isEmpty()) {
        List<Opportunity> oppList = [SELECT Id, Account.Name, AccountId FROM Opportunity WHERE Id IN: oppId];

        if(!oppList.isEmpty()) {
            for(Opportunity opp : oppList) {
                Asset newAsset = new Asset();
                newAsset.Name = 'Test Asset 28/06' + opp.Account.Name + ' Opportunity Line Item';
                newAsset.AccountId = opp.AccountId;
                assetList.add(newAsset);
            }
        }
    }

    if(!assetList.isEmpty()) {
        insert assetList;
    }
}