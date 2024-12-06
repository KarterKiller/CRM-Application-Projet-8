@isTest
public class OpportunityServiceTest {

    @isTest
    static void testCRUDOperations() {
        // Étape 1 : Créer un compte pour lier les opportunités
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        System.assertNotEquals(null, acc.Id, 'Le compte aurait dû être créé.');

        // Étape 2 : Créer une opportunité avec les dates Start et End du voyage
        Id opportunityId = OpportunityService.createOpportunity(
            'Test Opportunity',
            'Prospecting',         // Stage initial
            Date.today().addDays(30), // Date de clôture
            acc.Id,                 // AccountId
            Date.today().addDays(5),  // Date de début du voyage
            Date.today().addDays(10)  // Date de fin du voyage
        );
        System.assertNotEquals(null, opportunityId, 'L\'opportunité aurait dû être créée.');

        // Étape 3 : Lire l'opportunité
        Opportunity retrievedOpportunity = OpportunityService.getOpportunityByName('Test Opportunity');
        System.assertEquals('Test Opportunity', retrievedOpportunity.Name, 'Le nom de l\'opportunité devrait être "Test Opportunity".');
        System.assertEquals('Prospecting', retrievedOpportunity.StageName, 'Le stage initial devrait être "Prospecting".');

        // Vérifier que les dates Start et End sont bien présentes
        System.assertNotEquals(null, retrievedOpportunity.StartTripDate__c, 'La date de début du voyage ne devrait pas être vide.');
        System.assertNotEquals(null, retrievedOpportunity.EndTripDate__c, 'La date de fin du voyage ne devrait pas être vide.');

        // Étape 4 : Mettre à jour le stage de l'opportunité
        OpportunityService.updateOpportunityStage(opportunityId, 'Closed Won');
        retrievedOpportunity = OpportunityService.getOpportunityByName('Test Opportunity');
        System.assertEquals('Closed Won', retrievedOpportunity.StageName, 'Le stage devrait être "Closed Won".');

        // Étape 5 : Supprimer l'opportunité
        OpportunityService.deleteOpportunity(opportunityId);
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Id = :opportunityId];
        System.assertEquals(0, opportunities.size(), 'L\'opportunité aurait dû être supprimée.');
    }



    @isTest
    static void testCreateOpportunityWithStage() {
        // Étape 1 : Créer un compte pour lier l'opportunité
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Étape 2 : Créer une opportunité avec un stage spécifique
        Opportunity newOpp = new Opportunity(
            Name = 'Test Opportunity with Stage',
            StageName = 'Qualification', // Stage spécifique
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );
        insert newOpp;

        // Vérifier que l'opportunité a bien été créée avec le stage spécifié
        Opportunity retrievedOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :newOpp.Id];
        System.assertEquals('Qualification', retrievedOpp.StageName, 'Le stage de l\'opportunité devrait être "Qualification".');
    }

    @isTest
    static void testDeleteOpportunity() {
        // Étape 1 : Créer un compte pour lier l'opportunité
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Étape 2 : Créer une opportunité
        Opportunity newOpp = new Opportunity(
            Name = 'Test Opportunity for Deletion',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id
        );
        insert newOpp;

        // Vérifier que l'opportunité a été insérée
        Opportunity retrievedOpp = [SELECT Id FROM Opportunity WHERE Id = :newOpp.Id];
        System.assertNotEquals(null, retrievedOpp, 'L\'opportunité aurait dû être insérée.');

        // Étape 3 : Supprimer l'opportunité
        OpportunityService.deleteOpportunity(newOpp.Id);

        // Vérifier que l'opportunité a été supprimée
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Id = :newOpp.Id];
        System.assertEquals(0, opportunities.size(), 'L\'opportunité aurait dû être supprimée.');
    }
}
