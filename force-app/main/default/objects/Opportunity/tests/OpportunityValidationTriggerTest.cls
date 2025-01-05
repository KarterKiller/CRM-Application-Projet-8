@isTest
public class OpportunityValidationTriggerTest {

    @isTest
    static void testValidationOnInsert() {
        // Créer un compte valide via TestDataFactory
        Account acc = TestDataFactory.createAccount(true);

        // Créer une opportunité valide mais sans l'insérer
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id, false);

        // Modifie l'opportunité pour un cas de test (montant négatif)
        opp.Amount = -100; // Montant négatif pour provoquer une erreur

        Test.startTest();
        try {
            insert opp;
            System.assertEquals(false, true, 'L\'insertion aurait dû échouer en raison d\'un montant négatif.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnUpdate() {
        // Créer un compte et une opportunité valide via TestDataFactory
        Account acc = TestDataFactory.createAccount(true);
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id, true);

        // Modifie l'opportunité pour un cas de test (dates invalides)
        opp.StartTripDate__c = Date.today().addDays(5);
        opp.EndTripDate__c = Date.today().addDays(3); // Date de fin antérieure à la date de début

        Test.startTest();
        try {
            update opp;
            System.assertEquals(false, true, 'La mise à jour aurait dû échouer en raison des dates de voyage invalides.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('La date de fin du voyage doit être postérieure à la date de début.'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationForClosedWon() {
        // Créer un compte et une opportunité valide via TestDataFactory
        Account acc = TestDataFactory.createAccount(true);

        // **Premier cas** : Opportunité valide qui passe à "Closed Won"
        Opportunity oppValid = TestDataFactory.createOpportunity(acc.Id, true);
        oppValid.StageName = 'Closed Won';

        // **Deuxième cas** : Opportunité avec un montant invalide pour "Closed Won"
        Opportunity oppInvalid = TestDataFactory.createOpportunity(acc.Id, true);
        oppInvalid.StageName = 'Closed Won';
        oppInvalid.Amount = 0; // Montant invalide

        Test.startTest();

        // Premier cas
        try {
            update oppValid;
            System.assertEquals(true, true, 'La mise à jour devrait réussir pour une opportunité valide.');
        } catch (DmlException e) {
            System.assertEquals(false, true, 'Aucune erreur ne devrait être levée pour une opportunité valide.');
        }

        // Deuxième cas
        try {
            update oppInvalid;
            System.assertEquals(false, true, 'La mise à jour aurait dû échouer en raison d\'un montant invalide pour "Closed Won".');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.'), 'Message d\'erreur inattendu.');
        }

        Test.stopTest();
    }
}
