# TaskValidationTrigger

---

## **Objectif**

Le **`TaskValidationTrigger`** applique des règles métier sur l'objet **`Task`** pour garantir l'intégrité des données lors de l'insertion et de la mise à jour.  
Les validations incluent la vérification de champs obligatoires, des valeurs autorisées et des relations d'enregistrement.

---

## **Trigger Logic**

### **Événements Gérés :**
- **Before Insert**
- **Before Update**

### **Règles Appliquées :**

1. **Validation du Sujet (`Subject`)**
   - **Condition :** Le champ `Subject` est obligatoire.
   - **Message :** *"Le sujet de la tâche est obligatoire."*

2. **Validation de la Date d'Activité (`ActivityDate`)**
   - **Condition :** La date d'activité doit être **aujourd'hui ou dans le futur**.
   - **Message :** *"La date de l'activité doit être aujourd'hui ou dans le futur."*

3. **Validation de la Priorité (`Priority`)**
   - **Condition :** La priorité doit être **`High`**, **`Medium`** ou **`Low`**.
   - **Message :** *"La priorité doit être 'High', 'Medium' ou 'Low'."*

4. **Validation des Relations (`WhatId` et `WhoId`)**
   - **Condition :** Au moins un des champs **`WhatId`** (relation avec un objet) ou **`WhoId`** (relation avec une personne) doit être défini.
   - **Message :** *"La tâche doit être associée à un enregistrement via WhatId ou WhoId."*

5. **Validation des Tâches Marquées "Completed"**
   - **Condition :** Une tâche avec une date d'activité dans le futur ne peut pas être marquée comme **`Completed`**.
   - **Message :** *"Une tâche avec une date d'activité dans le futur ne peut pas être marquée comme 'Completed'."*

---

## **Code Complet**

```apex
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
