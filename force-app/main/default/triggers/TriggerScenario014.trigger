trigger TriggerScenario014 on Account (after update) {
    Set<Id> accIds = new Set<Id>();
    if(trigger.isAfter && trigger.isUpdate) {
        for(Account acc : trigger.new) {
            Account oldAcc = trigger.oldMap.get(acc.Id);
            if(acc.Type != oldAcc.Type) {
                accIds.add(acc.Id);
            }
        }
    }

    if(!accIds.isEmpty()) {
        List<Contact> conList = [Select Id, Email, LastName from Contact Where AccountId IN: accIds];
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        if(!conList.isEmpty()){
            for(Contact con : conList) {
                if(con.Email != null) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setTargetObjectId(con.Id);
                    email.setSenderDisplayName('System Administrator');
                    String emailBody = 'Dear ' + con.LastName + ' ,</br> </br>';
                    emailBody += 'You Account Type has been successfully updated!';
                    email.setHtmlBody(emailBody);
                    email.toaddresses = new String [] {con.Email};
                    email.setSubject('Account Update Info...!!!');
                    emailList.add(email);
                }
            }
        }

        if(!emailList.isEmpty()) {
            Messaging.sendEmail(emailList);
        }
    }
}