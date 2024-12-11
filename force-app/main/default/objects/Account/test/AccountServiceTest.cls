@isTest
public class AccountServiceTest {

    @isTest
    static void testCRUDOperations() {
        // Créer un compte
        Id accountId = AccountService.createAccount('Test Account', 'Technology', '123-456-7890');
        System.assertNotEquals(null, accountId, 'Le compte aurait dû être créé.');

        // Lire le compte
        Account retrievedAccount = AccountService.getAccountByName('Test Account');
        System.assertEquals('Test Account', retrievedAccount.Name, 'Le nom du compte devrait être "Test Account".');

        // Mettre à jour le téléphone
        AccountService.updateAccountPhone(accountId, '987-654-3210');
        retrievedAccount = AccountService.getAccountByName('Test Account');
        System.assertEquals('987-654-3210', retrievedAccount.Phone, 'Le téléphone devrait être mis à jour.');

        // Supprimer le compte
        AccountService.deleteAccount(accountId);
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :accountId];
        System.assertEquals(0, accounts.size(), 'Le compte aurait dû être supprimé.');
    }

    @isTest
    static void testGetAccountByNameNotFound() {
        // Étape 1 : Tenter de récupérer un compte inexistant
        Account retrievedAccount = AccountService.getAccountByName('Nonexistent Account');
        System.assertEquals(null, retrievedAccount, 'Aucun compte ne devrait être trouvé.');
    }

    @isTest
    static void testDeleteAccountWithOpportunities() {
        // Étape 1 : Créer un compte
        Account acc = new Account(Name = 'Account with Opportunities', Industry = 'Finance', Phone = '123-456-7890');
        insert acc;

        // Étape 2 : Créer des opportunités associées au compte
        Opportunity opp1 = new Opportunity(Name = 'Opportunity 1', StageName = 'Prospecting', CloseDate = Date.today().addDays(10), AccountId = acc.Id);
        Opportunity opp2 = new Opportunity(Name = 'Opportunity 2', StageName = 'Qualification', CloseDate = Date.today().addDays(15), AccountId = acc.Id);
        insert new List<Opportunity>{opp1, opp2};

        // Vérifier que les opportunités existent
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id];
        System.assertEquals(3, opportunities.size(), 'Trois opportunités devraient exister pour ce compte.');

        // Étape 3 : Supprimer le compte
        AccountService.deleteAccount(acc.Id);

        // Vérifier que le compte et les opportunités ont été supprimés
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, accounts.size(), 'Le compte aurait dû être supprimé.');

        opportunities = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id];
        System.assertEquals(0, opportunities.size(), 'Toutes les opportunités associées au compte auraient dû être supprimées.');
    }
}
