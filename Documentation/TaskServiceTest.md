# TaskServiceTest

## Description
Tests unitaires pour la classe `TaskService`, validant les opérations CRUD et les règles métier pour l'objet `Task`.

---

## Tests inclus

### **1. testCRUDOperations**
- **But** : Valide toutes les opérations CRUD pour les tâches.
- **Validation principale** :
  - Les données de tâche sont créées, lues, mises à jour et supprimées correctement.

---

### **2. testCreateTask**
- **But** : Vérifie la création d'une tâche avec des données valides.
- **Validation principale** :
  - Tous les champs sont initialisés correctement.

---

### **3. testUpdateTaskPriority**
- **But** : Vérifie que la priorité d'une tâche peut être mise à jour.
- **Validation principale** :
  - La nouvelle priorité est correctement enregistrée.

---

### **4. testDeleteTasksByWhatId**
- **But** : Valide que toutes les tâches liées à un enregistrement peuvent être supprimées.
- **Validation principale** :
  - Aucune tâche ne reste associée après la suppression.

---

## Couverture globale

| Méthode                 | Couverture | Validation principale                                |
|-------------------------|------------|-----------------------------------------------------|
| `createTask`            | 100%       | Les tâches sont créées avec toutes les validations. |
| `getTaskById`           | 100%       | Les données retournées sont exactes.                |
| `updateTaskPriority`    | 100%       | Priorité mise à jour avec succès.                   |
| `deleteTask`            | 100%       | Tâche supprimée avec succès.                        |
