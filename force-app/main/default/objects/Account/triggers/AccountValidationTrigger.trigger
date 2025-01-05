trigger AccountValidationTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        Account oldAcc = Trigger.isUpdate ? Trigger.oldMap.get(acc.Id) : null;
        ValidationHelper.validateAccount(acc, oldAcc);
    }
}
