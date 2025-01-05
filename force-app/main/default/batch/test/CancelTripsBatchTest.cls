@isTest
public class CancelTripsBatchTest {

    @isTest
    static void testBatchExecution() {
        // Créer un compte via TestDataFactory
        Account testAccount = TestDataFactory.createAccount(true);

        // Créer des voyages via TestDataFactory
        List<Trip__c> trips = new List<Trip__c>{
            TestDataFactory.createTrip(testAccount.Id, false), // Voyage avec participants < 10
            TestDataFactory.createTrip(testAccount.Id, false), // Voyage avec participants >= 10
            TestDataFactory.createTrip(testAccount.Id, false)  // Voyage avec participants null
        };

        // Modifier les données des voyages pour couvrir tous les cas
        trips[0].Number_of_Participants__c = 5; // Annulation attendue
        trips[1].Number_of_Participants__c = 15; // Pas d'annulation
        trips[2].Number_of_Participants__c = null; // Pas d'annulation

        insert trips;

        // Exécuter le Batch
        Test.startTest();
        Database.executeBatch(new CancelTripsBatch(), 10); // Taille du lot : 10
        Test.stopTest();

        // Vérifier les résultats
        List<Trip__c> updatedTrips = [SELECT Id, Status__c, Number_of_Participants__c FROM Trip__c WHERE Id IN :trips];
        for (Trip__c trip : updatedTrips) {
            if (trip.Number_of_Participants__c != null && trip.Number_of_Participants__c < 10) {
                System.assertEquals('Annulé', trip.Status__c, 'Le voyage aurait dû être annulé.');
            } else {
                System.assertNotEquals('Annulé', trip.Status__c, 'Le voyage ne devrait pas être annulé.');
            }
        }
    }
}
