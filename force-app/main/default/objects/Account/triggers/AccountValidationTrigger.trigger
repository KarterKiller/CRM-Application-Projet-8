trigger AccountValidationTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        // Vérification : Le nom du compte est obligatoire
        if (String.isBlank(acc.Name)) {
            acc.addError('Le nom du compte est obligatoire.');
        }

        // Vérification : L'industrie est obligatoire
        if (String.isBlank(acc.Industry)) {
            acc.addError('Le champ "Industry" est obligatoire.');
        }

        // Vérification : Le numéro de téléphone doit être valide
        if (!String.isBlank(acc.Phone) && !Pattern.matches('\\d{10}', acc.Phone)) {
            acc.addError('Le numéro de téléphone doit contenir exactement 10 chiffres.');
        }

        // Vérification : Le champ "Active__c" doit être "Yes"
        if (acc.Active__c != null && acc.Active__c != 'Yes') {
            acc.addError('Le champ "Active__c" doit avoir la valeur "Yes".');
        }
    }
}
