@isTest
public class UpdateTripStatusBatchTest {

    @isTest
    static void testBatchExecution() {
        // Créer des voyages de test
        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(Name = 'Voyage A venir', Start_Date__c = Date.today().addDays(5), End_Date__c = Date.today().addDays(10), Status__c = 'A venir'),
            new Trip__c(Name = 'Voyage En cours', Start_Date__c = Date.today().addDays(-2), End_Date__c = Date.today().addDays(3), Status__c = 'A venir'),
            new Trip__c(Name = 'Voyage Terminé', Start_Date__c = Date.today().addDays(-10), End_Date__c = Date.today().addDays(-5), Status__c = 'A venir'),
            new Trip__c(Name = 'Voyage Annulé', Start_Date__c = Date.today().addDays(5), End_Date__c = Date.today().addDays(10), Status__c = 'Annulé')
        };
        insert trips;

        System.debug('Voyages de test créés.');

        // Exécuter le Batch
        Test.startTest();
        Database.executeBatch(new UpdateTripStatusBatch(), 10); // Taille du lot : 10
        Test.stopTest();

        // Vérifier les résultats
        List<Trip__c> updatedTrips = [SELECT Name, Status__c FROM Trip__c WHERE Status__c != 'Annulé'];
        for (Trip__c trip : updatedTrips) {
            System.debug('Voyage traité : ' + trip.Name + ', Statut : ' + trip.Status__c);

            if (trip.Name == 'Voyage A venir') {
                System.assertEquals('A venir', trip.Status__c);
            } else if (trip.Name == 'Voyage En cours') {
                System.assertEquals('En cours', trip.Status__c);
            } else if (trip.Name == 'Voyage Terminé') {
                System.assertEquals('Terminé', trip.Status__c);
            }
        }
    }
}
