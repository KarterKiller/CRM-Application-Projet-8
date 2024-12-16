@isTest
public class OpportunityValidationTriggerTest {

    @isTest
    static void testValidationOnInsert() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        // Test avec un montant négatif
        Opportunity opp = new Opportunity(
            Name = 'Invalid Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            Amount = -100,
            number_of_Participants__c = 10,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Destination__c = 'Paris'
        );

        try {
            insert opp;
            System.assert(false, 'L\'insertion aurait dû échouer en raison d\'un montant négatif.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.'), 'Message d\'erreur inattendu.');
        }
    }

    @isTest
    static void testValidationOnUpdate() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        // Créer une opportunité valide
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            Amount = 1000,
            number_of_Participants__c = 10,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Destination__c = 'Paris'
        );
        insert opp;

        // Tenter de mettre à jour avec une date de fin antérieure à la date de début
        opp.StartTripDate__c = Date.today().addDays(5);
        opp.EndTripDate__c = Date.today().addDays(3);

        try {
            update opp;
            System.assert(false, 'La mise à jour aurait dû échouer en raison des dates de voyage invalides.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La date de fin du voyage doit être postérieure à la date de début.'), 'Message d\'erreur inattendu.');
        }
    }

    @isTest
    static void testValidationForClosedWon() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        // Créer une opportunité valide
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            Amount = 1000,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Number_of_Participants__c = 10,
            Destination__c = 'Paris'
        );
        insert opp;

        // Passer l'opportunité à l'étape "Closed Won"
        opp.StageName = 'Closed Won';

        try {
            update opp;
            System.assert(true, 'La mise à jour devrait réussir.');
        } catch (DmlException e) {
            System.assert(false, 'Aucune erreur ne devrait être levée pour une opportunité valide.');
        }

        // Test sans montant pour "Closed Won"
        opp.Amount = 0;

        try {
            update opp;
            System.assert(false, 'La mise à jour aurait dû échouer en raison d\'un montant invalide pour "Closed Won".');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.'), 'Message d\'erreur inattendu.');
        }
    }
}
