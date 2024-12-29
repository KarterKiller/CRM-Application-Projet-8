@isTest
public class UpdateTripStatusBatchTest {

    @isTest
    static void testBatchExecution() {
        // 1. Création d'un compte de test (obligatoire pour les Trips)
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        insert testAccount;

        // 2. Préparation des données de test
        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(
                Name = 'Voyage A venir',
                StartTripDate__c = Date.today().addDays(5),
                EndTripDate__c = Date.today().addDays(10),
                Status__c = 'A venir',
                Account__c = testAccount.Id
            ),
            new Trip__c(
                Name = 'Voyage En cours',
                StartTripDate__c = Date.today().addDays(-2),
                EndTripDate__c = Date.today().addDays(3),
                Status__c = 'A venir',
                Account__c = testAccount.Id
            ),
            new Trip__c(
                Name = 'Voyage Terminé',
                StartTripDate__c = Date.today().addDays(-10),
                EndTripDate__c = Date.today().addDays(-5),
                Status__c = 'A venir',
                Account__c = testAccount.Id
            ),
            new Trip__c(
                Name = 'Voyage Annulé',
                StartTripDate__c = Date.today().addDays(5),
                EndTripDate__c = Date.today().addDays(10),
                Status__c = 'Annulé',
                Account__c = testAccount.Id
            )
        };
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
