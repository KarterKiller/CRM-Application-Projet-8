# Explication du code : ContractTriggerTest

Ce fichier explique la classe de test Apex `ContractTriggerTest`, qui valide les règles de validation mises en œuvre par le déclencheur `ContractTrigger` pour les contrats (`Contract`).

## Déclaration de la classe
```java
@isTest
public class ContractTriggerTest {
```
Cette classe est marquée avec l'annotation `@isTest`, indiquant qu'elle est exclusivement utilisée pour les tests.

---

## Méthodes principales

### `testValidationOnInsertNegativeAmount`
#### Description
Teste l'insertion d'un contrat avec un montant négatif.

#### Étapes
1. Crée un compte valide via `TestDataFactory`.
2. Initialise un contrat avec un montant négatif.
3. Tente d'insérer le contrat et vérifie qu'une exception est levée.

#### Assertions
- Vérifie que l'exception est de type `DmlException`.
- Vérifie que le message d'erreur correspond à la validation (montant positif requis).

---

### `testValidationOnInsertZeroParticipants`
#### Description
Teste l'insertion d'un contrat avec un nombre de participants égal à zéro.

#### Étapes
1. Crée un compte valide via `TestDataFactory`.
2. Initialise un contrat avec un nombre de participants invalide.
3. Tente d'insérer le contrat et vérifie qu'une exception est levée.

#### Assertions
- Vérifie que l'exception est de type `DmlException`.
- Vérifie que le message d'erreur correspond à la validation (participants > 0 requis).

---

### `testValidationOnInsertInvalidDates`
#### Description
Teste l'insertion d'un contrat avec une date de fin antérieure à la date de début.

#### Étapes
1. Crée un compte valide via `TestDataFactory`.
2. Initialise un contrat avec des dates invalides.
3. Tente d'insérer le contrat et vérifie qu'une exception est levée.

#### Assertions
- Vérifie que l'exception est de type `DmlException`.
- Vérifie que le message d'erreur correspond à la validation (date de fin après date de début).

---

### `testValidationOnDelete`
#### Description
Teste la suppression d'un contrat actif.

#### Étapes
1. Crée un contrat valide et modifie son statut à "Activated".
2. Tente de supprimer le contrat et vérifie qu'une exception est levée.

#### Assertions
- Vérifie que l'exception est de type `DmlException`.
- Vérifie que le message d'erreur correspond à la validation (contrat actif non supprimable).

---

### `testValidationOnValidInsert`
#### Description
Teste l'insertion réussie d'un contrat valide.

#### Étapes
1. Crée un contrat avec des données valides.
2. Insère le contrat et vérifie qu'aucune exception n'est levée.

#### Assertions
- Vérifie que le contrat est inséré correctement en recherchant son identifiant.

---

### `testValidationOnInsertMissingDates`
#### Description
Teste l'insertion d'un contrat avec des dates de début et de fin manquantes.

#### Étapes
1. Crée un compte valide via `TestDataFactory`.
2. Initialise un contrat sans dates.
3. Tente d'insérer le contrat et vérifie qu'une exception est levée.

#### Assertions
- Vérifie que l'exception est de type `DmlException`.
- Vérifie que le message d'erreur correspond à la validation (dates obligatoires).

---

## Résumé
Cette classe de test valide les règles suivantes :
1. **Montant positif requis** : Le champ `Amount__c` doit être supérieur à 0.
2. **Participants > 0 requis** : Le champ `Number_of_Participants__c` doit être supérieur à 0.
3. **Dates valides** : La date de fin doit être postérieure à la date de début.
4. **Contrat actif non supprimable** : Un contrat avec le statut "Activated" ne peut pas être supprimé.
5. **Insertion réussie pour des données valides**.
6. **Dates obligatoires** : Les champs `StartTripDate__c` et `EndTripDate__c` sont obligatoires.

Ces tests garantissent que les validations implémentées dans `ContractTrigger` fonctionnent comme prévu, empêchant les manipulations non conformes des contrats.
