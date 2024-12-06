trigger TripNameGenerator on Trip__c (before insert) {
    Integer counter = 1; // Utilisé pour ajouter un identifiant unique
    for (Trip__c trip : Trigger.new) {
        if (String.isBlank(trip.Name)) {
            String destination = trip.Destination__c != null ? trip.Destination__c : 'Unknown';
            String startDate = trip.StartTripDate__c != null ? trip.StartTripDate__c.format() : 'NoDate';  // Utilisation du nouveau champ StartTripDate__c
            String accountName = trip.Account__r != null ? trip.Account__r.Name : 'NoAccount';

            // Générer un nom lisible avec un identifiant unique
            trip.Name = 'Trip - ' + destination + ' - ' + startDate + ' - ' + accountName + ' - ' + counter;
            counter++;
        }
    }
}
