public class ContractService {

    // **Créer un contrat**
    public static Id createContract(Id accountId, Integer contractTerm, Date startDate, String status) {
        Contract newContract = new Contract(
            AccountId = accountId,
            ContractTerm = contractTerm,
            StartDate = startDate,
            Status = status
        );
        insert newContract;
        System.debug('Nouveau contrat créé : ' + newContract.Id);
        return newContract.Id;
    }

    // **Lire un contrat par ID**
    public static Contract getContractById(Id contractId) {
        return [SELECT Id, AccountId, StartDate, ContractTerm, Status 
                FROM Contract 
                WHERE Id = :contractId];
    }

    // **Lire les contrats par statut**
    public static List<Contract> getContractsByStatus(String status) {
        return [SELECT Id, AccountId, StartDate, ContractTerm, Status 
                FROM Contract 
                WHERE Status = :status];
    }

    // **Mettre à jour le statut d'un contrat**
    public static void updateContractStatus(Id contractId, String newStatus) {
        Contract contractToUpdate = [SELECT Id, Status FROM Contract WHERE Id = :contractId];
        contractToUpdate.Status = newStatus;
        update contractToUpdate;
        System.debug('Statut du contrat mis à jour : ' + contractToUpdate.Id + ' -> ' + newStatus);
    }

    // **Mettre à jour la durée d'un contrat**
    public static void updateContractTerm(Id contractId, Integer newTerm) {
        Contract contractToUpdate = [SELECT Id, ContractTerm FROM Contract WHERE Id = :contractId];
        contractToUpdate.ContractTerm = newTerm;
        update contractToUpdate;
        System.debug('Durée du contrat mise à jour : ' + contractToUpdate.Id + ' -> ' + newTerm + ' mois');
    }

    // **Supprimer un contrat**
    public static void deleteContract(Id contractId) {
        Contract contractToDelete = [SELECT Id FROM Contract WHERE Id = :contractId];
        delete contractToDelete;
        System.debug('Contrat supprimé : ' + contractToDelete.Id);
    }

    // **Supprimer les contrats d'un compte spécifique**
    public static void deleteContractsByAccountId(Id accountId) {
        List<Contract> contractsToDelete = [SELECT Id FROM Contract WHERE AccountId = :accountId];
        delete contractsToDelete;
        System.debug('Contrats supprimés pour le compte : ' + accountId);
    }
}
