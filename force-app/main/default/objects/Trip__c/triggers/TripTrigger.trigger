trigger TripTrigger on Trip__c (before insert, before update) {
    // Appeler une méthode Handler pour organiser le code
    TripTriggerHandler.validateDates(Trigger.new);
}
