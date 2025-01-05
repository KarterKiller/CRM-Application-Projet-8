# Explication du code : TaskController

Ce fichier explique la classe Apex `TaskController`, conçue pour récupérer un historique des tâches récentes via une méthode accessible aux composants Lightning.

## Déclaration de la classe
```java
public with sharing class TaskController {
```
- **`with sharing`** : Respecte les règles de partage définies pour l'utilisateur courant.
- La classe est accessible globalement.

---

## Méthode principale : `getTaskHistory`

### Annotation
```java
@AuraEnabled(cacheable=true)
```
- **`@AuraEnabled`** : Rend la méthode accessible depuis des composants Lightning ou LWC.
- **`cacheable=true`** : Indique que les données peuvent être mises en cache pour des performances optimales.

### Fonctionnalité
Récupère une liste des trois dernières tâches avec des informations essentielles, ordonnées par date d'activité descendante.

### Étapes principales

#### 1. Requête SOQL
```java
return [
    SELECT Id, Subject, Status, Priority, ActivityDate, Who.Name, What.Name 
    FROM Task 
    WHERE ActivityDate >= :Date.today().addDays(-5)
    ORDER BY ActivityDate DESC LIMIT 3
];
```
- **Champs sélectionnés** :
  - `Id` : Identifiant unique de la tâche.
  - `Subject` : Sujet de la tâche.
  - `Status` : Statut actuel de la tâche (par exemple, "Not Started", "Completed").
  - `Priority` : Priorité de la tâche (par exemple, "High", "Medium").
  - `ActivityDate` : Date d'activité prévue.
  - `Who.Name` : Nom de la personne associée à la tâche (par exemple, un contact ou un lead).
  - `What.Name` : Nom de l'objet lié à la tâche (par exemple, un compte ou une opportunité).

- **Filtrage** : Seules les tâches dont la date d'activité est dans les 5 derniers jours sont incluses.

- **Tri** :
  - Les tâches sont triées par `ActivityDate` dans l'ordre décroissant (les tâches les plus récentes en premier).

- **Limite** : La requête retourne au maximum 3 tâches.

---

## Résumé
La classe `TaskController` fournit :
1. Une méthode simple pour récupérer les trois dernières tâches récentes ayant une date d'activité dans les 5 derniers jours.
2. Une structure optimisée pour les composants Lightning grâce à l'annotation `@AuraEnabled(cacheable=true)`.
3. Une performance optimisée avec un filtrage, un tri, et une limite sur les données récupérées.

Cette méthode est utile pour afficher un aperçu rapide des tâches récentes dans des tableaux de bord ou des composants utilisateur.
