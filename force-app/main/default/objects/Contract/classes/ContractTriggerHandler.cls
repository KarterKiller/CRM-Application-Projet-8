public class ContractTriggerHandler {

    public static void validateInsert(List<Contract> newContracts) {
        for (Contract con : newContracts) {
            // Validation : Montant du contrat
            if (con.Amount__c == null || con.Amount__c <= 0) {
                con.addError('Le montant du contrat doit être supérieur à 0.');
            }

            // Validation : Nombre de participants
            if (con.Number_of_Participants__c == null || con.Number_of_Participants__c <= 0) {
                con.addError('Le nombre de participants doit être supérieur à 0.');
            }

            // Validation : Dates de voyage
            if (con.StartTripDate__c == null || con.EndTripDate__c == null) {
                con.addError('Les dates de début et de fin du voyage sont obligatoires.');
            } else if (con.EndTripDate__c <= con.StartTripDate__c) {
                con.addError('La date de fin doit être postérieure à la date de début.');
            }
        }
    }

    public static void validateUpdate(List<Contract> newContracts, Map<Id, Contract> oldContractMap) {
        for (Contract con : newContracts) {
            Contract oldCon = oldContractMap.get(con.Id);

            // Validation : Montant du contrat
            if (con.Amount__c == null || con.Amount__c <= 0) {
                con.addError('Le montant du contrat doit être supérieur à 0.');
            }

            // Validation : Nombre de participants
            if (con.Number_of_Participants__c == null || con.Number_of_Participants__c <= 0) {
                con.addError('Le nombre de participants doit être supérieur à 0.');
            }

            // Validation : Statut
            if (oldCon.Status == 'Signed' && con.Status != 'Signed') {
                con.addError('Un contrat signé ne peut pas être modifié.');
            }

            // Validation : Dates de voyage
            if (con.StartTripDate__c == null || con.EndTripDate__c == null) {
                con.addError('Les dates de début et de fin du voyage sont obligatoires.');
            } else if (con.EndTripDate__c <= con.StartTripDate__c) {
                con.addError('La date de fin doit être postérieure à la date de début.');
            }
        }
    }

    public static void validateDelete(List<Contract> oldContracts) {
        for (Contract con : oldContracts) {
            // Validation : Statut actif
            if (con.Status == 'Activated') {
                con.addError('Un contrat actif ne peut pas être supprimé.');
            }
        }
    }
}