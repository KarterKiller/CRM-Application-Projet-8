trigger OpportunityTrigger on Opportunity (after update) {
    // Appeler la méthode dans une classe Handler pour garder le code organisé
    OpportunityTriggerHandler.handleOpportunityUpdate(Trigger.new, Trigger.oldMap);
}
