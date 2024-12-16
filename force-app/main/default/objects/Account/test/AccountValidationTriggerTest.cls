@isTest
public class AccountValidationTriggerTest {
    @isTest
    static void testAccountNameValidation() {
        Account acc = new Account(Industry = 'Technology');
        try {
            insert acc;
            System.assert(false, 'Une erreur aurait dû être levée pour un nom de compte manquant.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le nom du compte est obligatoire.'), 'Le message d\'erreur est incorrect.');
        }
    }

    @isTest
    static void testPhoneValidation() {
        Account acc = new Account(Name = 'Test Account', Phone = '12345');
        try {
            insert acc;
            System.assert(false, 'Une erreur aurait dû être levée pour un numéro de téléphone invalide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le numéro de téléphone doit contenir exactement 10 chiffres.'), 'Le message d\'erreur est incorrect.');
        }
    }
    @isTest
    static void testStatusValidation() {
        // Création d'un compte avec un statut "No"
        Account acc = new Account(
            Name = 'Test Account',
            Industry = 'Technology',
            Active__c = 'No' // Défini sur "No" pour déclencher l'erreur
        );

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Une exception aurait dû être levée pour un statut de compte inactif ("No").');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Le champ "Active__c" doit avoir la valeur "Yes".'),
                'Le message d\'erreur est incorrect.'
            );
        }
        Test.stopTest();
    }
}
