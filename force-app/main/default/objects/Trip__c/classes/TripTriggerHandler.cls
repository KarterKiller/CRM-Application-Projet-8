public class TripTriggerHandler {
    public static void validateDates(List<Trip__c> trips) {
        for (Trip__c trip : trips) {
            // Vérifier que les nouvelles dates ne sont pas nulles
            if (trip.StartTripDate__c != null && trip.EndTripDate__c != null) {
                // Vérifier que la date de fin est postérieure à la date de début
                if (trip.EndTripDate__c <= trip.StartTripDate__c) {
                    trip.addError('La date de fin du voyage doit être postérieure à la date de début.');
                }
            }
        }
    }
}
