public with sharing class ValidationHelper {

    // Méthodes pour Account
    public static void validateAccount(Account acc, Account oldAcc) {
        // Vérification : Le nom du compte est obligatoire
        if (String.isBlank(acc.Name)) {
            acc.addError('Le nom du compte est obligatoire.');
        }

        // Vérification : L'industrie est obligatoire
        if ((oldAcc == null || oldAcc.Industry != acc.Industry) &&
            String.isBlank(acc.Industry)) {
            acc.addError('Le champ "Industry" est obligatoire.');
        }

        // Vérification : Le numéro de téléphone est obligatoire et doit contenir exactement 10 chiffres
        if (String.isBlank(acc.Phone) || !Pattern.matches('\\d{10}', acc.Phone)) {
            acc.addError('Le numéro de téléphone est obligatoire et doit contenir exactement 10 chiffres.');
        }

        // Vérification : Le champ "Active__c" est obligatoire et doit uniquement avoir la valeur "Yes"
        if (String.isBlank(acc.Active__c) || acc.Active__c != 'Yes') {
            acc.addError('Le champ "Active__c" est obligatoire et doit avoir la valeur "Yes".');
        }
    }

    // Méthodes pour Contract
    public static void validateContractInsert(Contract con) {
        if (con.Amount__c == null || con.Amount__c <= 0) {
            con.addError('Le montant du contrat doit être supérieur à 0.');
        }
        if (con.Number_of_Participants__c == null || con.Number_of_Participants__c <= 0) {
            con.addError('Le nombre de participants doit être supérieur à 0.');
        }
        if (con.StartTripDate__c == null || con.EndTripDate__c == null) {
            con.addError('Les dates de début et de fin du voyage sont obligatoires.');
        } else if (con.EndTripDate__c <= con.StartTripDate__c) {
            con.addError('La date de fin doit être postérieure à la date de début.');
        }
    }

    public static void validateContractUpdate(Contract con, Contract oldCon) {
        if ((oldCon == null || oldCon.Amount__c != con.Amount__c) &&
            (con.Amount__c == null || con.Amount__c <= 0)) {
            con.addError('Le montant du contrat doit être supérieur à 0.');
        }
        if ((oldCon == null || oldCon.Number_of_Participants__c != con.Number_of_Participants__c) &&
            (con.Number_of_Participants__c == null || con.Number_of_Participants__c <= 0)) {
            con.addError('Le nombre de participants doit être supérieur à 0.');
        }
        if (oldCon != null && oldCon.Status == 'Signed' && con.Status != 'Signed') {
            con.addError('Un contrat signé ne peut pas être modifié.');
        }
        if ((oldCon == null || oldCon.StartTripDate__c != con.StartTripDate__c ||
            oldCon.EndTripDate__c != con.EndTripDate__c)) {
            if (con.StartTripDate__c == null || con.EndTripDate__c == null) {
                con.addError('Les dates de début et de fin du voyage sont obligatoires.');
            } else if (con.EndTripDate__c <= con.StartTripDate__c) {
                con.addError('La date de fin doit être postérieure à la date de début.');
            }
        }
    }

    public static void validateContractDelete(Contract con) {
        if (con.Status == 'Activated') {
            con.addError('Un contrat actif ne peut pas être supprimé.');
        }
    }

    // Méthodes pour Task
    public static void validateTask(List<Task> newTasks, Map<Id, Task> oldTaskMap) {
        for (Task task : newTasks) {
            Task oldTask = oldTaskMap != null ? oldTaskMap.get(task.Id) : null;

            if (String.isBlank(task.Subject)) {
                task.addError('Le sujet de la tâche est obligatoire.');
            }

            if (task.ActivityDate != null && task.ActivityDate < Date.today()) {
                task.addError('La date de l\'activité doit être aujourd\'hui ou dans le futur.');
            }

            if (!String.isBlank(task.Priority) &&
                task.Priority != 'High' && task.Priority != 'Medium' && task.Priority != 'Low') {
                task.addError('La priorité doit être "High", "Medium" ou "Low".');
            }

            if (task.WhatId == null && task.WhoId == null) {
                task.addError('La tâche doit être associée à un enregistrement via WhatId ou WhoId.');
            }

            if (oldTask != null && task.Status != null && task.Status == 'Completed') {
                if (task.ActivityDate != null && task.ActivityDate > Date.today()) {
                    task.addError('Une tâche avec une date d\'activité dans le futur ne peut pas être marquée comme "Completed".');
                }
            }
        }
    }

    // Méthodes pour Opportunity
    public static void validateOpportunity(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        for (Opportunity opp : newOpps) {
            Opportunity oldOpp = oldOppMap != null ? oldOppMap.get(opp.Id) : null;

            if ((oldOpp == null || oldOpp.Amount != opp.Amount) && (opp.Amount == null || opp.Amount <= 0)) {
                opp.addError('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.');
            }

            if ((oldOpp == null || oldOpp.StartTripDate__c != opp.StartTripDate__c || oldOpp.EndTripDate__c != opp.EndTripDate__c)) {
                if (opp.StartTripDate__c == null || opp.EndTripDate__c == null) {
                    opp.addError('Les dates de début et de fin du voyage sont obligatoires.');
                } else if (opp.EndTripDate__c <= opp.StartTripDate__c) {
                    opp.addError('La date de fin du voyage doit être postérieure à la date de début.');
                }
            }

            if ((oldOpp == null || oldOpp.AccountId != opp.AccountId) && opp.AccountId == null) {
                opp.addError('L\'opportunité doit être associée à un compte.');
            }

            if ((oldOpp == null || oldOpp.Name != opp.Name) && String.isBlank(opp.Name)) {
                opp.addError('Le nom de l\'opportunité est obligatoire.');
            }

            if ((oldOpp == null || oldOpp.Destination__c != opp.Destination__c) && String.isBlank(opp.Destination__c)) {
                opp.addError('La destination est obligatoire.');
            }

            if ((oldOpp == null || oldOpp.Number_of_Participants__c != opp.Number_of_Participants__c) &&
                (opp.Number_of_Participants__c == null || opp.Number_of_Participants__c <= 0)) {
                opp.addError('Le nombre de participants est obligatoire et doit être supérieur à 0.');
            }
        }
    }

    // Méthodes pour Trip
    public static void validateTrip(List<Trip__c> newTrips, Map<Id, Trip__c> oldTripMap) {
        for (Trip__c trip : newTrips) {
            Trip__c oldTrip = oldTripMap != null ? oldTripMap.get(trip.Id) : null;

            if (String.isBlank(trip.Name)) {
                trip.addError('Le nom du voyage est obligatoire.');
            }

            if (trip.StartTripDate__c != null && trip.EndTripDate__c != null) {
                if (trip.EndTripDate__c <= trip.StartTripDate__c) {
                    trip.addError('La date de fin doit être postérieure à la date de début.');
                }
            }

            if (String.isBlank(trip.Status__c)) {
                trip.addError('Le statut du voyage est obligatoire.');
            }

            if (trip.Total_Cost__c != null && trip.Total_Cost__c < 0) {
                trip.addError('Le coût total ne peut pas être négatif.');
            }

            if (trip.Account__c == null) {
                trip.addError('Le voyage doit être associé à un compte.');
            }

            if (trip.Status__c == 'Terminé' && trip.EndTripDate__c != null && trip.EndTripDate__c > Date.today()) {
                trip.addError('Un voyage avec une date de fin dans le futur ne peut pas être marqué comme "Terminé".');
            }
        }
    }
}
