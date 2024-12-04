public class TripTriggerHandler {
    public static void validateDates(List<Trip__c> trips) {
        for (Trip__c trip : trips) {
            // Vérifier que les dates ne sont pas nulles
            if (trip.Start_Date__c != null && trip.End_Date__c != null) {
                // Vérifier que la date de fin est postérieure à la date de début
                if (trip.End_Date__c <= trip.Start_Date__c) {
                    trip.addError('La date de fin doit être postérieure à la date de début.');
                }
            }
        }
    }
}
