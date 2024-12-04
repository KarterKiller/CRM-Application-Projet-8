@isTest
public class TripServiceTest {

    @isTest
    static void testCRUDOperations() {
        // Créer un compte pour lier les voyages
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer un voyage
        Id tripId = TripService.createTrip(
            'Test Voyage',
            Date.today().addDays(10),
            Date.today().addDays(15),
            'A venir',
            3000.00,
            acc.Id
        );
        System.assertNotEquals(null, tripId, 'Le voyage aurait dû être créé.');

        // Lire le voyage
        Trip__c retrievedTrip = TripService.getTripById(tripId);
        System.assertEquals('A venir', retrievedTrip.Status__c, 'Le statut initial devrait être "A venir".');

        // Mettre à jour le statut
        TripService.updateTripStatus(tripId, 'Terminé');
        retrievedTrip = TripService.getTripById(tripId);
        System.assertEquals('Terminé', retrievedTrip.Status__c, 'Le statut devrait être "Terminé".');

        // Supprimer le voyage
        TripService.deleteTrip(tripId);
        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Id = :tripId];
        System.assertEquals(0, trips.size(), 'Le voyage aurait dû être supprimé.');
    }
}
