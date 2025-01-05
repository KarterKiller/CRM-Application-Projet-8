@isTest
public class CentralizedCrudValidationTest {

    @isTest
    static void testCreatePermissionValid() {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'create');
            System.assertEquals(true, true, 'La permission de création est valide pour Account.');
        } catch (Exception e) {
            System.assert(false, 'Aucune exception n\'aurait dû être levée pour une permission valide.');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreatePermissionInvalid() {
    // Créez un utilisateur avec des permissions restreintes
    Profile p = [SELECT Id FROM Profile WHERE Name = 'User Basique Test'];
    User restrictedUser = new User(
        Alias = 'rest',
        Email = 'restricteduser@example.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Restricted',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = p.Id,
        TimeZoneSidKey = 'America/New_York',
        Username = 'restricteduser@example.com'
    );
    insert restrictedUser;

    // Exécuter en tant que cet utilisateur
    System.runAs(restrictedUser) {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'create');
            System.assert(false, 'Une exception aurait dû être levée pour une création sans permission.');
        } catch (CustomAccessException e) {
            System.assertEquals(
                true,
                e.getMessage().contains('Vous n\'avez pas la permission de créer des enregistrements pour Account'),
                'Message d\'erreur incorrect.'
            );
        }
        Test.stopTest();
    }


    }

    @isTest
    static void testReadPermissionValid() {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'read');
            System.assertEquals(true, true, 'La permission de lecture est valide pour Account.');
        } catch (Exception e) {
            System.assert(false, 'Aucune exception n\'aurait dû être levée pour une permission valide.');
        }
        Test.stopTest();
    }

    @isTest
    static void testUnsupportedOperation() {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'unsupported');
            System.assert(false, 'Une exception aurait dû être levée pour une opération non prise en charge.');
        } catch (IllegalArgumentException e) {
            System.assertEquals(true, e.getMessage().contains('Opération non prise en charge'), 'Le message d\'erreur est incorrect.');
        }
        Test.stopTest();
    }

    @isTest
    static void testInvalidObject() {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('NonExistentObject', 'read');
            System.assert(false, 'Une exception aurait dû être levée pour un objet non valide.');
        } catch (NullPointerException e) {
            System.assertEquals(true, true, 'Une exception a bien été levée pour un objet non valide.');
        }
        Test.stopTest();
    }

    @isTest
    static void testDeletePermissionInvalid() {
    // Créez un utilisateur avec des permissions restreintes
    Profile p = [SELECT Id FROM Profile WHERE Name = 'User Basique Test'];
    User restrictedUser = new User(
        Alias = 'rest',
        Email = 'restricteduser@example.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Restricted',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        ProfileId = p.Id,
        TimeZoneSidKey = 'America/New_York',
        Username = 'restricteduser@example.com'
    );
    insert restrictedUser;

    // Exécuter en tant que cet utilisateur
    System.runAs(restrictedUser) {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'delete');
            System.assert(false, 'Une exception aurait dû être levée pour une suppression sans permission.');
        } catch (CustomAccessException e) {
            System.assertEquals(
                true,
                e.getMessage().contains('Vous n\'avez pas la permission de supprimer des enregistrements pour Account'),
                'Message d\'erreur incorrect.'
            );
        }
        Test.stopTest();
    }
}

}