# TripService

## Description
`TripService` gère les opérations CRUD et les validations métiers pour l'objet personnalisé `Trip__c`. Cette classe permet de créer, lire, mettre à jour et supprimer des voyages, tout en s'assurant que les règles métier spécifiques sont respectées.

---

## Fonctionnalités principales

1. **createTrip** : Crée un nouveau voyage avec validation des données.
2. **getTripById** : Récupère un voyage spécifique par son ID.
3. **getTripsByAccountId** : Récupère tous les voyages associés à un compte donné.
4. **getUpcomingTrips** : Récupère la liste des voyages à venir.
5. **updateTripStatus** : Met à jour le statut d'un voyage.
6. **updateTripCost** : Met à jour le coût total d'un voyage.
7. **deleteTrip** : Supprime un voyage spécifique.
8. **deleteTripsByAccountId** : Supprime tous les voyages associés à un compte.

---

## Règles métier

1. **Nom du voyage obligatoire** : Le champ `Name` doit être renseigné.
2. **Dates valides** :
   - La date de début (`StartTripDate__c`) et la date de fin (`EndTripDate__c`) sont obligatoires.
   - La date de fin doit être postérieure à la date de début.
3. **Statut obligatoire** : Le champ `Status__c` doit être renseigné.
4. **Coût total non négatif** : Le champ `Total_Cost__c` doit être supérieur ou égal à zéro.
5. **Compte associé obligatoire** : Le voyage doit être lié à un compte (`Account__c`).

---

## Méthodes

### **1. createTrip**

- **Description** : Crée un nouveau voyage en validant les données fournies.
- **Paramètres** :
  - `name` : Nom du voyage.
  - `startTripDate` : Date de début du voyage.
  - `endTripDate` : Date de fin du voyage.
  - `status` : Statut du voyage (par exemple, 'A venir', 'En cours', 'Terminé').
  - `totalCost` : Coût total du voyage.
  - `accountId` : ID du compte associé.
- **Exemple** :
  ```apex
  Id tripId = TripService.createTrip(
      'Voyage à Paris',
      Date.today().addDays(30),
      Date.today().addDays(37),
      'A venir',
      2000,
      accountId
  );
