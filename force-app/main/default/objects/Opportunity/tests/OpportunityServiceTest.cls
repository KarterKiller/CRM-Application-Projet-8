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
            Date.today().addDays(10),
            5000
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

    @isTest
    static void testOpportunityCrudOperations() {
        // Créer un compte pour associer aux opportunités
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Test.startTest();
        try {
            // Test CREATE
            Id opportunityId = OpportunityService.createOpportunity(
                'Test Opportunity',
                'Prospecting',
                Date.today().addDays(30),
                testAccount.Id,
                Date.today().addDays(10), // StartTripDate
                Date.today().addDays(20),
                5000
            );
            System.assertNotEquals(null, opportunityId, 'L\'opportunité aurait dû être créée.');

            // Test READ
            Opportunity retrievedOpportunity = OpportunityService.getOpportunityByName('Test Opportunity');
            System.assertNotEquals(null, retrievedOpportunity, 'L\'opportunité aurait dû être trouvée.');
            System.assertEquals('Test Opportunity', retrievedOpportunity.Name, 'Le nom de l\'opportunité ne correspond pas.');
            System.assertEquals('Prospecting', retrievedOpportunity.StageName, 'Le stage de l\'opportunité ne correspond pas.');

            // Test UPDATE
            OpportunityService.updateOpportunityStage(opportunityId, 'Closed Won');
            Opportunity updatedOpportunity = [SELECT StageName FROM Opportunity WHERE Id = :opportunityId];
            System.assertEquals('Closed Won', updatedOpportunity.StageName, 'Le stage de l\'opportunité aurait dû être mis à jour.');

            // Test DELETE
            OpportunityService.deleteOpportunity(opportunityId);
            Integer opportunityCount = [SELECT COUNT() FROM Opportunity WHERE Id = :opportunityId];
            System.assertEquals(0, opportunityCount, 'L\'opportunité aurait dû être supprimée.');
        } catch (Exception e) {
            System.assert(false, 'Une exception inattendue a été levée : ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testOpportunityCrudPermissionFailure() {
        Test.startTest();
        try {
            // Simuler un utilisateur sans autorisation CRUD (en utilisant System.runAs)
            User basicUser = createBasicUser();
            System.runAs(basicUser) {
                OpportunityService.createOpportunity(
                    'Test Opportunity',
                    'Prospecting',
                    Date.today().addDays(30),
                    null, // Pas de compte pour simuler une erreur
                    Date.today().addDays(10), // StartTripDate
                    Date.today().addDays(20),
                    5000
                );
            }
            System.assert(false, 'Une exception CRUD aurait dû être levée.');
        } catch (SecurityException e) {
            System.assert(e.getMessage().contains('Permission denied'), 'Une exception de permission CRUD aurait dû être levée.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Impossible de créer une opportunité sans compte'), 'Une exception pour champ manquant aurait dû être levée.');
        }
        Test.stopTest();
    }

    // Méthode auxiliaire pour créer un utilisateur basique
    private static User createBasicUser() {
        Profile basicProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User basicUser = new User(
            Username = 'basicuser@test.com',
            Alias = 'basic',
            Email = 'basicuser@test.com',
            ProfileId = basicProfile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LastName = 'User',
            CommunityNickname = 'basicuser',
            IsActive = true
        );
        insert basicUser;
        return basicUser;
    }

    @isTest
    static void testCreateOpportunity_ValidData() {
        // Créer un compte de test
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        // Créer une opportunité avec des données valides
        Id oppId = OpportunityService.createOpportunity(
            'Test Opportunity',
            'Prospecting',
            Date.today().addDays(10),
            acc.Id,
            Date.today().addDays(5),
            Date.today().addDays(7),
            5000
        );
        Test.stopTest();

        // Vérifier que l'opportunité a été créée
        Opportunity opp = [SELECT Id, Name, StageName, CloseDate, StartTripDate__c, EndTripDate__c
                           FROM Opportunity WHERE Id = :oppId];
        System.assertEquals('Test Opportunity', opp.Name, 'Le nom de l\'opportunité est incorrect.');
        System.assertEquals('Prospecting', opp.StageName, 'Le stage de l\'opportunité est incorrect.');
        System.assertNotEquals(null, opp.StartTripDate__c, 'La date de début du voyage devrait être définie.');
        System.assertNotEquals(null, opp.EndTripDate__c, 'La date de fin du voyage devrait être définie.');
    }

    @isTest
    static void testCreateOpportunity_InvalidCloseDate() {
        // Créer un compte de test
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        try {
            // Créer une opportunité avec une date de clôture passée
            OpportunityService.createOpportunity(
                'Test Opportunity',
                'Prospecting',
                Date.today().addDays(-1), // Date de clôture invalide
                acc.Id,
                Date.today().addDays(5),
                Date.today().addDays(7),
                5000
            );
            System.assert(false, 'Une exception aurait dû être levée pour une date de clôture invalide.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('La date de clôture doit être une date future.'), 
                          'Le message d\'erreur attendu est incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateOpportunity_InvalidTripDates() {
        // Créer un compte de test
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        try {
            // Créer une opportunité avec des dates de voyage invalides
            OpportunityService.createOpportunity(
                'Test Opportunity',
                'Prospecting',
                Date.today().addDays(10),
                acc.Id,
                Date.today().addDays(7),  // Date de début
                Date.today().addDays(5),   // Date de fin antérieure à la date de début
                5000
            );
            System.assert(false, 'Une exception aurait dû être levée pour des dates de voyage invalides.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('La date de fin du voyage doit être postérieure à la date de début.'), 
                          'Le message d\'erreur attendu est incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateOpportunityStage() {
        // Créer un compte et une opportunité de test
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            StartTripDate__c = Date.today().addDays(5),
            EndTripDate__c = Date.today().addDays(10),
            CloseDate = Date.today().addDays(10),
            AccountId = acc.Id
        );
        insert opp;

        Test.startTest();
        // Mettre à jour le stage
        OpportunityService.updateOpportunityStage(opp.Id, 'Closed Won');
        Test.stopTest();

        // Vérifier que le stage a été mis à jour
        Opportunity updatedOpp = [SELECT StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Closed Won', updatedOpp.StageName, 'Le stage de l\'opportunité n\'a pas été mis à jour.');

    }

    @isTest
static void testOpportunityAmountValidation() {
    // Créer un compte pour lier les opportunités
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;

    // Cas 1 : Créer une opportunité avec un montant valide
    Test.startTest();
    try {
        Id oppId = OpportunityService.createOpportunity(
            'Valid Opportunity',
            'Prospecting',
            Date.today().addDays(30), // Date de clôture valide
            testAccount.Id,
            Date.today().addDays(10), // Date de début du voyage
            Date.today().addDays(20), // Date de fin du voyage
            5000 // Montant valide
        );

        // Vérifier que l'opportunité a été créée avec succès
        Opportunity createdOpp = [SELECT Id, Name, Amount FROM Opportunity WHERE Id = :oppId];
        System.assertNotEquals(null, createdOpp, 'L\'opportunité aurait dû être créée.');
        System.assertEquals(5000, createdOpp.Amount, 'Le montant de l\'opportunité doit être 5000.');
    } catch (Exception e) {
        System.assert(false, 'Aucune exception ne devrait être levée pour un montant valide : ' + e.getMessage());
    }
    

    // Cas 2 : Créer une opportunité avec un montant négatif
    
    try {
        OpportunityService.createOpportunity(
            'Invalid Opportunity',
            'Prospecting',
            Date.today().addDays(30), // Date de clôture valide
            testAccount.Id,
            Date.today().addDays(10), // Date de début du voyage
            Date.today().addDays(20), // Date de fin du voyage
            -5000 // Montant négatif
        );
        System.assert(false, 'La création d\'une opportunité avec un montant négatif aurait dû échouer.');
    } catch (IllegalArgumentException e) {
        System.assert(e.getMessage().contains('Le montant de l\'opportunité ne peut pas être négatif'), 
                      'Une exception avec un message approprié aurait dû être levée.');
    }
    Test.stopTest();
    }
}
