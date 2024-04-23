/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger  on Order (before update, after update) {
    if (Trigger.isBefore) {
        OrderTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isAfter) {
        OrderTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}
//The issue you're experiencing is due to the trigger only processing the first record in the Trigger.new list. This is why only the first order is updated when you use Data Loader to update multiple orders at once.
//To fix this, you should modify the trigger to process all records in the Trigger.new list.
//This version of the trigger will correctly calculate NetAmount__c for all Order records being updated, not just the first one.
