@isTest
public class CancelTripsBatchTest {

    // Méthode utilitaire pour créer un compte de test
    private static Account createTestAccount() {
        Account acc = new Account(
            Name = 'Test Account',
            Industry = 'Technology'
        );
        insert acc;
        return acc;
    }

    @isTest
    static void testBatchExecution() {
        // Créer un compte de test requis pour les voyages
        Account testAccount = createTestAccount();

        // Créer des voyages de test associés au compte
        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(Name = 'Voyage 1', StartTripDate__c = Date.today().addDays(7), EndTripDate__c = Date.today().addDays(9), 
                        Number_of_Participants__c = 5, Status__c = 'A venir', Account__c = testAccount.Id),
            new Trip__c(Name = 'Voyage 2', StartTripDate__c = Date.today().addDays(7), EndTripDate__c = Date.today().addDays(9), 
                        Number_of_Participants__c = 15, Status__c = 'A venir', Account__c = testAccount.Id),
            new Trip__c(Name = 'Voyage 3', StartTripDate__c = Date.today().addDays(7), EndTripDate__c = Date.today().addDays(9), 
                        Number_of_Participants__c = null, Status__c = 'A venir', Account__c = testAccount.Id)
        };
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
