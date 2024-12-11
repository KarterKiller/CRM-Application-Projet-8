public class ContractService {

    // Créer un contrat à partir d'une opportunité
    public static Id createContractFromOpportunity(Id opportunityId) {
        // Validation des permissions de création
        CentralizedCrudValidation.validateCrud('Contract', 'create');

        // Récupérer l'opportunité
        Opportunity opp = [SELECT Id, AccountId, Name, Amount, Destination__c, Number_of_Participants__c, StartTripDate__c, EndTripDate__c
                           FROM Opportunity 
                           WHERE Id = :opportunityId 
                           LIMIT 1];

        // Validation des données de l'opportunité
        if (opp.Amount <= 0) {
            throw new IllegalArgumentException('Le montant de l\'opportunité doit être positif pour créer un contrat.');
        }
        if (opp.Number_of_Participants__c <= 0) {
            throw new IllegalArgumentException('Le nombre de participants doit être supérieur à 0 pour créer un contrat.');
        }
        if (opp.StartTripDate__c == null || opp.EndTripDate__c == null) {
            throw new IllegalArgumentException('Les dates de début et de fin de voyage doivent être définies pour créer un contrat.');
        }
        if (opp.EndTripDate__c <= opp.StartTripDate__c) {
            throw new IllegalArgumentException('La date de fin doit être postérieure à la date de début pour créer un contrat.');
        }

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
        try {
            insert newContract;
        } catch (DmlException e) {
            System.debug('Erreur lors de l\'insertion du contrat : ' + e.getMessage());
            throw e;
        }

        return newContract.Id;
    }

    // Lire un contrat par ID
    public static Contract getContractById(Id contractId) {
        // Validation des permissions de lecture
        CentralizedCrudValidation.validateCrud('Contract', 'read');

        return [SELECT Id, Name, AccountId, StartDate, ContractTerm, Status 
                FROM Contract 
                WHERE Id = :contractId];
    }

    // Lire les contrats par statut
    public static List<Contract> getContractsByStatus(String status) {
        // Validation des permissions de lecture
        CentralizedCrudValidation.validateCrud('Contract', 'read');

        return [SELECT Id, Name, AccountId, StartDate, ContractTerm, Status 
                FROM Contract 
                WHERE Status = :status];
    }

    // Mettre à jour le statut d'un contrat
    public static void updateContractStatus(Id contractId, String newStatus) {
        // Validation des permissions de mise à jour
        CentralizedCrudValidation.validateCrud('Contract', 'update');

        Contract contractToUpdate = [SELECT Id, Status FROM Contract WHERE Id = :contractId];
        contractToUpdate.Status = newStatus;

        try {
            update contractToUpdate;
        } catch (DmlException e) {
            System.debug('Erreur lors de la mise à jour du statut du contrat : ' + e.getMessage());
            throw e;
        }
    }

    // Mettre à jour la durée d'un contrat
    public static void updateContractTerm(Id contractId, Integer newTerm) {
        // Validation des permissions de mise à jour
        CentralizedCrudValidation.validateCrud('Contract', 'update');

        if (newTerm <= 0) {
            throw new IllegalArgumentException('La durée du contrat doit être supérieure à 0 mois.');
        }

        Contract contractToUpdate = [SELECT Id, ContractTerm FROM Contract WHERE Id = :contractId];
        contractToUpdate.ContractTerm = newTerm;

        try {
            update contractToUpdate;
        } catch (DmlException e) {
            System.debug('Erreur lors de la mise à jour de la durée du contrat : ' + e.getMessage());
            throw e;
        }
    }

    // Supprimer un contrat
    public static void deleteContract(Id contractId) {
        // Validation des permissions de suppression
        CentralizedCrudValidation.validateCrud('Contract', 'delete');

        Contract contractToDelete = [SELECT Id FROM Contract WHERE Id = :contractId];

        try {
            delete contractToDelete;
        } catch (DmlException e) {
            System.debug('Erreur lors de la suppression du contrat : ' + e.getMessage());
            throw e;
        }
    }

    // Supprimer les contrats d'un compte spécifique
    public static void deleteContractsByAccountId(Id accountId) {
        // Validation des permissions de suppression
        CentralizedCrudValidation.validateCrud('Contract', 'delete');

        List<Contract> contractsToDelete = [SELECT Id FROM Contract WHERE AccountId = :accountId];

        try {
            delete contractsToDelete;
        } catch (DmlException e) {
            System.debug('Erreur lors de la suppression des contrats pour le compte : ' + e.getMessage());
            throw e;
        }
    }
}
