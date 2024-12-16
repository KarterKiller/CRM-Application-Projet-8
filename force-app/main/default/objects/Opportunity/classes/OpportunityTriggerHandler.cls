public with sharing class OpportunityTriggerHandler {

    public static void validateOpportunity(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        for (Opportunity opp : newOpps) {
            // Validation du montant
            if (opp.Amount == null || opp.Amount <= 0) {
                opp.addError('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.');
            }

            // Validation des dates de voyage
            if (opp.StartTripDate__c == null || opp.EndTripDate__c == null) {
                opp.addError('Les dates de début et de fin du voyage sont obligatoires.');
            } else if (opp.EndTripDate__c <= opp.StartTripDate__c) {
                opp.addError('La date de fin du voyage doit être postérieure à la date de début.');
            }

            // Validation de la relation avec un compte
            if (opp.AccountId == null) {
                opp.addError('L\'opportunité doit être associée à un compte.');
            }

            // Validation du nom de l'opportunité
            if (String.isBlank(opp.Name)) {
                opp.addError('Le nom de l\'opportunité est obligatoire.');
            }

            // Validation de la destination
            if (String.isBlank(opp.Destination__c)) {
                opp.addError('La destination est obligatoire.');
            }

            // Validation du nombre de participants
            if (opp.Number_of_Participants__c == null || opp.Number_of_Participants__c <= 0) {
                opp.addError('Le nombre de participants est obligatoire et doit être supérieur à 0.');
            }
        }
    }

    public static void createTripAndContractForClosedWon(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        List<Trip__c> tripsToInsert = new List<Trip__c>();
        List<Contract> contractsToInsert = new List<Contract>();

        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldOppMap != null ? oldOppMap.get(opp.Id) : null;

            // Vérifier si l'opportunité passe à "Closed Won"
            if (opp.StageName == 'Closed Won' && (oldOpp == null || oldOpp.StageName != 'Closed Won')) {
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
                System.debug('Erreur lors de l\'insertion des voyages : ' + e.getMessage());
                throw e;
            }
        }

        // Insérer les contrats créés
        if (!contractsToInsert.isEmpty()) {
            try {
                insert contractsToInsert;
            } catch (DmlException e) {
                System.debug('Erreur lors de l\'insertion des contrats : ' + e.getMessage());
                throw e;
            }
        }
    }
}
