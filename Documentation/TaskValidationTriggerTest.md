# Explication du code : TaskValidationTriggerTest

Ce fichier explique la classe de test Apex `TaskValidationTriggerTest`, qui valide les règles de validation mises en œuvre par le déclencheur `TaskValidationTrigger` pour les tâches (`Task`) dans Salesforce.

## Déclaration de la classe
```java
@isTest
public class TaskValidationTriggerTest {
```
Cette classe est déclarée avec l'annotation `@isTest`, indiquant qu'elle contient des méthodes de test.

---

## Méthode : `testValidationOnInsertSubjectEmpty`
### Description
Teste l'insertion d'une tâche avec un sujet vide.

### Étapes
1. Crée un compte et un contact de test via `TestDataFactory`.
2. Initialise une tâche avec un sujet vide.
3. Tente d'insérer la tâche et vérifie qu'une exception est levée.

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur correspond à la validation (le sujet est obligatoire).

---

## Méthode : `testValidationOnInsertActivityDatePast`
### Description
Teste l'insertion d'une tâche avec une date d'activité passée.

### Étapes
1. Crée un compte et un contact de test via `TestDataFactory`.
2. Initialise une tâche avec une date d'activité dans le passé.
3. Tente d'insérer la tâche et vérifie qu'une exception est levée.

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur correspond à la validation (la date d'activité doit être dans le futur ou aujourd'hui).

---

## Méthode : `testValidationOnInsertMissingWhoIdAndWhatId`
### Description
Teste l'insertion d'une tâche sans `WhoId` ni `WhatId`.

### Étapes
1. Initialise une tâche sans `WhoId` ni `WhatId`.
2. Tente d'insérer la tâche et vérifie qu'une exception est levée.

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur correspond à la validation (une tâche doit être associée à un enregistrement).

---

## Méthode : `testValidationOnUpdateInvalidPriority`
### Description
Teste la mise à jour d'une tâche avec une priorité invalide.

### Étapes
1. Crée et insère une tâche valide via `TestDataFactory`.
2. Modifie la priorité de la tâche avec une valeur invalide.
3. Tente de mettre à jour la tâche et vérifie qu'une exception est levée.

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur correspond à la validation (priorité invalide).

---

## Méthode : `testValidationOnUpdateCompletedStatusWithFutureDate`
### Description
Teste la mise à jour d'une tâche avec le statut "Completed" et une date d'activité dans le futur.

### Étapes
1. Crée et insère une tâche valide via `TestDataFactory`.
2. Modifie le statut à "Completed" et définit une date future.
3. Tente de mettre à jour la tâche et vérifie qu'une exception est levée.

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur correspond à la validation (date future incompatible avec "Completed").

---

## Résumé
Cette classe de test valide les règles suivantes :
1. Le sujet d'une tâche ne peut pas être vide.
2. La date d'activité d'une tâche ne peut pas être dans le passé.
3. Une tâche doit être associée à un enregistrement via `WhoId` ou `WhatId`.
4. La priorité d'une tâche doit être "High", "Medium" ou "Low".
5. Une tâche avec une date future ne peut pas avoir le statut "Completed".

Grâce à ces tests, on garantit que les règles de validation appliquées par le déclencheur `TaskValidationTrigger` fonctionnent comme prévu.
