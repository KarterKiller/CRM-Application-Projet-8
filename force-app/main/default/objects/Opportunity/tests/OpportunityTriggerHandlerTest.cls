@isTest
public class OpportunityTriggerHandlerTest {

    // Méthode utilitaire pour créer un compte de test
    private static Account createTestAccount() {
        Account acc = new Account(
            Name = 'Test Account',
            Industry = 'Technology',
            Active__c = 'Yes',
            Phone = '0123456789'
        );
        insert acc;
        return acc;
    }

    @isTest
    static void testValidateOpportunity_ValidOpportunity() {
        Account acc = createTestAccount();

        Opportunity opp = new Opportunity(
            Name = 'Valid Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            Amount = 1000,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(5),
            Number_of_Participants__c = 10,
            Destination__c = 'Paris'
        );

        Test.startTest();
        insert opp;
        Test.stopTest();

        System.assertEquals(true, opp.Id != null, 'L\'opportunité valide aurait dû être insérée.');
    }

    @isTest
    static void testValidateOpportunity_InvalidOpportunity() {
        Account acc = createTestAccount();

        Opportunity opp = new Opportunity(
            Name = 'Test', // Nom manquant
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            Amount = -500, // Montant négatif
            StartTripDate__c = Date.today().addDays(5),
            EndTripDate__c = Date.today().addDays(9), 
            Number_of_Participants__c = 5, // Participants invalides
            Destination__c = 'Paris' 
        );

        Test.startTest();
        try {
            insert opp;
            System.assertEquals(false, true, 'Une exception aurait dû être levée pour une opportunité invalide.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.'), 'Le message d\'erreur est incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateTripAndContractForClosedWon() {
        Account acc = createTestAccount();

        // Créer une opportunité initiale
        Opportunity opp = new Opportunity(
            Name = 'Opportunity Closed Won',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id,
            Amount = 1000,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(5),
            Number_of_Participants__c = 10,
            Destination__c = 'Paris'
        );
        insert opp;

        // Mettre l'opportunité à "Closed Won"
        opp.StageName = 'Closed Won';
        Test.startTest();
        update opp;
        Test.stopTest();

        // Vérifier qu'un voyage et un contrat ont été créés
        List<Trip__c> trips = [SELECT Id, Name, Status__c FROM Trip__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(1, trips.size(), 'Un voyage aurait dû être créé.');
        System.assertEquals('A venir', trips[0].Status__c, 'Le statut du voyage aurait dû être "A venir".');

        List<Contract> contracts = [SELECT Id, Name, Status FROM Contract WHERE Opportunity__c = :opp.Id];
        System.assertEquals(1, contracts.size(), 'Un contrat aurait dû être créé.');
        System.assertEquals('Draft', contracts[0].Status, 'Le statut du contrat aurait dû être "Draft".');
    }
}
