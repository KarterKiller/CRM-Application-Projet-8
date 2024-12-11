public class TripService {

    // **Créer un voyage**
    public static Id createTrip(String name, Date startTripDate, Date endTripDate, String status, Decimal totalCost, Id accountId) {
        // Validation des données d'entrée
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('Le nom du voyage est obligatoire.');
        }
        if (startTripDate == null || endTripDate == null || endTripDate <= startTripDate) {
            throw new IllegalArgumentException('Les dates du voyage doivent être valides et la date de fin doit être postérieure à la date de début.');
        }
        if (String.isBlank(status)) {
            throw new IllegalArgumentException('Le statut du voyage est obligatoire.');
        }
        if (totalCost < 0) {
            throw new IllegalArgumentException('Le coût total ne peut pas être négatif.');
        }
        if (accountId == null) {
            throw new IllegalArgumentException('Un compte doit être associé au voyage.');
        }

        // Création du voyage
        Trip__c newTrip = new Trip__c(
            Name = name,
            StartTripDate__c = startTripDate,
            EndTripDate__c = endTripDate,
            Status__c = status,
            Total_Cost__c = totalCost,
            Account__c = accountId
        );
        insert newTrip;
        System.debug('Nouveau voyage créé : ' + newTrip.Id);
        return newTrip.Id;
    }

    // **Lire un voyage par ID**
    public static Trip__c getTripById(Id tripId) {
        if (tripId == null) {
            throw new IllegalArgumentException('L\'ID du voyage est obligatoire.');
        }

        Trip__c trip = [SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c, Total_Cost__c, Account__c 
                        FROM Trip__c 
                        WHERE Id = :tripId LIMIT 1];
        if (trip == null) {
            throw new QueryException('Voyage non trouvé pour l\'ID donné.');
        }
        return trip;
    }

    // **Mettre à jour le statut d'un voyage**
    public static void updateTripStatus(Id tripId, String newStatus) {
        if (tripId == null) {
            throw new IllegalArgumentException('L\'ID du voyage est obligatoire.');
        }
        if (String.isBlank(newStatus)) {
            throw new IllegalArgumentException('Le nouveau statut est obligatoire.');
        }

        Trip__c tripToUpdate = [SELECT Id, Status__c FROM Trip__c WHERE Id = :tripId LIMIT 1];
        tripToUpdate.Status__c = newStatus;
        update tripToUpdate;
        System.debug('Statut du voyage mis à jour : ' + tripToUpdate.Id + ' -> ' + newStatus);
    }

    // **Mettre à jour le coût total d'un voyage**
    public static void updateTripCost(Id tripId, Decimal newCost) {
        if (tripId == null) {
            throw new IllegalArgumentException('L\'ID du voyage est obligatoire.');
        }
        if (newCost < 0) {
            throw new IllegalArgumentException('Le coût total ne peut pas être négatif.');
        }

        Trip__c tripToUpdate = [SELECT Id, Total_Cost__c FROM Trip__c WHERE Id = :tripId LIMIT 1];
        tripToUpdate.Total_Cost__c = newCost;
        update tripToUpdate;
        System.debug('Coût total du voyage mis à jour : ' + tripToUpdate.Id + ' -> ' + newCost);
    }

    // **Supprimer un voyage**
    public static void deleteTrip(Id tripId) {
        if (tripId == null) {
            throw new IllegalArgumentException('L\'ID du voyage est obligatoire.');
        }

        Trip__c tripToDelete = [SELECT Id FROM Trip__c WHERE Id = :tripId LIMIT 1];
        delete tripToDelete;
        System.debug('Voyage supprimé : ' + tripToDelete.Id);
    }

    // **Lire les voyages associés à un compte**
    public static List<Trip__c> getTripsByAccountId(Id accountId) {
        if (accountId == null) {
            throw new IllegalArgumentException('L\'ID du compte est obligatoire.');
        }

        return [SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c, Total_Cost__c 
                FROM Trip__c 
                WHERE Account__c = :accountId];
    }

    // **Lire les voyages à venir**
    public static List<Trip__c> getUpcomingTrips() {
        return [SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c 
                FROM Trip__c 
                WHERE StartTripDate__c > :Date.today() 
                AND Status__c = 'A venir'];
    }

    // **Supprimer tous les voyages associés à un compte**
    public static void deleteTripsByAccountId(Id accountId) {
        if (accountId == null) {
            throw new IllegalArgumentException('L\'ID du compte est obligatoire.');
        }

        List<Trip__c> tripsToDelete = [SELECT Id FROM Trip__c WHERE Account__c = :accountId];
        delete tripsToDelete;
        System.debug('Voyages supprimés pour le compte : ' + accountId);
    }
}
