public class ContractService {

    // Créer un contrat à partir d'une opportunité
    public static Id createContractFromOpportunity(Id opportunityId) {
        // Récupérer l'opportunité
        Opportunity opp = [SELECT Id, AccountId, Name, Amount, Destination__c, Number_of_Participants__c, StartTripDate__c, EndTripDate__c
                           FROM Opportunity 
                           WHERE Id = :opportunityId 
                           LIMIT 1];
        
        // Créer le contrat en utilisant les informations de l'opportunité
        Contract newContract = new Contract(
            AccountId = opp.AccountId, // Associer le contrat au même compte que l'opportunité
            Opportunity__c = opp.Id, // Lier l'opportunité au contrat
            Name = 'Contract for ' + opp.Name,
            StartTripDate__c = opp.StartTripDate__c, // Récupérer la date de début de l'opportunité
            EndTripDate__c = opp.EndTripDate__c, // Récupérer la date de fin de l'opportunité
            Amount__c = opp.Amount, // Récupérer le montant de l'opportunité
            Destination__c = opp.Destination__c, // Récupérer la destination de l'opportunité
            Number_of_Participants__c = opp.Number_of_Participants__c // Récupérer le nombre de participants
            
        );
        
        // Insérer le contrat
        insert newContract;
        
        return newContract.Id; // Retourner l'ID du contrat créé
    }

    // **Lire un contrat par ID**
    public static Contract getContractById(Id contractId) {
        return [SELECT Id, Name, AccountId, StartDate, ContractTerm, Status 
                FROM Contract 
                WHERE Id = :contractId];
    }

    // **Lire les contrats par statut**
    public static List<Contract> getContractsByStatus(String status) {
        return [SELECT Id,  Name, AccountId, StartDate, ContractTerm, Status 
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
