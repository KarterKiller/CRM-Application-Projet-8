@isTest
public class ContractTriggerHandlerTest {

    // Méthode utilitaire pour créer un compte de test
    private static Account createTestAccount() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;
        return acc;
    }

    @isTest
    static void testValidationOnInsertNegativeAmount() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        Contract con = new Contract(
            Name = 'Test Contract',
            AccountId = acc.Id,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = -500, // Montant invalide
            Number_of_Participants__c = 10,
            Status = 'Draft'
        );

        Test.startTest();
        try {
            insert con;
            System.assert(false, 'Une exception aurait dû être levée pour un montant négatif.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le montant du contrat doit être supérieur à 0.'), 'Message d\'erreur pour le montant manquant.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertZeroParticipants() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        Contract con = new Contract(
            Name = 'Test Contract',
            AccountId = acc.Id,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 500,
            Number_of_Participants__c = 0, // Participants invalides
            Status = 'Draft'
        );

        Test.startTest();
        try {
            insert con;
            System.assert(false, 'Une exception aurait dû être levée pour un nombre de participants invalide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le nombre de participants doit être supérieur à 0.'), 'Message d\'erreur pour les participants manquant.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertInvalidDates() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        Contract con = new Contract(
            Name = 'Test Contract',
            AccountId = acc.Id,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(-1), // Date invalide
            Amount__c = 500,
            Number_of_Participants__c = 10,
            Status = 'Draft'
        );

        Test.startTest();
        try {
            insert con;
            System.assert(false, 'Une exception aurait dû être levée pour une date de fin invalide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La date de fin doit être postérieure à la date de début.'), 'Message d\'erreur pour les dates incorrectes manquant.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertMissingParticipants() {
        Account acc = createTestAccount();
    
        Contract con = new Contract(
            Name = 'Test Contract',
            AccountId = acc.Id, // Association avec le compte
            Amount__c = 500, // Montant valide
            Number_of_Participants__c = null, // Nombre de participants manquant
            StartTripDate__c = Date.today(), // Date de début valide
            EndTripDate__c = Date.today().addDays(7) // Date de fin valide
        );
    
        Test.startTest();
        try {
            insert con;
            System.assert(false, 'Une exception aurait dû être levée pour le nombre de participants manquant.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le nombre de participants doit être supérieur à 0.'), 'Message d\'erreur pour les participants manquant.');
        }
        Test.stopTest();

    }

    @isTest
    static void testValidationOnDelete() {
        // Étape 1 : Créer un compte car il est nécessaire pour un contrat
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        insert testAccount;

        // Étape 2 : Créer un contrat avec le statut Draft
        Contract con = new Contract(
            Name = 'Test Contract',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 1000,
            Number_of_Participants__c = 10,
            Status = 'Draft', // Le statut initial doit être Draft
            AccountId = testAccount.Id
        );
        insert con;

        // Étape 3 : Mettre à jour le contrat au statut Activated
        con.Status = 'Activated';
        update con;

        // Étape 4 : Tenter de supprimer le contrat avec le statut Activated
        Test.startTest();
        try {
            delete con;
            System.assert(false, 'Une exception aurait dû être levée pour une suppression invalide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Un contrat actif ne peut pas être supprimé.'), 'Le message d\'erreur est incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnValidInsert() {
        Account acc = createTestAccount();

        Contract con = new Contract(
            Name = 'Valid Contract',
            AccountId = acc.Id, // Association avec le compte
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 1000,
            Number_of_Participants__c = 10
        );

        Test.startTest();
        insert con;
        Test.stopTest();

        Contract insertedContract = [SELECT Id, Name, Amount__c, Number_of_Participants__c FROM Contract WHERE Id = :con.Id];
        System.assertNotEquals(null, insertedContract, 'Le contrat valide aurait dû être inséré.');
    }

    @isTest
static void testValidationOnInsertMissingDates() {
    Account acc = createTestAccount();

    Contract con = new Contract(
        Name = 'Test Contract',
        AccountId = acc.Id, // Association avec le compte
        Amount__c = 500, // Montant valide
        Number_of_Participants__c = 10, // Nombre de participants valide
        StartTripDate__c = null, // Date de début manquante
        EndTripDate__c = null // Date de fin manquante
    );

    Test.startTest();
    try {
        insert con;
        System.assert(false, 'Une exception aurait dû être levée pour des dates de début et de fin manquantes.');
    } catch (DmlException e) {
        System.assert(e.getMessage().contains('Les dates de début et de fin du voyage sont obligatoires.'), 'Message d\'erreur pour les dates manquantes.');
    }
    Test.stopTest();
    }

}
