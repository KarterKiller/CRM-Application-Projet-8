@isTest
private class TripServiceTest {

    @isTest
    static void testCreateTrip() {
        // Créer un compte de test
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Créer un voyage avec les nouvelles dates du voyage
        Id tripId = TripService.createTrip('Test Trip', Date.today(), Date.today().addDays(7), 'A venir', 1000, testAccount.Id);
        
        // Vérifier que le voyage a bien été créé
        Trip__c createdTrip = [SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c FROM Trip__c WHERE Id = :tripId];
        System.assertNotEquals(null, createdTrip);
        System.assertEquals('Test Trip', createdTrip.Name);
        System.assertEquals('A venir', createdTrip.Status__c);
    }

    @isTest
    static void testUpdateTripStatus() {
        // Créer un compte de test
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Créer un voyage avec les nouvelles dates du voyage
        Trip__c newTrip = new Trip__c(Name='Test Trip', Account__c=testAccount.Id, StartTripDate__c=Date.today(), EndTripDate__c=Date.today().addDays(7), Status__c='A venir');
        insert newTrip;

        // Mettre à jour le statut du voyage
        TripService.updateTripStatus(newTrip.Id, 'En cours');
        
        // Récupérer le voyage mis à jour et vérifier le statut
        newTrip = [SELECT Status__c FROM Trip__c WHERE Id = :newTrip.Id];
        System.assertEquals('En cours', newTrip.Status__c);
    }

    @isTest
    static void testUpdateTripCost() {
        // Créer un compte de test
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Créer un voyage avec les nouvelles dates du voyage
        Trip__c newTrip = new Trip__c(Name='Test Trip', Account__c=testAccount.Id, StartTripDate__c=Date.today(), EndTripDate__c=Date.today().addDays(7), Total_Cost__c=1000);
        insert newTrip;

        // Mettre à jour le coût du voyage
        TripService.updateTripCost(newTrip.Id, 1500);
        
        // Vérifier que le coût a bien été mis à jour
        newTrip = [SELECT Total_Cost__c FROM Trip__c WHERE Id = :newTrip.Id];
        System.assertEquals(1500, newTrip.Total_Cost__c);
    }

    @isTest
    static void testDeleteTrip() {
        // Créer un compte de test
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Créer un voyage pour le compte
        Trip__c newTrip = new Trip__c(Name='Test Trip', Account__c=testAccount.Id, StartTripDate__c=Date.today(), EndTripDate__c=Date.today().addDays(7));
        insert newTrip;

        // Vérifier que le voyage existe avant de le supprimer
        Trip__c tripBeforeDelete = [SELECT Id FROM Trip__c WHERE Id = :newTrip.Id LIMIT 1];
        System.assertNotEquals(null, tripBeforeDelete, 'Le voyage devrait exister avant la suppression.');

        // Supprimer le voyage
        TripService.deleteTrip(newTrip.Id);

        // Vérifier que le voyage a bien été supprimé (en vérifiant qu'il n'existe plus)
        try {
            Trip__c tripAfterDelete = [SELECT Id FROM Trip__c WHERE Id = :newTrip.Id LIMIT 1];
            System.assert(false, 'L\'exception attendue : Aucun voyage trouvé après la suppression.');
        } catch (QueryException e) {
            System.debug('Erreur attendue, le voyage a bien été supprimé.');
            // S'assurer que l'exception QueryException est bien levée
        }
    }

    @isTest
    static void testDeleteTripsByAccountId() {
        // Créer un compte de test
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Créer plusieurs voyages pour le même compte
        List<Trip__c> tripsToCreate = new List<Trip__c>();
        for (Integer i = 0; i < 5; i++) {
            tripsToCreate.add(new Trip__c(
                Name = 'Test Trip ' + i, 
                Account__c = testAccount.Id, 
                StartTripDate__c = Date.today(), 
                EndTripDate__c = Date.today().addDays(7)
            ));
        }
        insert tripsToCreate;

        // Vérifier qu'il y a bien 5 voyages pour le compte
        List<Trip__c> tripsBeforeDelete = [SELECT Id FROM Trip__c WHERE Account__c = :testAccount.Id];
        System.assertEquals(5, tripsBeforeDelete.size());

        // Supprimer tous les voyages associés au compte
        TripService.deleteTripsByAccountId(testAccount.Id);

        // Vérifier qu'il n'y a plus de voyages associés à ce compte
        List<Trip__c> tripsAfterDelete = [SELECT Id FROM Trip__c WHERE Account__c = :testAccount.Id];
        System.assertEquals(0, tripsAfterDelete.size());
    }

    @isTest
    static void testValidationCreateTripInvalidDates() {
        // Tester la création d'un voyage avec des dates invalides
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        try {
            TripService.createTrip('Test Trip', Date.today(), Date.today().addDays(-1), 'A venir', 1000, testAccount.Id);
            System.assert(false, 'Exception attendue : La date de fin doit être postérieure à la date de début');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Les dates du voyage doivent être valides.', e.getMessage());
        }
    }

    @isTest
    static void testUpdateTripCostInvalidValue() {
        // Tester la mise à jour du coût avec une valeur invalide (négative)
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Trip__c newTrip = new Trip__c(Name='Test Trip', Account__c=testAccount.Id, StartTripDate__c=Date.today(), EndTripDate__c=Date.today().addDays(7), Total_Cost__c=1000);
        insert newTrip;

        try {
            TripService.updateTripCost(newTrip.Id, -500);
            System.assert(false, 'Exception attendue : Le coût total ne peut pas être négatif.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Le coût total ne peut pas être négatif.', e.getMessage());
        }
    }
}
