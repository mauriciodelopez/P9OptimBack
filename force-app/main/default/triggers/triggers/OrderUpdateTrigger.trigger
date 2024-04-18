/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OrderUpdateTrigger on Order (before update, after update) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            OrderTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    } else if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            OrderTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
