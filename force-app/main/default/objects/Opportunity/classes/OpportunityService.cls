public class OpportunityService {

    public static Id createOpportunity(String name, String stage, Date closeDate, Id accountId, Date startTripDate, Date endTripDate, Decimal amount) {
        // Validation des permissions de création
        CentralizedCrudValidation.validateCrud('Opportunity', 'create');
    
        // Vérifications des données métier
        if (accountId == null) {
            throw new DmlException('Impossible de créer une opportunité sans compte.');
        }
    
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('Le nom de l\'opportunité est obligatoire.');
        }
    
        if (closeDate == null || closeDate <= Date.today()) {
            throw new IllegalArgumentException('La date de clôture doit être une date future.');
        }
    
        if (startTripDate != null && endTripDate != null && endTripDate <= startTripDate) { // Revoir en détail tous les argumentException
            throw new IllegalArgumentException('La date de fin du voyage doit être postérieure à la date de début.');
        }

        if (amount < 0) {
            throw new IllegalArgumentException('Le montant de l\'opportunité ne peut pas être négatif.');
        }
    
        Opportunity newOpportunity = new Opportunity(
            Name = name,
            StageName = stage,
            CloseDate = closeDate,
            AccountId = accountId,
            StartTripDate__c = startTripDate,  // Ajouter la date de début du voyage
            EndTripDate__c = endTripDate,  // Ajouter la date de fin du voyage
            Amount = amount  // Ajouter le montant
        );
    
        try {
            insert newOpportunity;
        } catch (DmlException e) {
            System.debug('Erreur lors de l\'insertion de l\'opportunité : ' + e.getMessage());
            throw e; // Propager l'exception si nécessaire
        }
    
        return newOpportunity.Id;
    }

    public static Opportunity getOpportunityByName(String name) {
        // Validation des permissions de lecture
        CentralizedCrudValidation.validateCrud('Opportunity', 'read');

        return [SELECT Id, Name, StageName, CloseDate, AccountId, StartTripDate__c, EndTripDate__c, Amount FROM Opportunity WHERE Name = :name LIMIT 1];
    }

    public static void updateOpportunityStage(Id opportunityId, String newStage) {
        // Validation des permissions de mise à jour
        CentralizedCrudValidation.validateCrud('Opportunity', 'update');

        Opportunity oppToUpdate = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunityId];
        oppToUpdate.StageName = newStage;

        try {
            update oppToUpdate;
        } catch (DmlException e) {
            System.debug('Erreur lors de la mise à jour de l\'opportunité : ' + e.getMessage());
            throw e; // Propager ou gérer l'exception
        }
    }

    public static void deleteOpportunity(Id opportunityId) {
        // Validation des permissions de suppression
        CentralizedCrudValidation.validateCrud('Opportunity', 'delete');

        Opportunity oppToDelete = [SELECT Id FROM Opportunity WHERE Id = :opportunityId];

        try {
            delete oppToDelete;
        } catch (DmlException e) {
            System.debug('Erreur lors de la suppression de l\'opportunité : ' + e.getMessage());
            throw e; // Propager ou gérer l'exception
        }
    }
}
