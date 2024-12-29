# CancelTripsBatch Documentation

## Description
`CancelTripsBatch` est une classe Apex permettant d'annuler automatiquement les voyages (
**Trip__c**) lorsque leur date de début approche et que le nombre de participants est inférieur à un seuil prédéfini (10 participants).

Elle est conçue pour s'exécuter en mode batch afin de traiter de gros volumes d'enregistrements de manière efficace. Cette classe implémente les interfaces **Database.Batchable<SObject>** et **Schedulable** pour permettre à la fois un traitement en lots et une planification automatique.

---

## Déclenchement du Batch

Le batch peut être déclenché manuellement ou via un job planifié :

### Exécution manuelle via Developer Console
```apex
Database.executeBatch(new CancelTripsBatch(), 200);
```

### Planification automatique
Pour exécuter le batch tous les jours, utilisez la méthode **execute** de l'interface **Schedulable** :
```apex
System.schedule('Daily CancelTripsBatch', '0 0 0 * * ?', new CancelTripsBatch());
```
---

## Fonctionnalités principales

### 1. **Sélection des voyages (
start)**
- **Critères de sélection :**
  - Les voyages commencent dans les **7 prochains jours**.
  - Le statut du voyage n'est **pas "Annulé"**.
- **Requête SOQL :**
```apex
SELECT Id, Name, StartTripDate__c, Number_of_Participants__c, Status__c
FROM Trip__c
WHERE StartTripDate__c >= :Date.today()
AND StartTripDate__c <= :Date.today().addDays(7)
AND Status__c != 'Annulé'
```

### 2. **Validation et annulation des voyages (
execute)**
- Pour chaque voyage sélectionné :
  - Vérifie si **Number_of_Participants__c** est inférieur à **10**.
  - Si oui, met à jour **Status__c** en "Annulé".
- **Logs pour suivi :**
  - Voyage annulé : affiché dans les logs.
  - Voyage non annulé : affiché pour information.

### 3. **Mise à jour en base de données**
- Les voyages annulés sont mis à jour en une seule opération **DML** :
```apex
update tripsToCancel;
```
- Gestion des erreurs : Utilise **try/catch** pour éviter les erreurs DML non gérées.

### 4. **Fin du traitement (
finish)**
- Ajoute un log indiquant que le batch s'est terminé correctement.

---

## Code

### Signature de la classe
```apex
global class CancelTripsBatch implements Database.Batchable<SObject>, Schedulable {
```

### Méthodes
| **Méthode**          | **Description**                                                                               |
|----------------------|---------------------------------------------------------------------------------------------|
| `start`             | Sélectionne les voyages valides via une requête SOQL.                                        |
| `execute`           | Vérifie chaque voyage et met à jour son statut si nécessaire.                               |
| `finish`            | Exécutée à la fin pour ajouter des logs.                                                    |
| `execute(SchedulableContext)` | Permet de planifier l'exécution régulière du batch (ex. tous les jours). |

---

## Exemple de cas d'utilisation
### 1. Annuler les voyages avec moins de 10 participants
- **Condition :**
  - Le nombre de participants (**Number_of_Participants__c**) est inférieur à 10.
  - Le voyage commence dans les 7 prochains jours.

- **Mise à jour :**
  - Le statut (**Status__c**) est mis à jour en **"Annulé"**.

### 2. Planification du batch
Pour automatiser cette opération chaque nuit :
```apex
System.schedule('CancelTripsBatch Nightly Job', '0 0 0 * * ?', new CancelTripsBatch());
```

---

## Bonnes pratiques et recommandations
1. **Traiter les erreurs DML** :
   - Le **try/catch** est utilisé pour gérer les erreurs et éviter que le batch ne s'arrête brutalement.

2. **Logs détaillés** :
   - Les `System.debug()` facilitent le suivi de l'exécution et des mises à jour effectuées.

3. **Performance** :
   - Le batch utilise la limite de 200 enregistrements pour chaque lot afin de respecter les limites Salesforce.

4. **Test et couverture de code** :
   - Créer un test unitaire pour vérifier que le batch fonctionne correctement et respecte les critères d'annulation.

---

## Exemple de test unitaire
Voici un exemple simplifié d'un test unitaire pour **CancelTripsBatch** :

```apex
@isTest
private class CancelTripsBatchTest {
    @isTest
    static void testCancelTrips() {
        // Créer des voyages de test
        List<Trip__c> trips = new List<Trip__c>();
        for (Integer i = 0; i < 5; i++) {
            trips.add(new Trip__c(
                Name = 'Trip ' + i,
                StartTripDate__c = Date.today().addDays(3),
                Number_of_Participants__c = i + 5, // Quelques voyages en dessous de 10
                Status__c = 'A venir'
            ));
        }
        insert trips;

        // Exécuter le batch
        Test.startTest();
        Database.executeBatch(new CancelTripsBatch(), 200);
        Test.stopTest();

        // Vérifier les résultats
        List<Trip__c> updatedTrips = [SELECT Id, Status__c FROM Trip__c];
        for (Trip__c trip : updatedTrips) {
            if (trip.Number_of_Participants__c < 10) {
                System.assertEquals('Annulé', trip.Status__c, 'Le voyage aurait dû être annulé.');
            }
        }
    }
}
```

---

## Résumé
La classe **CancelTripsBatch** automatise l'annulation des voyages ayant un nombre de participants insuffisant et assure une gestion efficace grâce aux capacités de traitement par lots et planification de Salesforce.
