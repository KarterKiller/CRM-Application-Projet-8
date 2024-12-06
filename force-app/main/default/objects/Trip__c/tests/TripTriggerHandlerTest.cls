@isTest
public class TripTriggerHandlerTest {
    @isTest
    static void testValidateDates() {
        // Cas 1 : Insérer un voyage avec des dates cohérentes
        Trip__c validTrip = new Trip__c(
            Name = 'Voyage valide',
            StartTripDate__c = Date.today(),  // Mise à jour avec StartTripDate__c
            EndTripDate__c = Date.today().addDays(5)  // Mise à jour avec EndTripDate__c
        );
        insert validTrip;

        // Vérifier que le voyage valide a été inséré
        Trip__c insertedTrip = [SELECT Id, StartTripDate__c, EndTripDate__c FROM Trip__c WHERE Id = :validTrip.Id];
        System.assertEquals(validTrip.StartTripDate__c, insertedTrip.StartTripDate__c);

        // Cas 2 : Insérer un voyage avec une date de fin antérieure à la date de début
        Trip__c invalidTrip = new Trip__c(
            Name = 'Voyage invalide',
            StartTripDate__c = Date.today(),  // Mise à jour avec StartTripDate__c
            EndTripDate__c = Date.today().addDays(-5)  // Mise à jour avec EndTripDate__c
        );

        // Vérifier que l'insertion échoue
        try {
            insert invalidTrip;
            System.assert(false, 'Un voyage avec des dates invalides aurait dû générer une erreur.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La date de fin du voyage doit être postérieure à la date de début.'));
        }

        // Cas 3 : Mise à jour avec des dates invalides
        validTrip.EndTripDate__c = Date.today().addDays(-1);  // Mise à jour avec EndTripDate__c
        try {
            update validTrip;
            System.assert(false, 'Une mise à jour avec des dates invalides aurait dû générer une erreur.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La date de fin du voyage doit être postérieure à la date de début.'));
        }
    }
}
