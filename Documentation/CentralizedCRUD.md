# CentralizedCrudValidation

## Description
La classe `CentralizedCrudValidation` centralise les validations CRUD (Create, Read, Update, Delete) pour tous les objets. Elle garantit que seules les actions autorisées en fonction des permissions utilisateur sont exécutées sur les objets Salesforce.

---

## Fonctionnalités principales
1. **Validation des permissions CRUD** : Vérifie si un utilisateur a le droit d'effectuer une action CRUD sur un objet donné.
2. **Application centralisée** : Facilite la gestion des validations sur plusieurs objets sans dupliquer le code.

---

## Méthodes

### **1. validateCrud**
- **Description** : Vérifie si une action CRUD donnée est autorisée pour un objet.
- **Paramètres** :
  - `objectName` : Nom de l'objet Salesforce (ex. `Account`, `Opportunity`).
  - `action` : Action CRUD (`create`, `read`, `update`, `delete`).
- **Exemple** :
```apex
CentralizedCrudValidation.validateCrud('Account', 'create');
