trigger TaskValidationTrigger on Task (before insert, before update) {
    for (Task task : Trigger.new) {
        // Validation du sujet (obligatoire)
        if (String.isBlank(task.Subject)) {
            task.addError('Le sujet de la tâche est obligatoire.');
        }

        // Validation de la date de l'activité (doit être aujourd'hui ou dans le futur)
        if (task.ActivityDate != null && task.ActivityDate < Date.today()) {
            task.addError('La date de l\'activité doit être aujourd\'hui ou dans le futur.');
        }

        // Validation de la priorité (doit être "High", "Medium", ou "Low")
        if (!String.isBlank(task.Priority) && 
            task.Priority != 'High' && task.Priority != 'Medium' && task.Priority != 'Low') {
            task.addError('La priorité doit être "High", "Medium" ou "Low".');
        }

        // Validation des relations avec des enregistrements (au moins `WhatId` ou `WhoId` doit être défini)
        if (task.WhatId == null && task.WhoId == null) {
            task.addError('La tâche doit être associée à un enregistrement via WhatId ou WhoId.');
        }

        // Validation personnalisée pour les tâches ouvertes
        if (Trigger.isUpdate && task.Status != null && task.Status == 'Completed') {
            if (task.ActivityDate != null && task.ActivityDate > Date.today()) {
                task.addError('Une tâche avec une date d\'activité dans le futur ne peut pas être marquée comme "Completed".');
            }
        }
    }
}
