# Explication du code : OpportunityValidationTriggerTest

Ce fichier explique la classe de test Apex `OpportunityValidationTriggerTest`, qui vérifie les validations mises en œuvre dans le déclencheur des opportunités dans Salesforce.

## Déclaration de la classe
```java
@isTest
public class OpportunityValidationTriggerTest {
```
Cette classe est déclarée avec l'annotation `@isTest`, indiquant qu'elle contient des méthodes de test.

## Méthode : `testValidationOnInsert`
### Description
Teste les validations déclenchées lors de l'insertion d'une opportunité.

### Étapes
1. Crée un compte valide en utilisant `TestDataFactory.createAccount`.
2. Crée une opportunité avec un montant négatif pour provoquer une erreur.
3. Tente d'insérer l'opportunité et vérifie qu'une exception est levée.

### Code
```java
@isTest
static void testValidationOnInsert() {
    ...
}
```

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée pour un montant négatif.
- Vérifie que le message d'erreur correspond à la validation.

---

## Méthode : `testValidationOnUpdate`
### Description
Teste les validations déclenchées lors de la mise à jour d'une opportunité.

### Étapes
1. Crée un compte et une opportunité valides via `TestDataFactory`.
2. Modifie les dates de l'opportunité pour rendre la date de fin antérieure à la date de début.
3. Tente de mettre à jour l'opportunité et vérifie qu'une exception est levée.

### Code
```java
@isTest
static void testValidationOnUpdate() {
    ...
}
```

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée pour des dates invalides.
- Vérifie que le message d'erreur correspond à la validation.

---

## Méthode : `testValidationForClosedWon`
### Description
Teste les validations spécifiques à une opportunité passant à l'étape "Closed Won".

### Étapes
1. Crée un compte et deux opportunités valides via `TestDataFactory`.
2. Premier cas : met à jour une opportunité valide avec "Closed Won" et vérifie que l'opération réussit.
3. Deuxième cas : met à jour une opportunité avec un montant invalide pour "Closed Won" et vérifie qu'une exception est levée.

### Code
```java
@isTest
static void testValidationForClosedWon() {
    ...
}
```

### Assertions
- **Premier cas** : Vérifie qu'aucune exception n'est levée pour une opportunité valide passant à "Closed Won".
- **Deuxième cas** : Vérifie qu'une exception de type `DmlException` est levée pour un montant invalide, avec un message d'erreur approprié.

---

## Résumé
Cette classe de test valide :
1. Les validations lors de l'insertion d'une opportunité (par exemple, montant négatif).
2. Les validations lors de la mise à jour d'une opportunité (par exemple, dates invalides).
3. Les validations spécifiques à l'étape "Closed Won" (par exemple, montant obligatoire).

Grâce à ces tests, on garantit que le déclencheur des opportunités applique correctement les règles de validation définies pour Salesforce.
