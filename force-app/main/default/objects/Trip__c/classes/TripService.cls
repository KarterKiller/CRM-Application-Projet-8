public class TripService {

    // **Créer un voyage**
    public static Id createTrip(String name, Date startTripDate, Date endTripDate, String status, Decimal totalCost, Id accountId) {
        if (startTripDate == null || endTripDate == null || endTripDate <= startTripDate) {
            throw new IllegalArgumentException('Les dates du voyage doivent être valides.');
        }
        
        Trip__c newTrip = new Trip__c(
            Name = name,
            StartTripDate__c = startTripDate,  // Utilisation du champ StartTripDate__c
            EndTripDate__c = endTripDate,      // Utilisation du champ EndTripDate__c
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
        Trip__c trip = [SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c, Total_Cost__c, Account__c 
                        FROM Trip__c 
                        WHERE Id = :tripId LIMIT 1];
        if (trip == null) {
            throw new QueryException('Voyage non trouvé.');
        }
        return trip;
    }

    // **Lire les voyages associés à un compte**
    public static List<Trip__c> getTripsByAccountId(Id accountId) {
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

    // **Mettre à jour le statut d'un voyage**
    public static void updateTripStatus(Id tripId, String newStatus) {
        // Validation du statut
        if (String.isEmpty(newStatus)) {
            throw new IllegalArgumentException('Le statut est obligatoire.');
        }

        Trip__c tripToUpdate = [SELECT Id, Status__c FROM Trip__c WHERE Id = :tripId LIMIT 1];
        tripToUpdate.Status__c = newStatus;
        update tripToUpdate;
        System.debug('Statut du voyage mis à jour : ' + tripToUpdate.Id + ' -> ' + newStatus);
    }

    // **Mettre à jour le coût total d'un voyage**
    public static void updateTripCost(Id tripId, Decimal newCost) {
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
        Trip__c tripToDelete = [SELECT Id FROM Trip__c WHERE Id = :tripId LIMIT 1];
        delete tripToDelete;
        System.debug('Voyage supprimé : ' + tripToDelete.Id);
    }

    // **Supprimer tous les voyages associés à un compte**
    public static void deleteTripsByAccountId(Id accountId) {
        List<Trip__c> tripsToDelete = [SELECT Id FROM Trip__c WHERE Account__c = :accountId];
        delete tripsToDelete;
        System.debug('Voyages supprimés pour le compte : ' + accountId);
    }
}
