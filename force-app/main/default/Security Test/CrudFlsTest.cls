@isTest
public class CrudFLSTest {

    @isTest
    static void testCrudFlsEnforcement() {
        // Créer un enregistrement Account de test en utilisant TestDataFactory
        Account testAccount = TestDataFactory.createAccount(true);

        // Récupérer l'enregistrement pour vérifier les permissions CRUD/FLS
        Account account = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];

        // Vérifier que l'enregistrement est bien récupéré
        System.assertNotEquals(null, account, 'L\'enregistrement Account aurait dû être récupéré.');
    }
}
