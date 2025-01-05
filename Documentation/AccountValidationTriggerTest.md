# Explication du code : AccountValidationTriggerTest

Ce fichier explique la classe de test Apex `AccountValidationTriggerTest`, qui valide les règles de validation mises en œuvre par le déclencheur `AccountValidationTrigger`.

## Déclaration de la classe
```java
@isTest
public class AccountValidationTriggerTest {
```
Cette classe est marquée avec l'annotation `@isTest`, indiquant qu'elle est exclusivement utilisée pour les tests.

---

## Méthodes principales

### `testAccountNameValidation`
#### Description
Teste la validation du champ **Nom** d'un compte (`Account`).

#### Étapes
1. Crée un compte sans nom en utilisant `TestDataFactory`.
2. Tente d'insérer le compte et vérifie qu'une exception est levée.

#### Assertions
- Vérifie que l'exception est de type `DmlException`.
- Vérifie que le message d'erreur correspond à la validation (le nom est obligatoire).

---

### `testPhoneValidation`
#### Description
Teste la validation du champ **Numéro de téléphone** d'un compte (`Account`).

#### Étapes
1. Crée un compte avec un numéro de téléphone invalide.
2. Tente d'insérer le compte et vérifie qu'une exception est levée.

#### Assertions
- Vérifie que l'exception est de type `DmlException`.
- Vérifie que le message d'erreur correspond à la validation (numéro de téléphone obligatoire et au format valide).

---

### `testStatusValidation`
#### Description
Teste la validation du champ personnalisé **Active__c** d'un compte (`Account`).

#### Étapes
1. Crée un compte avec un statut inactif (`Active__c = 'No'`).
2. Tente d'insérer le compte et vérifie qu'une exception est levée.

#### Assertions
- Vérifie que l'exception est de type `DmlException`.
- Vérifie que le message d'erreur correspond à la validation (statut "Yes" obligatoire).

---

## Résumé
Cette classe de test valide les règles suivantes :
1. **Nom obligatoire** : Le champ `Name` d'un compte ne peut pas être vide.
2. **Numéro de téléphone valide** : Le champ `Phone` doit contenir exactement 10 chiffres.
3. **Statut actif obligatoire** : Le champ personnalisé `Active__c` doit avoir la valeur "Yes".

Ces tests garantissent que les validations implémentées dans `AccountValidationTrigger` fonctionnent comme prévu, en empêchant l'insertion de comptes non conformes aux règles métier.
