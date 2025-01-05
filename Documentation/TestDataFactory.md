# Explication du code : TestDataFactory

Ce fichier explique la classe Apex `TestDataFactory`, qui est utilisée pour générer des données de test dans Salesforce. Cette classe permet de créer divers objets avec des données factices, pouvant être insérés dans la base de données selon les besoins.

## Déclaration de la classe
```java
@isTest
public class TestDataFactory {
```
La classe est marquée avec l'annotation `@isTest`, indiquant qu'elle est utilisée exclusivement pour les tests.

---

## Méthodes principales

### `createAccount`
#### Description
Crée un compte (`Account`) avec des données factices.

#### Paramètres
- `insertRecord` : Si `true`, le compte est inséré dans la base de données.

#### Exemple
```java
Account acc = TestDataFactory.createAccount(true);
```

---

### `createOpportunity`
#### Description
Crée une opportunité (`Opportunity`) liée à un compte.

#### Paramètres
- `accountId` : L'identifiant du compte auquel l'opportunité est associée.
- `insertRecord` : Si `true`, l'opportunité est insérée dans la base de données.

#### Validation
Lève une exception si `accountId` est `null`.

#### Exemple
```java
Opportunity opp = TestDataFactory.createOpportunity(accountId, true);
```

---

### `createContract`
#### Description
Crée un contrat (`Contract`) lié à un compte.

#### Paramètres
- `accountId` : L'identifiant du compte auquel le contrat est associé.
- `insertRecord` : Si `true`, le contrat est inséré dans la base de données.

#### Validation
Lève une exception si `accountId` est `null`.

#### Exemple
```java
Contract con = TestDataFactory.createContract(accountId, true);
```

---

### `createTask`
#### Description
Crée une tâche (`Task`) pouvant être associée à un objet et/ou une personne.

#### Paramètres
- `whatId` : L'identifiant de l'objet lié (par exemple, un compte ou une opportunité).
- `whoId` : L'identifiant de la personne liée (par exemple, un contact ou un lead).
- `insertRecord` : Si `true`, la tâche est insérée dans la base de données.

#### Exemple
```java
Task task = TestDataFactory.createTask(whatId, whoId, true);
```

---

### `createTrip`
#### Description
Crée un voyage (`Trip__c`) lié à un compte.

#### Paramètres
- `accountId` : L'identifiant du compte auquel le voyage est associé.
- `insertRecord` : Si `true`, le voyage est inséré dans la base de données.

#### Validation
Lève une exception si `accountId` est `null`.

#### Exemple
```java
Trip__c trip = TestDataFactory.createTrip(accountId, true);
```

---

### `createContact`
#### Description
Crée un contact (`Contact`) lié à un compte.

#### Paramètres
- `accountId` : L'identifiant du compte auquel le contact est associé.
- `insertRecord` : Si `true`, le contact est inséré dans la base de données.

#### Validation
Lève une exception si `accountId` est `null`.

#### Exemple
```java
Contact con = TestDataFactory.createContact(accountId, true);
```

---

## Résumé
La classe `TestDataFactory` fournit des méthodes utilitaires pour :
1. Générer des données de test standardisées pour les objets Salesforce.
2. Simplifier les tests en réduisant les doublons dans le code.
3. Permettre l'insertion conditionnelle des enregistrements.

Elle suit les bonnes pratiques pour garantir des tests robustes et maintenables.
