public class AccountService {

    // Méthode pour créer un compte
    public static Id createAccount(String name, String industry, String phone) {
        Account newAccount = new Account(Name = name, Industry = industry, Phone = phone);
        insert newAccount;
        return newAccount.Id;
    }

    // Méthode pour lire un compte
    public static Account getAccountByName(String name) {
        return [SELECT Id, Name, Industry, Phone FROM Account WHERE Name = :name LIMIT 1];
    }

    // Méthode pour mettre à jour un compte
    public static void updateAccountPhone(Id accountId, String newPhone) {
        Account accToUpdate = [SELECT Id, Phone FROM Account WHERE Id = :accountId];
        accToUpdate.Phone = newPhone;
        update accToUpdate;
    }

    // Méthode pour supprimer un compte
    public static void deleteAccount(Id accountId) {
        Account accToDelete = [SELECT Id FROM Account WHERE Id = :accountId];
        delete accToDelete;
    }
}
