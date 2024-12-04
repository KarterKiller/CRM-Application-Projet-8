public class OpportunityService {
    public static Id createOpportunity(String name, String stage, Date closeDate, Id accountId) {
        Opportunity newOpportunity = new Opportunity(
            Name = name,
            StageName = stage,
            CloseDate = closeDate,
            AccountId = accountId
        );
        insert newOpportunity;
        return newOpportunity.Id;
    }
    
    public static Opportunity getOpportunityByName(String name) {
        return [SELECT Id, Name, StageName, CloseDate, AccountId FROM Opportunity WHERE Name = :name LIMIT 1];
    }

    public static void updateOpportunityStage(Id opportunityId, String newStage) {
        Opportunity oppToUpdate = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunityId];
        oppToUpdate.StageName = newStage;
        update oppToUpdate;
    }

    public static void deleteOpportunity(Id opportunityId) {
        Opportunity oppToDelete = [SELECT Id FROM Opportunity WHERE Id = :opportunityId];
        delete oppToDelete;
    }
}
