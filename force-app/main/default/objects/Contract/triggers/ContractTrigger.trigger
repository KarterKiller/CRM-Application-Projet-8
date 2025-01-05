trigger ContractTrigger on Contract (before insert, before update, before delete) {
    if (Trigger.isInsert) {
        for (Contract con : Trigger.new) {
            ValidationHelper.validateContractInsert(con);
        }
    }
    if (Trigger.isUpdate) {
        for (Contract con : Trigger.new) {
            Contract oldCon = Trigger.oldMap.get(con.Id);
            ValidationHelper.validateContractUpdate(con, oldCon);
        }
    }
    if (Trigger.isDelete) {
        for (Contract con : Trigger.old) {
            ValidationHelper.validateContractDelete(con);
        }
    }
}
