public class AccountService {

    // Créer un compte
    public static Id createAccount(String name, String industry, String phone) { // ajouter des withSharing
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('Le nom du compte est obligatoire.');
        }
        Account newAccount = new Account(Name = name, Industry = industry, Phone = phone);
        insert newAccount;
        return newAccount.Id;
    }

    // Lire un compte
    public static Account getAccountByName(String name) {
        List<Account> accounts = [SELECT Id, Name, Industry, Phone FROM Account WHERE Name = :name LIMIT 1];
        return accounts.isEmpty() ? null : accounts[0];
    }

    // Mettre à jour le téléphone du compte
    public static void updateAccountPhone(Id accountId, String newPhone) {
        Account accToUpdate = [SELECT Id, Phone FROM Account WHERE Id = :accountId];
        accToUpdate.Phone = newPhone;
        update accToUpdate;
    }

    // Supprimer un compte
    public static void deleteAccount(Id accountId) {
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE AccountId = :accountId];
        if (!opportunities.isEmpty()) {
            delete opportunities;
        }
        Account accToDelete = [SELECT Id FROM Account WHERE Id = :accountId];
        delete accToDelete;
    }
}
