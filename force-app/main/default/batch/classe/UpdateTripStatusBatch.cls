public class UpdateTripStatusBatch implements Database.Batchable<SObject> {

    // Méthode start : Sélectionne tous les voyages actifs
    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        return Database.getQueryLocator([
            SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c
            FROM Trip__c
            WHERE Status__c != 'Annulé'
        ]);
    }

    // Méthode execute : Traite les enregistrements par lots
    public void execute(Database.BatchableContext batchContext, List<Trip__c> trips) {
        List<Trip__c> tripsToUpdate = new List<Trip__c>();

        Date today = Date.today();

        for (Trip__c trip : trips) {
            if (trip.StartTripDate__c != null && trip.EndTripDate__c != null) {
                if (today < trip.StartTripDate__c) {
                    trip.Status__c = 'A venir';  // Si la date de début est dans le futur
                } else if (today >= trip.StartTripDate__c && today <= trip.EndTripDate__c) {
                    trip.Status__c = 'En cours';  // Si la date actuelle est entre la date de début et de fin
                } else if (today > trip.EndTripDate__c) {
                    trip.Status__c = 'Terminé';  // Si la date actuelle est après la date de fin
                }
                tripsToUpdate.add(trip);
            }
        }

        if (!tripsToUpdate.isEmpty()) {
            try {
                TriggerHelper.skipValidation = true;  // Désactiver les triggers pour éviter les validations inutiles
                update tripsToUpdate;
            } catch (DmlException e) {
                // Log de l'erreur (si nécessaire)
            } finally {
                TriggerHelper.skipValidation = false;  // Réactiver les triggers
            }
        }
    }

    // Méthode finish : Exécutée à la fin du traitement
    public void finish(Database.BatchableContext batchContext) {
        // Logic à exécuter à la fin du batch
    }

    // Méthode pour planifier le batch
    public void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new UpdateTripStatusBatch());
    }
}
