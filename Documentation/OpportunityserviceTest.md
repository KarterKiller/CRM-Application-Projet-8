# OpportunityServiceTest

## Description
Tests unitaires pour la classe `OpportunityService`, validant les opérations CRUD et les règles métier pour l'objet `Opportunity`.

---

## Tests inclus

### **1. testCRUDOperations**
- **But** : Valide toutes les opérations CRUD pour les opportunités.
- **Validation principale** :
  - Création, lecture, mise à jour et suppression fonctionnent correctement.

---

### **2. testOpportunityAmountValidation**
- **But** : Vérifie que la validation métier empêche la création d'opportunités avec des montants négatifs.
- **Validation principale** :
  - Une exception est levée si le montant est négatif.

---

### **3. testDeleteOpportunityWithAccounts**
- **But** : Vérifie que la suppression d'une opportunité liée à un compte fonctionne correctement.
- **Validation principale** :
  - Le compte associé reste intact.

---

## Couverture globale

| Méthode                 | Couverture | Validation principale                              |
|-------------------------|------------|---------------------------------------------------|
| `createOpportunity`     | 100%       | Opportunité créée avec toutes les validations.    |
| `getOpportunityByName`  | 100%       | Les données retournées correspondent au nom donné.|
| `updateOpportunityStage` | 100%      | Statut correctement mis à jour.                  |
| `deleteOpportunity`     | 100%       | Opportunité supprimée avec succès.               |
