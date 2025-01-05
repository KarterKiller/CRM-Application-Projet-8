# Explication du code : OpportunityTriggerHandler

Ce fichier explique le fonctionnement de la classe Apex `OpportunityTriggerHandler`, utilisée pour gérer des opportunités dans Salesforce. La méthode principale, `createTripAndContractForClosedWon`, permet de créer un voyage (Trip) et un contrat (Contract) lorsqu'une opportunité passe à l'étape **Closed Won**.

## Déclaration de la classe
```java
public with sharing class OpportunityTriggerHandler {
```
Cette classe est déclarée avec le mot-clé `with sharing`, ce qui signifie qu'elle respecte les règles de partage définies dans Salesforce.

## Méthode principale : `createTripAndContractForClosedWon`
### Description
La méthode `createTripAndContractForClosedWon` gère la création de deux objets Salesforce personnalisés :
- `Trip__c` : représente un voyage.
- `Contract` : représente un contrat.

### Paramètres
- `newOpps` : une liste des opportunités mises à jour.
- `oldOppMap` : une carte (Map) contenant les anciennes valeurs des opportunités, associées à leur identifiant.

### Étapes de traitement

#### Initialisation des listes pour les insertions
```java
List<Trip__c> tripsToInsert = new List<Trip__c>();
List<Contract> contractsToInsert = new List<Contract>();
```
Des listes sont créées pour collecter les objets à insérer ultérieurement dans Salesforce.

#### Parcours des nouvelles opportunités
```java
for (Opportunity opp : newOpps) {
```
Chaque opportunité de la liste `newOpps` est analysée.

#### Récupération de l'ancienne opportunité
```java
Opportunity oldOpp = oldOppMap != null ? oldOppMap.get(opp.Id) : null;
```
On récupère l'ancienne version de l'opportunité depuis `oldOppMap`. Si aucune ancienne opportunité n'existe, la valeur par défaut est `null`.

#### Vérification des conditions pour la création
1. **L'opportunité passe à "Closed Won"**
   ```java
   if (opp.StageName == 'Closed Won' && (oldOpp == null || oldOpp.StageName != 'Closed Won')) {
   ```
   La méthode vérifie que l'opportunité est passée à l'étape "Closed Won" et qu'elle n'y était pas auparavant.

2. **Tous les champs nécessaires sont remplis**
   ```java
   if (opp.StartTripDate__c != null && opp.EndTripDate__c != null &&
       opp.Destination__c != null && opp.Number_of_Participants__c != null && opp.Amount != null) {
   ```
   Tous les champs obligatoires (dates, destination, participants, montant) doivent être renseignés.

#### Création d'un voyage (`Trip__c`)
```java
Trip__c trip = new Trip__c(
    Name = 'Trip - ' + opp.Destination__c + ' - ' + opp.StartTripDate__c.format(),
    Status__c = 'A venir',
    Destination__c = opp.Destination__c,
    StartTripDate__c = opp.StartTripDate__c,
    EndTripDate__c = opp.EndTripDate__c,
    Number_of_Participants__c = opp.Number_of_Participants__c,
    Total_Cost__c = opp.Amount,
    Account__c = opp.AccountId,
    Opportunity__c = opp.Id
);
tripsToInsert.add(trip);
```
Un objet `Trip__c` est créé et ajouté à la liste `tripsToInsert`.

#### Création d'un contrat (`Contract`)
```java
Contract contract = new Contract(
    Name = 'Contract for ' + opp.Name,
    AccountId = opp.AccountId,
    Opportunity__c = opp.Id,
    StartTripDate__c = opp.StartTripDate__c,
    EndTripDate__c = opp.EndTripDate__c,
    Amount__c = opp.Amount,
    Destination__c = opp.Destination__c,
    Number_of_Participants__c = opp.Number_of_Participants__c,
    Status = 'Draft'
);
contractsToInsert.add(contract);
```
Un objet `Contract` est créé et ajouté à la liste `contractsToInsert`.

#### Gestion des erreurs
Si des champs obligatoires ne sont pas renseignés, une erreur est ajoutée à l'opportunité :
```java
opp.addError('Impossible de créer le voyage et le contrat. Tous les champs obligatoires ne sont pas remplis.');
```

#### Insertion des objets dans Salesforce
1. **Insertion des voyages**
   ```java
   if (!tripsToInsert.isEmpty()) {
       try {
           insert tripsToInsert;
       } catch (DmlException e) {
           System.debug('Erreur lors de l\'insertion des voyages : ' + e.getMessage());
           throw e;
       }
   }
   ```
   Les objets `Trip__c` sont insérés. Toute erreur lors de l'insertion est capturée et affichée dans les logs.

2. **Insertion des contrats**
   ```java
   if (!contractsToInsert.isEmpty()) {
       try {
           insert contractsToInsert;
       } catch (DmlException e) {
           System.debug('Erreur lors de l\'insertion des contrats : ' + e.getMessage());
           throw e;
       }
   }
   ```
   Les objets `Contract` sont insérés avec une gestion similaire des erreurs.

## Résumé
Cette classe vérifie les opportunités mises à jour, et si elles remplissent les conditions nécessaires, elle crée et insère des voyages et des contrats associés. Elle s'assure que les données sont complètes avant l'insertion et gère les erreurs potentielles de manière robuste.
