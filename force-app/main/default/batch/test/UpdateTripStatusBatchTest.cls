@isTest
public class UpdateTripStatusBatchTest {

    @isTest
    static void testBatchExecution() {
        // 1. Création d'un compte via TestDataFactory
        Account testAccount = TestDataFactory.createAccount(true);

        // 2. Création des voyages via TestDataFactory
        List<Trip__c> trips = new List<Trip__c>{
            TestDataFactory.createTrip(testAccount.Id, false),
            TestDataFactory.createTrip(testAccount.Id, false),
            TestDataFactory.createTrip(testAccount.Id, false),
            TestDataFactory.createTrip(testAccount.Id, false)
        };

        // Modification des statuts et dates pour les tests
        trips[0].Name = 'Voyage A venir';
        trips[0].StartTripDate__c = Date.today().addDays(5);
        trips[0].EndTripDate__c = Date.today().addDays(10);
        trips[0].Status__c = 'A venir';
 
        trips[1].Name = 'Voyage En cours';
        trips[1].StartTripDate__c = Date.today().addDays(-2);
        trips[1].EndTripDate__c = Date.today().addDays(3);
        trips[1].Status__c = 'A venir';

        trips[2].Name = 'Voyage Terminé';
        trips[2].StartTripDate__c = Date.today().addDays(-10);
        trips[2].EndTripDate__c = Date.today().addDays(-5);
        trips[2].Status__c = 'A venir';

        trips[3].Name = 'Voyage Annulé';
        trips[3].StartTripDate__c = Date.today().addDays(5);
        trips[3].EndTripDate__c = Date.today().addDays(10);
        trips[3].Status__c = 'Annulé';

        insert trips;

        System.debug('Voyages de test créés.');

        // 3. Exécution du Batch
        Test.startTest();
        Database.executeBatch(new UpdateTripStatusBatch(), 10); // Taille du lot : 10
        Test.stopTest();

        // 4. Vérification des résultats
        List<Trip__c> updatedTrips = [
            SELECT Name, Status__c 
            FROM Trip__c 
            WHERE Status__c != 'Annulé'
        ];

        for (Trip__c trip : updatedTrips) {
            System.debug('Voyage traité : ' + trip.Name + ', Statut : ' + trip.Status__c);

            if (trip.Name == 'Voyage A venir') {
                System.assertEquals('A venir', trip.Status__c, 'Le statut aurait dû être "A venir".');
            } else if (trip.Name == 'Voyage En cours') {
                System.assertEquals('En cours', trip.Status__c, 'Le statut aurait dû être "En cours".');
            } else if (trip.Name == 'Voyage Terminé') {
                System.assertEquals('Terminé', trip.Status__c, 'Le statut aurait dû être "Terminé".');
            }
        }
    }
}
