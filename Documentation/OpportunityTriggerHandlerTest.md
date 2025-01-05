# Explication du code : OpportunityTriggerHandlerTest

Ce fichier explique la classe de test Apex `OpportunityTriggerHandlerTest`, qui valide le bon fonctionnement de la classe `OpportunityTriggerHandler` utilisée pour gérer les opportunités dans Salesforce.

## Déclaration de la classe
```java
@isTest
public class OpportunityTriggerHandlerTest {
```
Cette classe est déclarée avec l'annotation `@isTest`, indiquant qu'elle contient des méthodes de test.

## Méthode utilitaire : `createTestAccount`
### Description
Crée un compte Salesforce de test avec des données factices.

### Code
```java
private static Account createTestAccount() {
    Account acc = new Account(
        Name = 'Test Account',
        Industry = 'Technology',
        Active__c = 'Yes',
        Phone = '0123456789'
    );
    insert acc;
    return acc;
}
```
Cette méthode est utilisée pour initialiser un compte de test dans les autres méthodes.

---

## Méthode : `testValidateOpportunity_ValidOpportunity`
### Description
Teste l'insertion d'une opportunité valide.

### Étapes
1. Crée un compte de test avec `createTestAccount`.
2. Initialise une opportunité valide avec des données complètes.
3. Insère l'opportunité dans une transaction de test.
4. Vérifie que l'opportunité a été insérée correctement.

### Code
```java
@isTest
static void testValidateOpportunity_ValidOpportunity() {
    ...
}
```

### Assertions
- Vérifie que l'identifiant de l'opportunité n'est pas `null` après l'insertion.

---

## Méthode : `testValidateOpportunity_InvalidOpportunity`
### Description
Teste l'insertion d'une opportunité invalide (données manquantes ou incorrectes).

### Étapes
1. Crée un compte de test.
2. Initialise une opportunité avec des erreurs (montant négatif, participants invalides).
3. Tente d'insérer l'opportunité et vérifie que l'insertion échoue avec une exception.

### Code
```java
@isTest
static void testValidateOpportunity_InvalidOpportunity() {
    ...
}
```

### Assertions
- Vérifie qu'une exception de type `DmlException` est levée.
- Vérifie que le message d'erreur est correct.

---

## Méthode : `testCreateTripAndContractForClosedWon`
### Description
Teste la méthode principale `createTripAndContractForClosedWon` de la classe `OpportunityTriggerHandler`.

### Étapes
1. Crée un compte de test.
2. Insère une opportunité avec un statut initial "Prospecting".
3. Met à jour le statut de l'opportunité à "Closed Won".
4. Vérifie que :
   - Un objet `Trip__c` a été créé.
   - Un objet `Contract` a été créé.

### Code
```java
@isTest
static void testCreateTripAndContractForClosedWon() {
    ...
}
```

### Assertions
- **Voyage (`Trip__c`)** :
  - Vérifie qu'un voyage a été créé.
  - Vérifie que le statut du voyage est "A venir".

- **Contrat (`Contract`)** :
  - Vérifie qu'un contrat a été créé.
  - Vérifie que le statut du contrat est "Draft".

---

## Résumé
Cette classe de test valide :
1. La création correcte des opportunités avec des données valides.
2. La gestion des erreurs pour des opportunités invalides.
3. La création automatique des voyages et des contrats lorsque les opportunités passent à "Closed Won".

Grâce à ces tests, on garantit que la classe `OpportunityTriggerHandler` fonctionne comme prévu et répond aux exigences métier.
