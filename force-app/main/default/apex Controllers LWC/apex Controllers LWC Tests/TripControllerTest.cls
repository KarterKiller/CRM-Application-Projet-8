@isTest
public class TripControllerTest {

    @isTest
    static void testGetTrips() {
        // 1. Préparer les données de test
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        insert testAccount;

        Trip__c trip1 = new Trip__c(
            Name = 'Test Trip 1',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(5),
            Number_of_Participants__c = 15,
            Destination__c = 'Paris',
            Status__c = 'A venir',
            Account__c = testAccount.Id
        );

        Trip__c trip2 = new Trip__c(
            Name = 'Test Trip 2',
            StartTripDate__c = Date.today().addDays(10),
            EndTripDate__c = Date.today().addDays(15),
            Number_of_Participants__c = 20,
            Destination__c = 'Rome',
            Status__c = 'A venir',
            Account__c = testAccount.Id
        );

        insert new List<Trip__c>{ trip1, trip2 };

        // 2. Appeler la méthode à tester
        Test.startTest();
        List<Trip__c> trips = TripController.getTrips();
        Test.stopTest();

        // 3. Vérifications
        System.assertNotEquals(0, trips.size(), 'La liste des voyages ne devrait pas être vide.');
        System.assertEquals(2, trips.size(), 'Le nombre de voyages récupérés devrait être 2.');
        System.assertEquals('Test Trip 1', trips[0].Name, 'Le premier voyage récupéré devrait être "Test Trip 1".');
        System.assertEquals('Test Account', trips[0].Account__r.Name, 'Le nom du compte associé devrait être "Test Account".');
    }
}
