/**
 * Scenario 13: Prevent duplication of Contact records based on Email & Phone.
 */

trigger TriggerScenario013 on Contact (before insert, before update) {
    Map<String, Contact> emailMap = new Map<String, Contact>();
    Map<String, Contact> phoneMap = new Map<String, Contact>();

    if(trigger.isBefore) {
        if(trigger.isInsert) {
            for(Contact con : trigger.new) {
                if(con.Email != null){
                    emailMap.put(con.Email, con);
                }
                if(con.Phone != null) {
                    phoneMap.put(con.Phone, con);
                }
            }
        }

        if(trigger.isUpdate) {
            for(Contact con : trigger.new) {
                Contact oldCon = trigger.oldMap.get(con.Id);
                if(con.Email != null && oldCon.Email != null && con.Email != oldCon.Email) {
                    emailMap.put(con.Email, con);
                }

                if(con.Phone != null && oldCon.Phone != null && oldCon.Phone != con.Phone) {
                    phoneMap.put(con.Phone, con);
                }
            }
        }
    }

    List<Contact> conList = [Select Id, Email, Phone from Contact where Email In: emailMap.keySet() OR Phone In: phoneMap.keySet()];

    Map<String, Contact> existingEmailMap = new Map<String, Contact>();
    Map<String, Contact> existingPhoneMap = new Map<String, Contact>();

    for(Contact con : conList) {
        existingEmailMap.put(con.Email, con);
        existingPhoneMap.put(con.Phone, con);
    }

    if(!conList.isEmpty()) {
        for(Contact con : trigger.new) {
            if(con.Email != null && existingEmailMap.containsKey(con.Email)){
                con.addError('This email address is already associated with another contact, can\'t have duplicate emails!');
            }
            if(con.Phone != null && existingPhoneMap.containsKey(con.Phone)){
                con.addError('This Phone number is already associated with another contact, can\'t have duplicate phone  number!');
            }
        }
    }
}