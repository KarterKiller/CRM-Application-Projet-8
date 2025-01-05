@isTest
public class TripValidationTriggerTest {

    @isTest
    static void testValidationOnInsertNameEmpty() {
        // Créer un compte valide
        Account acc = TestDataFactory.createAccount(true);

        // Test pour un nom vide
        Trip__c trip = TestDataFactory.createTrip(acc.Id, false);
        trip.Name = ''; // Nom vide pour déclencher une erreur

        Test.startTest();
        try {
            insert trip;
            System.assertEquals(false, true, 'L\'insertion aurait dû échouer en raison d\'un nom vide.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le nom du voyage est obligatoire.'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertDatesInvalid() {
        // Créer un compte valide
        Account acc = TestDataFactory.createAccount(true);

        // Test pour des dates invalides
        Trip__c trip = TestDataFactory.createTrip(acc.Id, false);
        trip.StartTripDate__c = Date.today();
        trip.EndTripDate__c = Date.today().addDays(-1); // Date de fin avant la date de début

        Test.startTest();
        try {
            insert trip;
            System.assertEquals(false, true, 'L\'insertion aurait dû échouer en raison de dates invalides.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('La date de fin doit être postérieure à la date de début.'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertCostNegative() {
        // Créer un compte valide
        Account acc = TestDataFactory.createAccount(true);

        // Test pour un coût négatif
        Trip__c trip = TestDataFactory.createTrip(acc.Id, false);
        trip.Total_Cost__c = -500; // Coût négatif

        Test.startTest();
        try {
            insert trip;
            System.assertEquals(false, true, 'L\'insertion aurait dû échouer en raison d\'un coût total négatif.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le coût total ne peut pas être négatif.'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testSuccessfulInsert() {
        // Créer un compte valide
        Account acc = TestDataFactory.createAccount(true);

        // Créer un voyage valide
        Trip__c trip = TestDataFactory.createTrip(acc.Id, false);
        trip.Name = 'Valid Trip'; // Nom valide
        trip.Total_Cost__c = 5000; // Coût valide
        trip.Status__c = 'A venir'; // Statut valide

        // Insérer le voyage
        Test.startTest();
        try {
            insert trip;
            System.assertEquals(true, trip.Id != null, 'Le voyage aurait dû être inséré.');
        } catch (DmlException e) {
            System.assertEquals(false, true, 'Une erreur inattendue a été levée lors de l\'insertion : ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testSuccessfulUpdate() {
        // Créer un compte valide
        Account acc = TestDataFactory.createAccount(true);

        // Créer et insérer un voyage valide
        Trip__c trip = TestDataFactory.createTrip(acc.Id, true); // Le voyage est inséré directement

        // Mettre à jour le statut
        trip.Status__c = 'Annulé';
        Test.startTest();
        try {
            update trip;
            Trip__c updatedTrip = [SELECT Status__c FROM Trip__c WHERE Id = :trip.Id];
            System.assertEquals('Annulé', updatedTrip.Status__c, 'Le statut du voyage aurait dû être mis à jour.');
        } catch (DmlException e) {
            System.assertEquals(false, true, 'Une erreur inattendue a été levée lors de la mise à jour : ' + e.getMessage());
        }
        Test.stopTest();
    }
}
