public class TripService {

    // **Créer un voyage**
    public static Id createTrip(String name, Date startDate, Date endDate, String status, Decimal totalCost, Id accountId) {
        Trip__c newTrip = new Trip__c(
            Name = name,
            Start_Date__c = startDate,
            End_Date__c = endDate,
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
        return [SELECT Id, Name, Start_Date__c, End_Date__c, Status__c, Total_Cost__c, Account__c 
                FROM Trip__c 
                WHERE Id = :tripId];
    }

    // **Lire les voyages associés à un compte**
    public static List<Trip__c> getTripsByAccountId(Id accountId) {
        return [SELECT Id, Name, Start_Date__c, End_Date__c, Status__c, Total_Cost__c 
                FROM Trip__c 
                WHERE Account__c = :accountId];
    }

    // **Lire les voyages à venir**
    public static List<Trip__c> getUpcomingTrips() {
        return [SELECT Id, Name, Start_Date__c, End_Date__c, Status__c 
                FROM Trip__c 
                WHERE Start_Date__c > :Date.today() 
                AND Status__c = 'A venir'];
    }

    // **Mettre à jour le statut d'un voyage**
    public static void updateTripStatus(Id tripId, String newStatus) {
        Trip__c tripToUpdate = [SELECT Id, Status__c FROM Trip__c WHERE Id = :tripId];
        tripToUpdate.Status__c = newStatus;
        update tripToUpdate;
        System.debug('Statut du voyage mis à jour : ' + tripToUpdate.Id + ' -> ' + newStatus);
    }

    // **Mettre à jour le coût total d'un voyage**
    public static void updateTripCost(Id tripId, Decimal newCost) {
        Trip__c tripToUpdate = [SELECT Id, Total_Cost__c FROM Trip__c WHERE Id = :tripId];
        tripToUpdate.Total_Cost__c = newCost;
        update tripToUpdate;
        System.debug('Coût total du voyage mis à jour : ' + tripToUpdate.Id + ' -> ' + newCost);
    }

    // **Supprimer un voyage**
    public static void deleteTrip(Id tripId) {
        Trip__c tripToDelete = [SELECT Id FROM Trip__c WHERE Id = :tripId];
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
