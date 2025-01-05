# Documentation du Projet: Salesforce Trip Management

## Structure du Projet

### Classes Apex
- **TripController**: Gestion des voyages (Trip__c) avec des méthodes pour récupérer et filtrer les données.
- **SalesTrackingController**: Gestion des contrats (Contract) avec des méthodes pour récupérer et filtrer les données.
- **TaskController**: Gestion des tâches (Task) avec des méthodes pour afficher l'historique.
- **CentralizedCrudValidation**: Validation centralisée des permissions CRUD pour les objets Salesforce.
- **TriggerHelper**: Classe utilitaire pour gérer les triggers.
- **ValidationHelper**: Classe utilitaire pour gérer les validations.
- **CancelTripsScheduler**: Classe pour planifier les tâches de suppression des voyages.
- **OpportunityTriggerHandler**: Classe pour gérer les triggers Opportunity.


### Triggers
- **AccountValidationTrigger**: Validation des règles métier sur les comptes (Account) lors des insertions/mises à jour.
- **ContractValidationTrigger**: Validation des règles métier sur les contrats (Contract).
- **OpportunityValidationTrigger**: Validation des règles métier sur les opportunités (Opportunity).
- **TaskValidationTrigger**: Validation des règles métier sur les tâches (Task).
- **TripValidationTrigger**: Validation des règles métier sur les voyages (Trip__c).
- 

### Classes de Test
- **TripControllerTest**: Test unitaire pour la classe TripController.
- **SalesTrackingControllerTest**: Test unitaire pour la classe SalesTrackingController.
- **TaskControllerTest**: Test unitaire pour la classe TaskController.
- **CentralizedCrudValidationTest**: Test unitaire pour la validation des permissions CRUD.
- **AccountValidationTriggerTest**: Test unitaire pour les triggers Account.
- **OpportunityValidationTriggerTest**: Test unitaire pour les triggers Opportunity.
- **TaskValidationTriggerTest**: Test unitaire pour les triggers Task.
- **TripValidationTriggerTest**: Test unitaire pour les triggers Trip.
- **CancelTripsBatchTest**: Test unitaire pour la classe CancelTripsBatch.
- **UpdateTripStatusBatchTest**: Test unitaire pour la classe UpdateTripStatusBatch.
- **ContractTriggerTest**: Test unitaire pour les triggers Contract.
- **CancelTripsSchedulerTest**: Test unitaire pour la classe CancelTripsScheduler.

### Test Data Factory
- **TestDataFactory**: Classe utilitaire pour créer des données de test standardisées.

### Batches
- **CancelTripsBatch**: Annule les voyages ayant moins de 10 participants.
- **UpdateTripStatusBatch**: Met à jour les statuts des voyages en fonction de leur date.

## Filtres et Méthodes
### Exemple de Filtres dans TripController
- Filtrage par profil utilisateur pour le propriétaire.
- Filtrage par statut (e.g., "A venir").
- Filtrage par plage de dates.

### Méthodes Communes
- `getTrips`: Récupère les voyages avec des filtres spécifiques.
- `getTaskHistory`: Affiche l'historique des tâches.
- `validateCrud`: Valide les permissions CRUD pour un objet donné.

## Points à Améliorer
- Augmenter la couverture des tests actuellement de **91.5%**.
- Ajouter des validations spécifiques pour certains champs personnalisés.
- Améliorer la documentation avec des exemples concrets pour chaque méthode publique.

## Auteur
- **Nom**: [TAYASSI]
- **Email**: [karter.t@gmail.com]
- **Date**: [02/01/2025]
