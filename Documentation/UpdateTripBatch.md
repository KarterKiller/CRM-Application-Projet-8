# Documentation de UpdateTripStatusBatch

## Description
La classe `UpdateTripStatusBatch` est une classe **Batch Apex** permettant de mettre à jour automatiquement le statut des voyages (**Trip__c**) en fonction de leurs dates de début (**StartTripDate__c**) et de fin (**EndTripDate__c**). Cette mise à jour s'effectue via des traitements batchés pour optimiser les performances.

La classe implémente les interfaces **Database.Batchable<SObject>** et **Schedulable** pour permettre son exécution planifiée.

---

## Fonctionnalités principales
- Met à jour le statut des voyages selon les règles métier suivantes :
  - **"A venir"** : Si la date de début est dans le futur.
  - **"En cours"** : Si la date actuelle est comprise entre la date de début et la date de fin.
  - **"Terminé"** : Si la date actuelle est après la date de fin.
- Exclut les voyages ayant le statut "Annulé".
- Utilise un **helper** (`TriggerHelper.skipValidation`) pour contourner temporairement les validations dans les triggers Apex pendant la mise à jour.
- Permet l'exécution planifiée avec **Schedulable**.

---

## Structure de la Classe

### 1. **Méthode start**
```apex
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Name, StartTripDate__c, EndTripDate__c, Status__c
            FROM Trip__c
            WHERE Status__c != 'Annulé'
        ]);
    }
```
**Rôle :**
- Sélectionne les enregistrements **Trip__c** dont le statut est différent de "Annulé".
- Retourne un `Database.QueryLocator` pour traiter les enregistrements par lot.

---

### 2. **Méthode execute**
```apex
    global void execute(Database.BatchableContext BC, List<Trip__c> trips) {
        List<Trip__c> tripsToUpdate = new List<Trip__c>();
        Date today = Date.today();

        for (Trip__c trip : trips) {
            if (trip.StartTripDate__c != null && trip.EndTripDate__c != null) {
                if (today < trip.StartTripDate__c) {
                    trip.Status__c = 'A venir';
                } else if (today >= trip.StartTripDate__c && today <= trip.EndTripDate__c) {
                    trip.Status__c = 'En cours';
                } else if (today > trip.EndTripDate__c) {
                    trip.Status__c = 'Terminé';
                }
                tripsToUpdate.add(trip);
            }
        }

        if (!tripsToUpdate.isEmpty()) {
            try {
                TriggerHelper.skipValidation = true;
                update tripsToUpdate;
            } catch (DmlException e) {
                System.debug('Erreur lors de la mise à jour : ' + e.getMessage());
            } finally {
                TriggerHelper.skipValidation = false;
            }
        }
    }
```
**Rôle :**
- Traite les enregistrements par lots.
- Met à jour le statut des voyages selon la logique :
  - **A venir** : La date de début est dans le futur.
  - **En cours** : La date actuelle est comprise entre la date de début et la date de fin.
  - **Terminé** : La date actuelle est passée.
- Utilise `TriggerHelper.skipValidation` pour contourner les validations du trigger afin d'éviter les conflits.

---

### 3. **Méthode finish**
```apex
    global void finish(Database.BatchableContext BC) {
        System.debug('UpdateTripStatusBatch - Batch terminé.');
    }
```
**Rôle :**
- Effectue les opérations finales après l'exécution du batch.

---

### 4. **Méthode execute (Schedulable)**
```apex
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new UpdateTripStatusBatch());
    }
```
**Rôle :**
- Planifie l'exécution du batch pour automatiser la mise à jour des statuts des voyages.

---

## Exécution du Batch en Console de Développement

```apex
Database.executeBatch(new UpdateTripStatusBatch(), 200);
```
- **200** correspond à la taille des lots traités par le batch.

---

## Planification du Batch
Pour planifier l'exécution automatique du batch, utilisez **System.schedule** :
```apex
String cronExp = '0 0 0 * * ?'; // Minuit chaque jour
System.schedule('Daily UpdateTripStatusBatch', cronExp, new UpdateTripStatusBatch());
```

---

## Tests Unitaires
### Exemple de test unitaire pour le Batch :
```apex
@isTest
public class UpdateTripStatusBatchTest {
    @isTest
    static void testBatchExecution() {
        // Créer des enregistrements Trip__c de test
        List<Trip__c> trips = new List<Trip__c>{
            new Trip__c(Name = 'Trip 1', StartTripDate__c = Date.today().addDays(1), EndTripDate__c = Date.today().addDays(3), Status__c = 'A venir'),
            new Trip__c(Name = 'Trip 2', StartTripDate__c = Date.today().addDays(-1), EndTripDate__c = Date.today().addDays(2), Status__c = 'A venir'),
            new Trip__c(Name = 'Trip 3', StartTripDate__c = Date.today().addDays(-5), EndTripDate__c = Date.today().addDays(-2), Status__c = 'A venir')
        };
        insert trips;

        // Exécuter le batch
        Test.startTest();
        Database.executeBatch(new UpdateTripStatusBatch());
        Test.stopTest();

        // Vérifier les mises à jour
        List<Trip__c> updatedTrips = [SELECT Id, Status__c FROM Trip__c];
        System.assertEquals('A venir', updatedTrips[0].Status__c);
        System.assertEquals('En cours', updatedTrips[1].Status__c);
        System.assertEquals('Terminé', updatedTrips[2].Status__c);
    }
}
```

---

## Points Importants
1. **TriggerHelper** : 
   - La variable `TriggerHelper.skipValidation` permet de désactiver temporairement les validations du trigger lors de la mise à jour.
2. **Planification** : 
   - Le batch peut être planifié à l'aide du planificateur Apex pour exécuter automatiquement la mise à jour des statuts.
3. **Performances** :
   - Le traitement batch est optimisé pour gérer un grand nombre d'enregistrements.

---

## Conclusion
La classe `UpdateTripStatusBatch` permet de mettre à jour automatiquement les statuts des voyages selon leurs dates de début et de fin. Elle est robuste, planifiable, et respecte les meilleures pratiques Salesforce.
