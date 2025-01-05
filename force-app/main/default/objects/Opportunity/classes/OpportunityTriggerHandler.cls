public with sharing class OpportunityTriggerHandler {
 
    public static void createTripAndContractForClosedWon(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        List<Trip__c> tripsToInsert = new List<Trip__c>(); // Crée une liste de voyages
        List<Contract> contractsToInsert = new List<Contract>();

        for (Opportunity opp : newOpps) { // Parcours chaque opportunité de la liste des nouvelles opp ( newOpps)
            Opportunity oldOpp = oldOppMap != null ? oldOppMap.get(opp.Id) : null; // Cherche l'ancienne version de l'oppo ( oldOpp) dans oldOppMap. 

            // Vérifier si l'opportunité passe à "Closed Won"
            if (opp.StageName == 'Closed Won' && (oldOpp == null || oldOpp.StageName != 'Closed Won')) { // Si l'oppo est en Closed Won et que l'ancienne version n'était pas en Closed Won
                // Vérifier que tous les champs nécessaires sont remplis
                if (opp.StartTripDate__c != null && opp.EndTripDate__c != null &&
                    opp.Destination__c != null && opp.Number_of_Participants__c != null && opp.Amount != null) {
                    
                    // Créer un voyage
                    Trip__c trip = new Trip__c(
                        Name = 'Trip - ' + opp.Destination__c + ' - ' + opp.StartTripDate__c.format(),
                        Status__c = 'A venir',
                        Destination__c = opp.Destination__c,
                        StartTripDate__c = opp.StartTripDate__c,
                        EndTripDate__c = opp.EndTripDate__c,
                        Number_of_Participants__c = opp.Number_of_Participants__c,
                        Total_Cost__c = opp.Amount,
                        Account__c = opp.AccountId,
                        Opportunity__c = opp.Id
                    );
                    tripsToInsert.add(trip);

                    // Créer un contrat
                    Contract contract = new Contract(
                        Name = 'Contract for ' + opp.Name,
                        AccountId = opp.AccountId,
                        Opportunity__c = opp.Id,
                        StartTripDate__c = opp.StartTripDate__c,
                        EndTripDate__c = opp.EndTripDate__c,
                        Amount__c = opp.Amount,
                        Destination__c = opp.Destination__c,
                        Number_of_Participants__c = opp.Number_of_Participants__c,
                        Status = 'Draft' // Statut initial du contrat
                    );
                    contractsToInsert.add(contract);
                } else {
                    opp.addError('Impossible de créer le voyage et le contrat. Tous les champs obligatoires ne sont pas remplis.');
                }
            }
        }

        // Insérer les voyages créés
        if (!tripsToInsert.isEmpty()) {
            try {
                insert tripsToInsert;
            } catch (DmlException e) {
                //System.debug('Erreur lors de l\'insertion des voyages : ' + e.getMessage());
                throw e;
            }
        }

        // Insérer les contrats créés
        if (!contractsToInsert.isEmpty()) {
            try {
                insert contractsToInsert;
            } catch (DmlException e) {
                //System.debug('Erreur lors de l\'insertion des contrats : ' + e.getMessage());
                throw e;
            }
        }
    }
}