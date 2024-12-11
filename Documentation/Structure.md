# Structure des fichiers et des classes

## Organisation des classes
- **OpportunityService.cls** : Contient les méthodes CRUD et validations pour l'objet Opportunity, ainsi que les règles métier associées.
- **ContractService.cls** : Contient les méthodes CRUD et validations pour l'objet Contract, avec les validations métiers spécifiques.
- **TaskService.cls** : Contient les méthodes CRUD et validations pour l'objet Task, incluant les vérifications de statut et de priorité.
- **TripService.cls** : Contient les méthodes CRUD et validations pour l'objet personnalisé Trip__c.

## Organisation des tests unitaires
- **OpportunityServiceTest.cls** : Tests unitaires couvrant toutes les fonctionnalités d'OpportunityService.
- **ContractServiceTest.cls** : Tests unitaires pour les fonctionnalités de ContractService.
- **TaskServiceTest.cls** : Tests unitaires pour TaskService, incluant les validations métiers.
- **TripServiceTest.cls** : Tests unitaires pour TripService, avec des scénarios pour toutes les règles métier.

## Dossier doc
Contient cette documentation, des exemples d'utilisation, et des explications sur les règles métier implémentées.
