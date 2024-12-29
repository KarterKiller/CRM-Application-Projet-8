@isTest
public class CentralizedCrudValidationTest {

    @isTest
    static void testCreatePermission() {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'create');
            System.assert(true, 'La permission de création est valide pour Account.');
        } catch (Exception e) {
            System.assert(false, 'Aucune exception n\'aurait dû être levée pour une opération valide.');
        }
        Test.stopTest();
    }

    @isTest
    static void testReadPermission() {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'read');
            System.assert(true, 'La permission de lecture est valide pour Account.');
        } catch (Exception e) {
            System.assert(false, 'Aucune exception n\'aurait dû être levée pour une opération valide.');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdatePermission() {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'update');
            System.assert(true, 'La permission de mise à jour est valide pour Account.');
        } catch (Exception e) {
            System.assert(false, 'Aucune exception n\'aurait dû être levée pour une opération valide.');
        }
        Test.stopTest();
    }

    @isTest
    static void testDeletePermission() {
        Test.startTest();
        try {
            CentralizedCrudValidation.validateCrud('Account', 'delete');
            System.assert(true, 'La permission de suppression est valide pour Account.');
        } catch (Exception e) {
            System.assert(false, 'Aucune exception n\'aurait dû être levée pour une opération valide.');
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
            System.assert(e.getMessage().contains('Opération non prise en charge'), 'Le message d\'erreur est incorrect.');
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
            System.assert(true, 'Une exception a bien été levée pour un objet non valide.');
        }
        Test.stopTest();
    }
}
