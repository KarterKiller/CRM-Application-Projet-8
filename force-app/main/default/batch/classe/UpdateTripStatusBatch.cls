global class UpdateTripStatusBatch implements Database.Batchable<SObject>, Schedulable {

    // Méthode start : Sélectionne tous les voyages actifs
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('UpdateTripStatusBatch - Début de la méthode start');
        return Database.getQueryLocator([
            SELECT Id, Name, Start_Date__c, End_Date__c, Status__c
            FROM Trip__c
            WHERE Status__c != 'Annulé'
        ]);
    }

    // Méthode execute : Traite les enregistrements par lots
    global void execute(Database.BatchableContext BC, List<Trip__c> trips) {
        System.debug('UpdateTripStatusBatch - Début de la méthode execute');
        System.debug('Nombre de voyages dans le lot : ' + trips.size());

        List<Trip__c> tripsToUpdate = new List<Trip__c>();

        for (Trip__c trip : trips) {
            System.debug('Traitement du voyage : ' + trip.Name);

            if (trip.Start_Date__c != null && trip.End_Date__c != null) {
                Date today = Date.today();

                if (today < trip.Start_Date__c) {
                    trip.Status__c = 'A venir';
                } else if (today >= trip.Start_Date__c && today <= trip.End_Date__c) {
                    trip.Status__c = 'En cours';
                } else if (today > trip.End_Date__c) {
                    trip.Status__c = 'Terminé';
                }

                tripsToUpdate.add(trip);
                System.debug('Mise à jour du statut du voyage : ' + trip.Name + ' -> ' + trip.Status__c);
            }
        }

        if (!tripsToUpdate.isEmpty()) {
            try {
                update tripsToUpdate;
                System.debug('Voyages mis à jour : ' + tripsToUpdate.size());
            } catch (DmlException e) {
                System.debug('Erreur lors de la mise à jour des statuts : ' + e.getMessage());
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
