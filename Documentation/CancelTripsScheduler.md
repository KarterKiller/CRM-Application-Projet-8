# Documentation : `CancelTripsScheduler`

---

## **Objectif**

La classe **`CancelTripsScheduler`** est une classe globale permettant de planifier l'exécution du batch **`CancelTripsBatch`**.  
Elle utilise l'interface **`Schedulable`** pour automatiser et programmer le traitement des voyages à annuler.

---

## **Fonctionnalité**

La méthode principale **`execute`** est appelée automatiquement lorsqu'un job planifié est exécuté.  
Elle initialise et exécute le batch **`CancelTripsBatch`** via la méthode **`Database.executeBatch`**.

---

## **Structure de la Classe**

```apex
global class CancelTripsScheduler implements Schedulable {

    // Méthode globale appelée par le système lorsqu'un job planifié est déclenché
    global void execute(SchedulableContext SC) {
        // Appel du batch CancelTripsBatch
        Database.executeBatch(new CancelTripsBatch());
    }
}
