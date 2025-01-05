public class CancelTripsBatch implements Database.Batchable<SObject> {

    // Méthode start : Sélectionne les voyages à vérifier
    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        return Database.getQueryLocator([
            SELECT Id, Name, StartTripDate__c, Number_of_Participants__c, Status__c
            FROM Trip__c
            WHERE StartTripDate__c >= :Date.today() 
            AND StartTripDate__c <= :Date.today().addDays(7)
            AND Status__c != 'Annulé'
        ]);
    }

    // Méthode execute : Traite les enregistrements par lots
    public void execute(Database.BatchableContext batchContext, List<Trip__c> trips) {
        List<Trip__c> tripsToCancel = new List<Trip__c>();

        for (Trip__c trip : trips) {
            if (trip.Number_of_Participants__c != null && trip.Number_of_Participants__c < 10) {
                trip.Status__c = 'Annulé';
                tripsToCancel.add(trip);
            }
        }

        if (!tripsToCancel.isEmpty()) {
            try {
                update tripsToCancel;
            } catch (DmlException e) {
                // Log de l'erreur
            }
        }
    }

    // Méthode finish : Exécutée à la fin du traitement
    public void finish(Database.BatchableContext batchContext) {
        // Logic de fin de traitement
    }
}
