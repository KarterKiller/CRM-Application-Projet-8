@isTest
private class TripServiceTest {

    @isTest
    static void testCreateTrip() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer un voyage avec des données valides
        Id tripId = TripService.createTrip(
            'Test Trip',
            Date.today(),
            Date.today().addDays(7),
            'A venir',
            1000,
            testAccount.Id
        );

        // Vérifier que le voyage a été créé
        Trip__c createdTrip = [SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c, Total_Cost__c FROM Trip__c WHERE Id = :tripId];
        System.assertNotEquals(null, createdTrip, 'Le voyage aurait dû être créé.');
        System.assertEquals('Test Trip', createdTrip.Name, 'Le nom du voyage est incorrect.');
        System.assertEquals('A venir', createdTrip.Status__c, 'Le statut du voyage est incorrect.');
        System.assertEquals(1000, createdTrip.Total_Cost__c, 'Le coût total du voyage est incorrect.');
    }

    @isTest
    static void testUpdateTripStatus() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer un voyage
        Trip__c trip = new Trip__c(
            Name = 'Test Trip',
            Account__c = testAccount.Id,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Status__c = 'A venir'
        );
        insert trip;

        // Mettre à jour le statut
        TripService.updateTripStatus(trip.Id, 'En cours');

        // Vérifier la mise à jour
        Trip__c updatedTrip = [SELECT Status__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals('En cours', updatedTrip.Status__c, 'Le statut du voyage n\'a pas été mis à jour correctement.');
    }

    @isTest
    static void testUpdateTripCost() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer un voyage
        Trip__c trip = new Trip__c(
            Name = 'Test Trip',
            Account__c = testAccount.Id,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Total_Cost__c = 1000
        );
        insert trip;

        // Mettre à jour le coût
        TripService.updateTripCost(trip.Id, 1500);

        // Vérifier la mise à jour
        Trip__c updatedTrip = [SELECT Total_Cost__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(1500, updatedTrip.Total_Cost__c, 'Le coût total du voyage n\'a pas été mis à jour correctement.');
    }

    @isTest
    static void testDeleteTrip() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer un voyage
        Trip__c trip = new Trip__c(
            Name = 'Test Trip',
            Account__c = testAccount.Id,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7)
        );
        insert trip;

        // Supprimer le voyage
        TripService.deleteTrip(trip.Id);

        // Vérifier que le voyage a été supprimé
        List<Trip__c> tripsAfterDelete = [SELECT Id FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(0, tripsAfterDelete.size(), 'Le voyage aurait dû être supprimé.');
    }

    @isTest
    static void testDeleteTripsByAccountId() {
        // Créer un compte
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer plusieurs voyages
        List<Trip__c> trips = new List<Trip__c>();
        for (Integer i = 0; i < 3; i++) {
            trips.add(new Trip__c(
                Name = 'Trip ' + i,
                Account__c = testAccount.Id,
                StartTripDate__c = Date.today(),
                EndTripDate__c = Date.today().addDays(7)
            ));
        }
        insert trips;

        // Supprimer tous les voyages
        TripService.deleteTripsByAccountId(testAccount.Id);

        // Vérifier la suppression
        List<Trip__c> remainingTrips = [SELECT Id FROM Trip__c WHERE Account__c = :testAccount.Id];
        System.assertEquals(0, remainingTrips.size(), 'Tous les voyages devraient être supprimés.');
    }

    @isTest
    static void testValidationCreateTripInvalidDates() {
        // Créer un compte
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer un voyage avec des dates invalides
        try {
            TripService.createTrip('Invalid Trip', Date.today(), Date.today().addDays(-1), 'A venir', 1000, testAccount.Id);
            System.assert(false, 'La création aurait dû échouer en raison de dates invalides.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Les dates du voyage doivent être valides et la date de fin doit être postérieure à la date de début.', e.getMessage(), 'Le message d\'erreur est incorrect.');
        }
    }

    @isTest
    static void testValidationCreateTripNegativeCost() {
        // Créer un compte
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Créer un voyage avec un coût négatif
        try {
            TripService.createTrip('Negative Cost Trip', Date.today(), Date.today().addDays(7), 'A venir', -500, testAccount.Id);
            System.assert(false, 'La création aurait dû échouer en raison d\'un coût négatif.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Le coût total ne peut pas être négatif.', e.getMessage(), 'Le message d\'erreur est incorrect.');
        }
    }
}
