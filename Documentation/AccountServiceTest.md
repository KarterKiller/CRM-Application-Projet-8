# AccountServiceTest

## Description
Ce fichier contient les tests unitaires pour la classe `AccountService`. Ces tests valident les opérations CRUD et les règles métier associées à l'objet `Account`.

---

## Objectifs des tests

1. Valider que les méthodes de `AccountService` fonctionnent correctement pour :
   - La création d'un compte.
   - La lecture d'un compte par nom.
   - La mise à jour du numéro de téléphone.
   - La suppression d'un compte et des opportunités associées.

2. Vérifier que :
   - Les validations métier sont correctement appliquées.
   - Les permissions CRUD sont respectées.
   - Les exceptions sont levées en cas de non-conformité.

---

## Structure des tests

### **1. testCRUDOperations**
- **But** : Valider toutes les opérations CRUD.
- **Vérifications** :
  - Création d'un compte valide.
  - Lecture d'un compte par nom.
  - Mise à jour du numéro de téléphone.
  - Suppression du compte après avoir supprimé les opportunités associées.
- **Cas testé** :
  - Compte valide avec toutes les informations nécessaires.
- **Exemple de validation** :
  ```apex
  System.assertEquals('123-456-7890', retrievedAccount.Phone, 'Le téléphone devrait être initialisé correctement.');
