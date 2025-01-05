@isTest
public class SecurityTest {

    @isTest
    static void testPreventUnauthorizedAccess() {
        // Créer un utilisateur avec le profil "Standard User Test"
        Profile standardTestProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User Test' LIMIT 1];
        User standardUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tuser',
            Email = 'test.user@example.com',
            Username = 'test.user' + System.currentTimeMillis() + '@example.com',
            ProfileId = standardTestProfile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert standardUser;

        // Créer un enregistrement Account de test en utilisant TestDataFactory
        Account testAccount = TestDataFactory.createAccount(true);

        // Simuler un utilisateur standard essayant de modifier un compte
        System.runAs(standardUser) {
            try {
                // Récupérer l'Account pour modification
                Account accountToModify = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];
                accountToModify.Name = 'Unauthorized Change';

                // Tenter une mise à jour non autorisée
                update accountToModify;

                // Si aucune exception n'est levée, le test échoue
                System.assert(false, 'L\'utilisateur standard a pu modifier un enregistrement non autorisé.');
            } catch (DmlException e) {
                // Vérifier que l'exception est correctement levée
                System.assert(true, 'L\'action non autorisée a été correctement bloquée.');
            }
        }
    }
}
