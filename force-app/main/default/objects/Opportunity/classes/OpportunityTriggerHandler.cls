public class OpportunityTriggerHandler {

    public static void handleOpportunityUpdate(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        List<Trip__c> tripsToInsert = new List<Trip__c>();

        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            if (oldOpp.StageName != 'Closed Won' && opp.StageName == 'Closed Won') {
                if (opp.AccountId != null) {
                    // Valider les dates avant de créer le Trip
                    if (opp.Start_Date__c != null && opp.End_Date__c != null) {
                        if (opp.End_Date__c <= opp.Start_Date__c) {
                            // Ajouter une erreur directement sur le champ de fin
                            opp.End_Date__c.addError('La date de fin doit être postérieure à la date de début.');
                        }
                    }

                    // Si aucune erreur, créer un enregistrement Trip__c
                    if (!Trigger.newMap.get(opp.Id).hasErrors()) {
                        Trip__c trip = new Trip__c();
                        trip.Name = 'Trip-' + DateTime.now().format('yyyyMMddHHmmss');
                        trip.Status__c = 'A venir';
                        trip.Destination__c = opp.Destination__c;
                        trip.Start_Date__c = opp.Start_Date__c;
                        trip.End_Date__c = opp.End_Date__c;
                        trip.Number_of_Participants__c = opp.Number_of_Participants__c;
                        trip.Total_Cost__c = opp.Amount;
                        trip.Account__c = opp.AccountId;
                        trip.Opportunity__c = opp.Id;

                        tripsToInsert.add(trip);
                    }
                }
            }
        }

        // Insérer les enregistrements Trip__c valides
        if (!tripsToInsert.isEmpty()) {
            insert tripsToInsert;
        }
    }
}
