# AccountService

## Description
`AccountService` gère les opérations CRUD pour l'objet `Account`. Cette classe permet de créer, lire, mettre à jour et supprimer des comptes tout en appliquant des validations métiers et en assurant un respect strict des permissions CRUD.

---

## Fonctionnalités principales

1. **createAccount** : Crée un nouveau compte avec validation des données.
2. **getAccountByName** : Récupère un compte spécifique par son nom.
3. **updateAccountPhone** : Met à jour le numéro de téléphone d'un compte.
4. **deleteAccount** : Supprime un compte et toutes les opportunités associées.

---

## Règles métier

1. **Nom obligatoire** : Le champ `Name` doit être renseigné.
2. **Numéro de téléphone valide** :
   - Si renseigné, le téléphone doit respecter un format valide.
3. **Validation CRUD** : Les opérations sont vérifiées pour s'assurer que l'utilisateur a les autorisations nécessaires.

---

## Méthodes

### **1. createAccount**

- **Description** : Crée un nouveau compte en validant les données et permissions.
- **Paramètres** :
  - `name` : Nom du compte (obligatoire).
  - `industry` : Secteur d'activité (optionnel).
  - `phone` : Numéro de téléphone (optionnel).
- **Validations** :
  - Le nom est obligatoire.
  - Si un numéro de téléphone est fourni, il doit être dans un format valide.
- **Exemple** :
  ```apex
  Id accountId = AccountService.createAccount(
      'Entreprise Test',
      'Technology',
      '123-456-7890'
  );
