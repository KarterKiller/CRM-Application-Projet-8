# Explication du code : TripValidationTriggerTest

Ce fichier explique la classe de test Apex `TripValidationTriggerTest`, qui valide les règles de validation mises en œuvre par le déclencheur `TripValidationTrigger` pour les objets personnalisés `Trip__c`.

## Déclaration de la classe
```java
@isTest
public class TripValidationTriggerTest {
```
Cette classe est déclarée avec l'annotation `@isTest`, indiquant qu'elle contient des méthodes de test.

---

## Méthode : `testValidationOnInsertNameEmpty`
### Description
Teste l'insertion d'un voyage avec un nom vide.

### Étapes
1. Crée un compte valide en utilisant `TestDataFactory`.
2. Initialise un voyage avec un nom vide.
3. Tente d'insérer le voyage et vérifie qu'une exception est levée.

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur correspond à la validation (le nom est obligatoire).

---

## Méthode : `testValidationOnInsertDatesInvalid`
### Description
Teste l'insertion d'un voyage avec des dates invalides (date de fin antérieure à la date de début).

### Étapes
1. Crée un compte valide.
2. Initialise un voyage avec une date de fin avant la date de début.
3. Tente d'insérer le voyage et vérifie qu'une exception est levée.

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur correspond à la validation (date de fin après date de début).

---

## Méthode : `testValidationOnInsertCostNegative`
### Description
Teste l'insertion d'un voyage avec un coût total négatif.

### Étapes
1. Crée un compte valide.
2. Initialise un voyage avec un coût total négatif.
3. Tente d'insérer le voyage et vérifie qu'une exception est levée.

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur correspond à la validation (coût positif).

---

## Méthode : `testSuccessfulInsert`
### Description
Teste l'insertion réussie d'un voyage valide.

### Étapes
1. Crée un compte valide.
2. Initialise un voyage avec des données valides (nom, coût, statut).
3. Insère le voyage et vérifie qu'aucune erreur n'est levée.

### Assertions
- Vérifie que l'identifiant du voyage n'est pas `null` après l'insertion.

---

## Méthode : `testSuccessfulUpdate`
### Description
Teste la mise à jour réussie d'un voyage.

### Étapes
1. Crée un compte valide.
2. Insère un voyage valide.
3. Met à jour le statut du voyage (par exemple, à "Annulé").
4. Vérifie que la mise à jour a réussi.

### Assertions
- Vérifie que le statut du voyage est mis à jour correctement.

---

## Résumé
Cette classe de test valide les règles suivantes :
1. Le nom d'un voyage ne peut pas être vide.
2. Les dates d'un voyage doivent être valides (date de fin après date de début).
3. Le coût total d'un voyage ne peut pas être négatif.
4. Les voyages valides peuvent être insérés sans erreur.
5. Les voyages peuvent être mis à jour avec succès.

Ces tests garantissent que le déclencheur `TripValidationTrigger` applique correctement les validations sur les objets `Trip__c`.
