# TaskValidationTriggerTest

---

## **Objectif**

La classe **`TaskValidationTriggerTest`** contient des tests unitaires pour valider les règles métier appliquées par le **`TaskValidationTrigger`**.  
Ces tests garantissent le bon fonctionnement des validations lors de l'insertion et de la mise à jour des enregistrements de type **Task**.

---

## **Tests Couvertures**

### **1. Test de Validation à l'Insertion (`testValidationOnInsert`)**

#### **Scénarios Validés :**
1. **Sujet vide :**
   - **Condition :** Le champ `Subject` est vide.
   - **Message d'erreur attendu :** *"Le sujet de la tâche est obligatoire."*

2. **Date d'activité dans le passé :**
   - **Condition :** La date d'activité `ActivityDate` est antérieure à aujourd'hui.
   - **Message d'erreur attendu :** *"La date de l'activité doit être aujourd'hui ou dans le futur."*

#### **Code :**
```apex
@isTest
static void testValidationOnInsert() {
    Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
    insert acc;

    // Test avec un sujet vide
    Task task = new Task(
        Subject = '',
        Priority = 'High',
        ActivityDate = Date.today().addDays(1),
        WhatId = acc.Id
    );

    try {
        insert task;
        System.assert(false, 'L\'insertion aurait dû échouer en raison d\'un sujet vide.');
    } catch (DmlException e) {
        System.assert(e.getMessage().contains('Le sujet de la tâche est obligatoire.'), 'Message d\'erreur inattendu.');
    }

    // Test avec une date d'activité passée
    task.Subject = 'Test Task';
    task.ActivityDate = Date.today().addDays(-1);

    try {
        insert task;
        System.assert(false, 'L\'insertion aurait dû échouer en raison d\'une date d\'activité passée.');
    } catch (DmlException e) {
        System.assert(e.getMessage().contains('La date de l\'activité doit être aujourd\'hui ou dans le futur.'), 'Message d\'erreur inattendu.');
    }
}
