public class OpportunityTriggerHandler {

    public static void handleOpportunityUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        List<Trip__c> tripsToInsert = new List<Trip__c>();
        List<Contract> contractsToInsert = new List<Contract>(); // Liste pour stocker les contrats à insérer

        // Extraire les AccountId des opportunités
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        // Récupérer les comptes liés aux opportunités
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT Id, Name FROM Account WHERE Id IN :accountIds]
        );

        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);

            // Vérification si l'opportunité passe au statut "Closed Won"
            if (oldOpp.StageName != 'Closed Won' && opp.StageName == 'Closed Won') {
                if (opp.AccountId != null) {
                    // Valider les dates avant de créer le Trip
                    if (opp.StartTripDate__c != null && opp.EndTripDate__c != null) {
                        if (opp.EndTripDate__c <= opp.StartTripDate__c) {
                            opp.EndTripDate__c.addError('La date de fin doit être postérieure à la date de début.');
                        }
                    }

                    // Si aucune erreur, créer un enregistrement Trip__c
                    if (!Trigger.newMap.get(opp.Id).hasErrors()) {
                        Trip__c trip = new Trip__c();

                        // Récupérer le nom du compte et autres informations
                        String accountName = accountMap.containsKey(opp.AccountId) ? accountMap.get(opp.AccountId).Name : 'NoAccount';
                        String destination = opp.Destination__c != null ? opp.Destination__c : 'Unknown';
                        String startDate = opp.StartTripDate__c != null ? opp.StartTripDate__c.format() : 'NoDate';

                        // Générer un nom lisible pour le trip
                        trip.Name = 'Trip - ' + destination + ' - ' + startDate + ' - ' + accountName;
                        trip.Status__c = 'A venir';
                        trip.Destination__c = opp.Destination__c;
                        trip.StartTripDate__c = opp.StartTripDate__c;  // Utilisation de StartTripDate__c
                        trip.EndTripDate__c = opp.EndTripDate__c;      // Utilisation de EndTripDate__c
                        trip.Number_of_Participants__c = opp.Number_of_Participants__c;
                        trip.Total_Cost__c = opp.Amount;
                        trip.Account__c = opp.AccountId;
                        trip.Opportunity__c = opp.Id;

                        tripsToInsert.add(trip);
                    }

                    // Créer un contrat à partir de l'opportunité
                    Contract newContract = new Contract(
                        AccountId = opp.AccountId,  // Lier le contrat au compte de l'opportunité
                        Opportunity__c = opp.Id,    // Lier le contrat à l'opportunité
                        Name = 'Contract for ' + opp.Name,  // Nom du contrat
                        Amount__c = opp.Amount,      // Montant de l'opportunité
                        Destination__c = opp.Destination__c, // Destination du contrat
                        Number_of_Participants__c = opp.Number_of_Participants__c, // Nombre de participants
                        StartTripDate__c = opp.StartTripDate__c,  // Ajoute la date de début du voyage au contrat
                        EndTripDate__c = opp.EndTripDate__c   // Ajoute la date de fin du voyage au contrat
                    );
                    
                    contractsToInsert.add(newContract);
                }
            }
        }

        // Insérer les enregistrements Trip__c valides
        if (!tripsToInsert.isEmpty()) {
            insert tripsToInsert;
        }

        // Insérer les contrats créés
        if (!contractsToInsert.isEmpty()) {
            insert contractsToInsert;
        }
    }
}
