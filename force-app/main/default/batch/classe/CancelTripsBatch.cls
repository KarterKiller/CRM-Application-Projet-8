global class CancelTripsBatch implements Database.Batchable<SObject>, Schedulable {

    // Méthode start : Sélectionne les voyages à vérifier
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('CancelTripsBatch - Début de la méthode start');
        // Sélectionner les voyages à 7 jours de la date actuelle
        return Database.getQueryLocator([
            SELECT Id, Name, Start_Date__c, Number_of_Participants__c, Status__c
            FROM Trip__c
            WHERE Start_Date__c = :Date.today().addDays(7)
            AND Status__c != 'Annulé'
        ]);
    }

    // Méthode execute : Traite les enregistrements par lots
    global void execute(Database.BatchableContext BC, List<Trip__c> trips) {
        System.debug('CancelTripsBatch - Début de la méthode execute');
        System.debug('Nombre de voyages dans le lot : ' + trips.size());

        List<Trip__c> tripsToCancel = new List<Trip__c>();

        for (Trip__c trip : trips) {
            System.debug('Traitement du voyage : ' + trip.Name);
            System.debug('Nombre de participants : ' + trip.Number_of_Participants__c);

            if (trip.Number_of_Participants__c != null && trip.Number_of_Participants__c < 10) {
                trip.Status__c = 'Annulé'; // Mettre à jour le statut
                tripsToCancel.add(trip);
                System.debug('Voyage ajouté à la liste des annulations : ' + trip.Name);
            } else {
                System.debug('Voyage non annulé : ' + trip.Name);
            }
        }

        // Mise à jour des voyages annulés
        if (!tripsToCancel.isEmpty()) {
            try {
                System.debug('Annulation des voyages : ' + tripsToCancel);
                update tripsToCancel;
            } catch (DmlException e) {
                System.debug('Erreur lors de la mise à jour des voyages annulés : ' + e.getMessage());
            }
        } else {
            System.debug('Aucun voyage à annuler dans ce lot.');
        }
    }

    // Méthode finish : Exécutée à la fin du traitement
    global void finish(Database.BatchableContext BC) {
        System.debug('CancelTripsBatch - Batch terminé.');
    }

    // Méthode pour planifier le batch
    global void execute(SchedulableContext SC) {
        System.debug('CancelTripsBatch - Planification du batch');
        Database.executeBatch(new CancelTripsBatch());
    }
}
