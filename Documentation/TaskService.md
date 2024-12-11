# TaskService

## Description
La classe `TaskService` fournit des fonctionnalités pour gérer les tâches Salesforce. Elle inclut des validations pour garantir la cohérence des données, comme la vérification des priorités et des statuts.

---

## Fonctionnalités principales
1. **Créer une tâche** : Crée une tâche associée à un compte, une opportunité ou un contact.
2. **Lire une tâche** : Permet de récupérer des tâches par ID ou par enregistrement lié.
3. **Mettre à jour une tâche** : Permet de modifier le statut ou la priorité d'une tâche.
4. **Supprimer une tâche** : Supprime une tâche spécifique ou toutes les tâches liées à un enregistrement.

---

## Méthodes

### **1. createTask**
- **Description** : Crée une tâche Salesforce.
- **Paramètres** :
  - `subject` : Sujet de la tâche.
  - `status` : Statut de la tâche (`Not Started`, `In Progress`, `Completed`).
  - `priority` : Priorité de la tâche (`High`, `Normal`, `Low`).
  - `activityDate` : Date d'échéance de la tâche.
  - `whatId` : ID de l'enregistrement lié (compte, opportunité, etc.).
  - `whoId` : ID de la personne liée (contact ou lead).
- **Validations** :
  - Le sujet ne doit pas être vide.
  - La date d'activité doit être dans le futur.
  - Le statut et la priorité doivent être valides.
- **Exemple** :
```apex
Id taskId = TaskService.createTask('Appel client', 'Not Started', 'High', Date.today().addDays(1), accountId, null);
