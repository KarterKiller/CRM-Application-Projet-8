# Explication du code : ValidationHelper

Ce fichier explique la classe Apex `ValidationHelper`, qui centralise les règles de validation pour différents objets Salesforce. Ces validations garantissent que les enregistrements respectent les règles métier avant d'être insérés, mis à jour ou supprimés.

## Déclaration de la classe
```java
public with sharing class ValidationHelper {
```
- **`with sharing`** : Applique les règles de partage Salesforce lors de l'exécution de la classe.

---

## Méthodes de Validation

### 1. `validateAccount`
#### Description
Valide les règles métier pour les objets `Account`.

#### Points vérifiés
- **Nom obligatoire** :
  ```java
  if (String.isBlank(acc.Name)) {
      acc.addError('Le nom du compte est obligatoire.');
  }
  ```
- **Industrie obligatoire** :
  ```java
  if ((oldAcc == null || oldAcc.Industry != acc.Industry) && String.isBlank(acc.Industry)) {
      acc.addError('Le champ "Industry" est obligatoire.');
  }
  ```
- **Numéro de téléphone valide (10 chiffres)** :
  ```java
  if (String.isBlank(acc.Phone) || !Pattern.matches('\\d{10}', acc.Phone)) {
      acc.addError('Le numéro de téléphone est obligatoire et doit contenir exactement 10 chiffres.');
  }
  ```
- **Champ `Active__c` avec valeur "Yes"** :
  ```java
  if (String.isBlank(acc.Active__c) || acc.Active__c != 'Yes') {
      acc.addError('Le champ "Active__c" est obligatoire et doit avoir la valeur "Yes".');
  }
  ```

---

### 2. `validateContractInsert`
#### Description
Valide les règles métier lors de l'insertion d'un contrat (`Contract`).

#### Points vérifiés
- **Montant positif** :
  ```java
  if (con.Amount__c == null || con.Amount__c <= 0) {
      con.addError('Le montant du contrat doit être supérieur à 0.');
  }
  ```
- **Participants > 0** :
  ```java
  if (con.Number_of_Participants__c == null || con.Number_of_Participants__c <= 0) {
      con.addError('Le nombre de participants doit être supérieur à 0.');
  }
  ```
- **Dates valides** :
  ```java
  if (con.StartTripDate__c == null || con.EndTripDate__c == null || con.EndTripDate__c <= con.StartTripDate__c) {
      con.addError('Les dates de début et de fin du voyage sont obligatoires et la date de fin doit être postérieure à la date de début.');
  }
  ```

---

### 3. `validateContractUpdate`
#### Description
Valide les règles métier lors de la mise à jour d'un contrat.

#### Points vérifiés
- **Montant et participants positifs** : Même logique que pour `validateContractInsert`.
- **Modification interdite pour les contrats signés** :
  ```java
  if (oldCon != null && oldCon.Status == 'Signed' && con.Status != 'Signed') {
      con.addError('Un contrat signé ne peut pas être modifié.');
  }
  ```

---

### 4. `validateContractDelete`
#### Description
Valide les règles métier lors de la suppression d'un contrat.

#### Points vérifiés
- **Contrat actif non supprimable** :
  ```java
  if (con.Status == 'Activated') {
      con.addError('Un contrat actif ne peut pas être supprimé.');
  }
  ```

---

### 5. `validateTask`
#### Description
Valide les règles métier pour les tâches (`Task`).

#### Points vérifiés
- **Sujet obligatoire** :
  ```java
  if (String.isBlank(task.Subject)) {
      task.addError('Le sujet de la tâche est obligatoire.');
  }
  ```
- **Date d'activité valide** :
  ```java
  if (task.ActivityDate != null && task.ActivityDate < Date.today()) {
      task.addError('La date de l'activité doit être aujourd'hui ou dans le futur.');
  }
  ```
- **Priorité valide** :
  ```java
  if (task.Priority != 'High' && task.Priority != 'Medium' && task.Priority != 'Low') {
      task.addError('La priorité doit être "High", "Medium" ou "Low".');
  }
  ```
- **Lien avec un enregistrement** :
  ```java
  if (task.WhatId == null && task.WhoId == null) {
      task.addError('La tâche doit être associée à un enregistrement via WhatId ou WhoId.');
  }
  ```
- **Statut "Completed" interdit avec une date future** :
  ```java
  if (task.Status == 'Completed' && task.ActivityDate > Date.today()) {
      task.addError('Une tâche avec une date d'activité dans le futur ne peut pas être marquée comme "Completed".');
  }
  ```

---

### 6. `validateOpportunity`
#### Description
Valide les règles métier pour les opportunités (`Opportunity`).

#### Points vérifiés
- **Montant, dates, compte, nom, destination, participants** : Vérifications similaires à celles pour `Contract`.

---

### 7. `validateTrip`
#### Description
Valide les règles métier pour les voyages (`Trip__c`).

#### Points vérifiés
- **Nom, statut, coût total, dates, compte** : Vérifications similaires à celles pour `Contract`.
- **Statut "Terminé" avec une date future** :
  ```java
  if (trip.Status__c == 'Terminé' && trip.EndTripDate__c > Date.today()) {
      trip.addError('Un voyage avec une date de fin dans le futur ne peut pas être marqué comme "Terminé".');
  }
  ```

---

## Résumé
La classe `ValidationHelper` centralise les règles de validation pour divers objets Salesforce, rendant les triggers plus simples et maintenables. Chaque méthode applique des vérifications spécifiques aux objets concernés, garantissant ainsi que les enregistrements respectent les règles métier avant toute manipulation dans Salesforce.
