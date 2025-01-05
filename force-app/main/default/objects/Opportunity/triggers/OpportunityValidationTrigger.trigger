trigger OpportunityValidationTrigger on Opportunity (before insert, before update, after update) {
    if (Trigger.isBefore) {
        ValidationHelper.validateOpportunity(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.createTripAndContractForClosedWon(Trigger.new, Trigger.oldMap);
    }
}
