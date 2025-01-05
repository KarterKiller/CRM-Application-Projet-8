# Explication du code : SalesTrackingController

Ce fichier explique la classe Apex `SalesTrackingController`, conçue pour récupérer et retourner des données liées aux comptes, opportunités et contrats sous une structure personnalisée.

## Déclaration de la classe
```java
public with sharing class SalesTrackingController {
```
- **`with sharing`** : Respecte les règles de partage définies pour l'utilisateur courant.
- La classe est accessible globalement.

---

## Méthode principale : `getSalesData`

### Annotation
```java
@AuraEnabled(cacheable=true)
```
- **`@AuraEnabled`** : Rend la méthode accessible depuis des composants Lightning ou LWC.
- **`cacheable=true`** : Indique que les données peuvent être mises en cache pour des performances optimales.

### Fonctionnalité
Récupère une liste de données consolidées (comptes, opportunités et contrats) et les retourne sous une structure personnalisée `SalesData`.

### Étapes principales

#### 1. Requête SOQL
```java
List<Account> accounts = [
    SELECT 
        Id, 
        Name, 
        CreatedDate,
        (SELECT Id, Amount, StageName FROM Opportunities WHERE StageName IN ('Closed Won', 'Negotiation')),
        (SELECT Id, EndDate, Conditions__c, Status FROM Contracts WHERE EndDate > :Date.today())
    FROM Account
    LIMIT 10
];
```
- Récupère les comptes avec leurs opportunités et contrats liés.
- Critères :
  - Opportunités dans les étapes "Closed Won" ou "Negotiation".
  - Contrats dont la date de fin est postérieure à aujourd'hui.
- Limite : 10 comptes.

#### 2. Transformation des données
Pour chaque compte, les données sont mappées dans un objet personnalisé `SalesData` :

##### Compte
```java
salesRecord.accountId = acc.Id;
salesRecord.accountName = acc.Name;
salesRecord.accountCreatedDate = acc.CreatedDate.date();
```
- ID, nom et date de création (convertie en `Date`) du compte.

##### Opportunité
```java
if (!acc.Opportunities.isEmpty()) {
    Opportunity opp = acc.Opportunities[0];
    salesRecord.opportunityAmount = opp.Amount;
    salesRecord.opportunityStatus = opp.StageName;
}
```
- Si une opportunité est liée, récupère le montant et le statut de la première opportunité.

##### Contrat
```java
if (!acc.Contracts.isEmpty()) {
    Contract contract = acc.Contracts[0];
    salesRecord.endDate = contract.EndDate;
    salesRecord.conditions = contract.Conditions__c;
    salesRecord.contractStatus = contract.Status;
}
```
- Si un contrat est lié, récupère la date de fin, les conditions et le statut du premier contrat.

#### 3. Ajout à la liste des résultats
```java
results.add(salesRecord);
```
Chaque `SalesData` est ajouté à la liste de résultats.

### Retour
La méthode retourne une liste de `SalesData` contenant les données consolidées pour chaque compte.

---

## Classe interne : `SalesData`

### Description
Un objet personnalisé conçu pour structurer les données à retourner.

### Champs
- **Compte**
  - `accountId` : ID du compte.
  - `accountName` : Nom du compte.
  - `accountCreatedDate` : Date de création du compte.
- **Opportunité**
  - `opportunityAmount` : Montant de l'opportunité.
  - `opportunityStatus` : Statut de l'opportunité.
- **Contrat**
  - `endDate` : Date de fin du contrat.
  - `conditions` : Conditions spécifiques au contrat.
  - `contractStatus` : Statut du contrat.

### Annotation
Tous les champs sont marqués avec `@AuraEnabled`, rendant les données accessibles dans des composants Lightning ou LWC.

---

## Résumé
La classe `SalesTrackingController` :
1. Effectue une requête consolidée pour récupérer les comptes et leurs données associées (opportunités et contrats).
2. Transforme les données dans un format structuré (`SalesData`).
3. Retourne les résultats pour une utilisation efficace dans des interfaces utilisateur.

Cette approche garantit des performances optimales et une structure de données claire pour les consommateurs des données.
