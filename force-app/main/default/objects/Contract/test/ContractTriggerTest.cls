@isTest
public class ContractTriggerTest {

    @isTest
    static void testValidationOnInsertNegativeAmount() {
        Account acc = TestDataFactory.createAccount(true);

        Contract con = TestDataFactory.createContract(acc.Id, false);
        con.Amount__c = -500; // Montant négatif pour provoquer une erreur

        Test.startTest();
        try {
            insert con;
            System.assertEquals(false, true, 'Une exception aurait dû être levée pour un montant négatif.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le montant du contrat doit être supérieur à 0.'), 'Message d\'erreur incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertZeroParticipants() {
        Account acc = TestDataFactory.createAccount(true);

        Contract con = TestDataFactory.createContract(acc.Id, false);
        con.Number_of_Participants__c = 0; // Nombre de participants invalide

        Test.startTest();
        try {
            insert con;
            System.assertEquals(false, true, 'Une exception aurait dû être levée pour un nombre de participants invalide.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le nombre de participants doit être supérieur à 0.'), 'Message d\'erreur incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertInvalidDates() {
        Account acc = TestDataFactory.createAccount(true);

        Contract con = TestDataFactory.createContract(acc.Id, false);
        con.StartTripDate__c = Date.today();
        con.EndTripDate__c = Date.today().addDays(-1); // Date de fin invalide

        Test.startTest();
        try {
            insert con;
            System.assertEquals(false, true, 'Une exception aurait dû être levée pour une date de fin invalide.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('La date de fin doit être postérieure à la date de début.'), 'Message d\'erreur incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnDelete() {
        Account acc = TestDataFactory.createAccount(true);

        Contract con = TestDataFactory.createContract(acc.Id, true); // Crée et insère un contrat valide
        con.Status = 'Activated'; // Statut activé
        update con;

        Test.startTest();
        try {
            delete con;
            System.assertEquals(false, true, 'Une exception aurait dû être levée pour une suppression invalide.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Un contrat actif ne peut pas être supprimé.'), 'Message d\'erreur incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnValidInsert() {
        Account acc = TestDataFactory.createAccount(true);

        Contract con = TestDataFactory.createContract(acc.Id, false); // Crée un contrat valide

        Test.startTest();
        insert con;
        Test.stopTest();

        Contract insertedContract = [SELECT Id, Name FROM Contract WHERE Id = :con.Id];
        System.assertEquals(true, insertedContract != null, 'Le contrat valide aurait dû être inséré.');
    }

    @isTest
    static void testValidationOnInsertMissingDates() {
        Account acc = TestDataFactory.createAccount(true);

        Contract con = TestDataFactory.createContract(acc.Id, false);
        con.StartTripDate__c = null;
        con.EndTripDate__c = null; // Dates manquantes

        Test.startTest();
        try {
            insert con;
            System.assertEquals(false, true, 'Une exception aurait dû être levée pour des dates de début et de fin manquantes.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Les dates de début et de fin du voyage sont obligatoires.'), 'Message d\'erreur incorrect.');
        }
        Test.stopTest();
    }
}
