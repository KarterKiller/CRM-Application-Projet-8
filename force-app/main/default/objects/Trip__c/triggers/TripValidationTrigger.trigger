trigger TripValidationTrigger on Trip__c (before insert, before update) {
    // Appeler ValidationHelper pour gérer les validations des voyages
    ValidationHelper.validateTrip(Trigger.new, Trigger.oldMap);
}
