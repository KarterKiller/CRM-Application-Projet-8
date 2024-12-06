trigger ContractValidationTrigger on Contract (before update) {
    for (Contract c : Trigger.new) {
        // Vérifier que le statut est modifié en "Actif"
        if (c.Status == 'Actif' && Trigger.oldMap.get(c.Id).Status != 'Actif') {

            // Vérification des dates (Date de fin doit être après la date de début)
            if (c.StartDate != null && c.EndDate != null) {
                if (c.StartDate >= c.EndDate) {
                    c.addError('La date de fin doit être postérieure à la date de début.');
                }
            }

            // Vérification du montant total (doit être supérieur à 0)
            if (c.Amount__c <= 0) {
                c.addError('Le montant total du contrat doit être supérieur à zéro.');
            }

            // Vérification que le contrat est associé à un compte valide
            if (c.AccountId == null) {
                c.addError('Le contrat doit être associé à un compte.');
            }

            // Vérification que des champs obligatoires sont remplis (ex : Description)
            if (String.isEmpty(c.Description)) {
                c.addError('Le type de contrat est obligatoire.');
            }

            if (c.Number_of_Participants__c == null) {
                c.addError('Le nombre de participants est obligatoire.');
            }

        }
    }
}
