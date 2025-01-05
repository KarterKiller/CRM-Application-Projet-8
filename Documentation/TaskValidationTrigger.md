# Explication du code : TaskValidationTrigger

Ce fichier explique le fonctionnement du déclencheur Apex `TaskValidationTrigger`, qui applique des règles de validation sur les tâches (`Task`) dans Salesforce.

## Déclaration du déclencheur
```java
trigger TaskValidationTrigger on Task (before insert, before update) {
```
Le déclencheur est configuré pour s'exécuter :
- **Avant l'insertion (`before insert`)** : pour valider les données des nouvelles tâches avant qu'elles ne soient insérées dans la base de données.
- **Avant la mise à jour (`before update`)** : pour valider les modifications apportées aux tâches existantes avant qu'elles ne soient enregistrées.

## Appel de la méthode de validation
```java
ValidationHelper.validateTask(Trigger.new, Trigger.oldMap);
```
### Description
Le déclencheur délègue la logique de validation à une méthode utilitaire `validateTask` située dans la classe `ValidationHelper`.

### Paramètres passés à la méthode
- `Trigger.new` : une liste des nouvelles tâches ou des modifications apportées aux tâches.
- `Trigger.oldMap` : une carte (Map) contenant les anciennes valeurs des tâches, associées à leur identifiant (uniquement disponible lors de la mise à jour).

### Avantages
- **Modularité** : La logique de validation est centralisée dans la classe `ValidationHelper`, ce qui simplifie la maintenance et le réemploi du code.
- **Clarté** : Le déclencheur reste simple, se limitant à appeler la méthode appropriée.

## Résumé
Le déclencheur `TaskValidationTrigger` :
1. S'exécute avant l'insertion ou la mise à jour de tâches.
2. Appelle la méthode `validateTask` de la classe `ValidationHelper` pour appliquer les règles de validation définies.

Ce déclencheur suit les bonnes pratiques de Salesforce, en séparant les responsabilités entre le déclencheur et la logique métier.
