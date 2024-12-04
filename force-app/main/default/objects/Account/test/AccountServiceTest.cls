@isTest
public class AccountServiceTest {

    @isTest
    static void testCRUDOperations() {
        // Étape 1 : Créer un compte
        Id accountId = AccountService.createAccount(
            'Test Account',
            'Technology',     // Secteur
            '123-456-7890'    // Téléphone
        );
        System.assertNotEquals(null, accountId, 'Le compte aurait dû être créé.');

        // Étape 2 : Lire le compte par nom
        Account retrievedAccount = AccountService.getAccountByName('Test Account');
        System.assertEquals('Test Account', retrievedAccount.Name, 'Le nom du compte devrait être "Test Account".');
        System.assertEquals('Technology', retrievedAccount.Industry, 'L\'industrie devrait être "Technology".');
        System.assertEquals('123-456-7890', retrievedAccount.Phone, 'Le téléphone devrait être "123-456-7890".');

        // Étape 3 : Mettre à jour le téléphone du compte
        AccountService.updateAccountPhone(accountId, '987-654-3210');
        retrievedAccount = AccountService.getAccountByName('Test Account');
        System.assertEquals('987-654-3210', retrievedAccount.Phone, 'Le téléphone devrait être "987-654-3210".');

        // Étape 4 : Supprimer le compte
        AccountService.deleteAccount(accountId);
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :accountId];
        System.assertEquals(0, accounts.size(), 'Le compte aurait dû être supprimé.');
    }

    @isTest
    static void testCreateAccountWithInvalidData() {
        // Test pour vérifier la gestion des erreurs en cas de données invalides
        Test.startTest();
        try {
            AccountService.createAccount(
                null,           // Nom manquant
                'Technology',   // Secteur valide
                '123-456-7890'  // Téléphone valide
            );
            System.assert(false, 'La création d\'un compte sans nom aurait dû échouer.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'), 'Une exception aurait dû être levée pour un champ manquant.');
        }
        Test.stopTest();
    }

    @isTest
    static void testReadNonExistentAccount() {
        // Vérifier que la méthode retourne null ou lève une exception pour un compte non existant
        Test.startTest();
        try {
            Account nonExistentAccount = AccountService.getAccountByName('Non Existent Account');
            System.assert(nonExistentAccount == null, 'Aucun compte ne devrait être trouvé.');
        } catch (Exception e) {
            System.assert(false, 'Une exception inattendue a été levée : ' + e.getMessage());
        }
        Test.stopTest();
    }
}
