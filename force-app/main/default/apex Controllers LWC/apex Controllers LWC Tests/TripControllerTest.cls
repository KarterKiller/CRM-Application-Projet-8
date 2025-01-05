@isTest
public class TripControllerTest {

    @isTest
    static void testGetTrips() {
        // 1. Préparer les données de test
        // Créer un compte via TestDataFactory
        Account testAccount = TestDataFactory.createAccount(true);

        // Créer deux voyages via TestDataFactory
        Trip__c trip1 = TestDataFactory.createTrip(testAccount.Id, false);
        trip1.Name = 'Test Trip 1';
        trip1.StartTripDate__c = Date.today();
        trip1.EndTripDate__c = Date.today().addDays(5);
        trip1.Number_of_Participants__c = 15;
        trip1.Destination__c = 'Paris';
        trip1.Status__c = 'A venir';

        Trip__c trip2 = TestDataFactory.createTrip(testAccount.Id, false);
        trip2.Name = 'Test Trip 2';
        trip2.StartTripDate__c = Date.today().addDays(10);
        trip2.EndTripDate__c = Date.today().addDays(15);
        trip2.Number_of_Participants__c = 20;
        trip2.Destination__c = 'Rome';
        trip2.Status__c = 'A venir';

        // Insérer les voyages
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
