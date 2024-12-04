@isTest
public class OpportunityServiceTest {

    @isTest
    static void testCRUDOperations() {
        // Étape 1 : Créer un compte pour lier les opportunités
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        System.assertNotEquals(null, acc.Id, 'Le compte aurait dû être créé.');

        // Étape 2 : Créer une opportunité
        Id opportunityId = OpportunityService.createOpportunity(
            'Test Opportunity',
            'Prospecting',         // Stage initial
            Date.today().addDays(30), // Date de clôture
            acc.Id                 // AccountId
        );
        System.assertNotEquals(null, opportunityId, 'L\'opportunité aurait dû être créée.');

        // Étape 3 : Lire l'opportunité
        Opportunity retrievedOpportunity = OpportunityService.getOpportunityByName('Test Opportunity');
        System.assertEquals('Test Opportunity', retrievedOpportunity.Name, 'Le nom de l\'opportunité devrait être "Test Opportunity".');
        System.assertEquals('Prospecting', retrievedOpportunity.StageName, 'Le stage initial devrait être "Prospecting".');

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
    static void testCreateOpportunityWithoutAccount() {
        // Test pour vérifier la gestion d'une opportunité sans compte (doit échouer)
        Test.startTest();
        try {
            OpportunityService.createOpportunity(
                'Invalid Opportunity',
                'Prospecting',
                Date.today().addDays(30),
                null // Pas de compte lié
            );
            System.assert(false, 'La création d\'une opportunité sans compte aurait dû échouer.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'), 'Une exception aurait dû être levée pour un champ manquant.');
        }
        Test.stopTest();
    }
}
