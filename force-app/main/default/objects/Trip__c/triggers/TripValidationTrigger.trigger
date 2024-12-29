trigger TripValidationTrigger on Trip__c (before insert, before update) {

    if (TriggerHelper.skipValidation) {
        return; // Ne pas exécuter les validations si elles sont désactivées
    }

    for (Trip__c trip : Trigger.new) {
        // Validation du nom (obligatoire)
        if (String.isBlank(trip.Name)) {
            trip.addError('Le nom du voyage est obligatoire.');
        }

        // Validation des dates (la date de fin doit être après la date de début)
        if (trip.StartTripDate__c != null && trip.EndTripDate__c != null) {
            if (trip.EndTripDate__c <= trip.StartTripDate__c) {
                trip.addError('La date de fin doit être postérieure à la date de début.');
            }
        }

        // Validation du statut (obligatoire)
        if (String.isBlank(trip.Status__c)) {
            trip.addError('Le statut du voyage est obligatoire.');
        }

        // Validation du coût total (ne doit pas être négatif)
        if (trip.Total_Cost__c != null && trip.Total_Cost__c < 0) {
            trip.addError('Le coût total ne peut pas être négatif.');
        }

        // Validation de l'association avec un compte (obligatoire)
        if (trip.Account__c == null) {
            trip.addError('Le voyage doit être associé à un compte.');
        }

        // Validation pour les voyages avec le statut "Terminé"
        if (trip.Status__c == 'Terminé' && trip.EndTripDate__c != null && trip.EndTripDate__c > Date.today()) {
            trip.addError('Un voyage avec une date de fin dans le futur ne peut pas être marqué comme "Terminé".');
        }
    }
}
