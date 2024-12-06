public class OpportunityService {
    public static Id createOpportunity(String name, String stage, Date closeDate, Id accountId, Date startTripDate, Date endTripDate) {
        if (accountId == null) {
            throw new DmlException('Impossible de créer une opportunité sans compte.');
        }     
        
        Opportunity newOpportunity = new Opportunity(
            Name = name,
            StageName = stage,
            CloseDate = closeDate,
            AccountId = accountId,
            StartTripDate__c = startTripDate,  // Ajouter la date de début du voyage
            EndTripDate__c = endTripDate  // Ajouter la date de fin du voyage
        );

        try {
            insert newOpportunity;
        } catch (DmlException e) {
            System.debug('Error during opportunity insert: ' + e.getMessage());
            throw e; // Re-throw the exception to propagate it if needed
        }

        return newOpportunity.Id;
    }

    public static Opportunity getOpportunityByName(String name) {
        return [SELECT Id, Name, StageName, CloseDate, AccountId, StartTripDate__c, EndTripDate__c FROM Opportunity WHERE Name = :name LIMIT 1];
    }

    public static void updateOpportunityStage(Id opportunityId, String newStage) {
        Opportunity oppToUpdate = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunityId];
        oppToUpdate.StageName = newStage;

        try {
            update oppToUpdate;
        } catch (DmlException e) {
            System.debug('Error during opportunity update: ' + e.getMessage());
            throw e; // Handle the error gracefully or re-throw as needed
        }
    }

    public static void deleteOpportunity(Id opportunityId) {
        Opportunity oppToDelete = [SELECT Id FROM Opportunity WHERE Id = :opportunityId];

        try {
            delete oppToDelete;
        } catch (DmlException e) {
            System.debug('Error during opportunity delete: ' + e.getMessage());
            throw e; // Handle the error gracefully or re-throw as needed
        }
    }
}
