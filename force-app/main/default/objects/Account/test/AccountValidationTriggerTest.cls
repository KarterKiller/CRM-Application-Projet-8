@isTest
public class AccountValidationTriggerTest {

    @isTest
    static void testAccountNameValidation() {
        // Crée un compte sans nom en utilisant la factory
        Account acc = TestDataFactory.createAccount(false);
        acc.Name = null; // Supprime le nom pour provoquer l'erreur

        Test.startTest();
        try {
            insert acc;
            System.assertEquals(false, true, 'Une erreur aurait dû être levée pour un nom de compte manquant.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le nom du compte est obligatoire.'), 'Le message d\'erreur est incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testPhoneValidation() {
        // Crée un compte avec un numéro de téléphone invalide
        Account acc = TestDataFactory.createAccount(false);
        acc.Phone = '12345'; // Numéro invalide

        Test.startTest();
        try {
            insert acc;
            System.assertEquals(false, true, 'Une erreur aurait dû être levée pour un numéro de téléphone invalide.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le numéro de téléphone est obligatoire et doit contenir exactement 10 chiffres.'), 'Le message d\'erreur est incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testStatusValidation() {
        // Crée un compte avec un statut "No"
        Account acc = TestDataFactory.createAccount(false);
        acc.Active__c = 'No'; // Défini sur "No" pour déclencher l'erreur

        Test.startTest();
        try {
            insert acc;
            System.assertEquals(false, true, 'Une exception aurait dû être levée pour un statut de compte inactif ("No").');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le champ "Active__c" est obligatoire et doit avoir la valeur "Yes".'), 'Le message d\'erreur est incorrect.');
        }
        Test.stopTest();
    }
}
