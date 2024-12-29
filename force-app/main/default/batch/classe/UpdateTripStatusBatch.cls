global class UpdateTripStatusBatch implements Database.Batchable<SObject>, Schedulable {

    // Méthode start : Sélectionne tous les voyages actifs
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('UpdateTripStatusBatch - Début de la méthode start');
        return Database.getQueryLocator([
            SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c
            FROM Trip__c
            WHERE Status__c != 'Annulé'
        ]);
    }

    // Méthode execute : Traite les enregistrements par lots
    global void execute(Database.BatchableContext BC, List<Trip__c> trips) {
        System.debug('UpdateTripStatusBatch - Début de la méthode execute');
        System.debug('Nombre de voyages dans le lot : ' + trips.size());

        List<Trip__c> tripsToUpdate = new List<Trip__c>();

        Date today = Date.today();

        for (Trip__c trip : trips) {
            System.debug('Traitement du voyage : ' + trip.Name);

            if (trip.StartTripDate__c != null && trip.EndTripDate__c != null) {

                // Logique de mise à jour du statut
                if (today < trip.StartTripDate__c) {
                    trip.Status__c = 'A venir';  // Si la date de début est dans le futur
                } else if (today >= trip.StartTripDate__c && today <= trip.EndTripDate__c) {
                    trip.Status__c = 'En cours';  // Si la date actuelle est entre la date de début et la date de fin
                } else if (today > trip.EndTripDate__c) {
                    trip.Status__c = 'Terminé';  // Si la date actuelle est après la date de fin
                }

                tripsToUpdate.add(trip);
                System.debug('Mise à jour du statut du voyage : ' + trip.Name + ' -> ' + trip.Status__c);
            }
        }

        if (!tripsToUpdate.isEmpty()) {
            try {
                // Désactiver les validations du trigger temporairement afin de mettre à jour les voyages
                TriggerHelper.skipValidation = true;

                update tripsToUpdate;  // Mettre à jour les voyages

                System.debug('Voyages mis à jour : ' + tripsToUpdate.size());
            } catch (DmlException e) {
                System.debug('Erreur lors de la mise à jour des statuts : ' + e.getMessage());
            } finally {
                // Réactiver les validations
                TriggerHelper.skipValidation = false;
            }
        } else {
            System.debug('Aucun voyage à mettre à jour.');
        }
    }

    // Méthode finish : Exécutée à la fin du traitement
    global void finish(Database.BatchableContext BC) {
        System.debug('UpdateTripStatusBatch - Batch terminé.');
    }

    // Méthode pour planifier le batch
    global void execute(SchedulableContext SC) {
        System.debug('UpdateTripStatusBatch - Planification du batch');
        Database.executeBatch(new UpdateTripStatusBatch());
    }
}
