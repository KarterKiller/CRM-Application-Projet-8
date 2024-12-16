trigger ContractTrigger on Contract (before insert, before update, before delete) {

    if (Trigger.isInsert) {
        ContractTriggerHandler.validateInsert(Trigger.new);
    }

    if (Trigger.isUpdate) {
        ContractTriggerHandler.validateUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isDelete) {
        ContractTriggerHandler.validateDelete(Trigger.old);
    }
}
