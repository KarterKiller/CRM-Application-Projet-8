# Explication du code : UpdateTripStatusBatch

Ce fichier explique la classe Apex `UpdateTripStatusBatch`, une implémentation de l'interface `Database.Batchable` utilisée pour mettre à jour les statuts des objets `Trip__c` en fonction de leurs dates de début et de fin.

## Déclaration de la classe
```java
global class UpdateTripStatusBatch implements Database.Batchable<SObject> {
```
La classe est déclarée comme `global` pour pouvoir être appelée en dehors de son espace de noms et utilise l'interface `Database.Batchable` pour traiter de grandes quantités de données en plusieurs lots.

---

## Méthodes principales

### `start`
#### Description
Définit la logique pour sélectionner les enregistrements à traiter dans le batch.

#### Code
```java
global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator([
        SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c
        FROM Trip__c
        WHERE Status__c != 'Annulé'
    ]);
}
```

#### Fonctionnement
- Sélectionne les voyages (`Trip__c`) dont le statut n'est pas "Annulé".
- Utilise un `Database.QueryLocator` pour gérer efficacement de grandes quantités de données.

---

### `execute`
#### Description
Traite chaque lot d'enregistrements sélectionnés par la méthode `start`.

#### Code
```java
global void execute(Database.BatchableContext BC, List<Trip__c> trips) {
    ...
}
```

#### Fonctionnement
1. Calcule la date actuelle avec `Date.today()`.
2. Parcourt chaque voyage pour déterminer son nouveau statut :
   - **"A venir"** : si la date de début est dans le futur.
   - **"En cours"** : si la date actuelle est entre la date de début et la date de fin.
   - **"Terminé"** : si la date actuelle est après la date de fin.
3. Met à jour les enregistrements dans Salesforce en désactivant temporairement les triggers via `TriggerHelper.skipValidation`.

#### Gestion des erreurs
- Utilise un bloc `try-catch` pour capturer et enregistrer les erreurs lors de la mise à jour.

---

### `finish`
#### Description
Exécutée une fois tous les lots traités.

#### Code
```java
global void finish(Database.BatchableContext BC) {
    System.debug('UpdateTripStatusBatch - Batch terminé.');
}
```

#### Fonctionnement
- Fournit un point de terminaison pour effectuer des tâches de nettoyage ou d'enregistrement des résultats.

---

## Méthode supplémentaire : `execute`
#### Description
Planifie le batch pour une exécution immédiate.

#### Code
```java
global void execute(SchedulableContext SC) {
    Database.executeBatch(new UpdateTripStatusBatch());
}
```

#### Fonctionnement
- Permet de planifier le batch lorsqu'il est exécuté via une classe implémentant `Schedulable`.

---

## Points clés
1. **Modularité** : La logique de mise à jour est bien structurée dans les méthodes `start`, `execute`, et `finish`.
2. **Flexibilité** : Compatible avec des traitements en masse grâce à l'interface `Database.Batchable`.
3. **Optimisation** : Utilise des filtres efficaces pour réduire les données inutiles et désactive temporairement les triggers pour éviter les validations inutiles.
4. **Gestion des erreurs** : Capture les exceptions pour éviter les interruptions non contrôlées.

Ce batch est conçu pour mettre à jour les statuts des voyages en fonction de leur progression dans le temps, garantissant des données toujours à jour.
