# Explication du code : TripValidationTrigger

Ce fichier explique le fonctionnement du déclencheur Apex `TripValidationTrigger`, qui applique des règles de validation sur les objets personnalisés `Trip__c` dans Salesforce.

## Déclaration du déclencheur
```java
trigger TripValidationTrigger on Trip__c (before insert, before update) {
```
Le déclencheur est configuré pour s'exécuter :
- **Avant l'insertion (`before insert`)** : pour valider les données des nouveaux voyages avant leur insertion dans la base de données.
- **Avant la mise à jour (`before update`)** : pour valider les modifications apportées aux voyages existants avant leur enregistrement.

## Appel de la méthode de validation
```java
ValidationHelper.validateTrip(Trigger.new, Trigger.oldMap);
```
### Description
Le déclencheur délègue la logique de validation à une méthode utilitaire `validateTrip` située dans la classe `ValidationHelper`.

### Paramètres passés à la méthode
- `Trigger.new` : une liste des nouveaux voyages ou des modifications apportées aux voyages.
- `Trigger.oldMap` : une carte (Map) contenant les anciennes valeurs des voyages, associées à leur identifiant (uniquement disponible lors de la mise à jour).

### Avantages
- **Modularité** : La logique de validation est centralisée dans la classe `ValidationHelper`, ce qui simplifie la maintenance et le réemploi du code.
- **Clarté** : Le déclencheur reste simple, se limitant à appeler la méthode appropriée.

## Résumé
Le déclencheur `TripValidationTrigger` :
1. S'exécute avant l'insertion ou la mise à jour des objets `Trip__c`.
2. Appelle la méthode `validateTrip` de la classe `ValidationHelper` pour appliquer les règles de validation définies.

Ce déclencheur suit les bonnes pratiques de Salesforce en séparant les responsabilités entre le déclencheur et la logique métier.
