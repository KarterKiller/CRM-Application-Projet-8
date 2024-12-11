# ContractServiceTest

## Description
Tests unitaires pour la classe `ContractService`, validant les opérations CRUD et les règles métier pour l'objet `Contract`.

---

## Tests inclus

### **1. testCreateContractFromOpportunity**
- **But** : Vérifie que la création d'un contrat à partir d'une opportunité est fonctionnelle.
- **Validation principale** :
  - Les champs du contrat correspondent à ceux de l'opportunité associée.

---

### **2. testGetContractById**
- **But** : Valide la récupération d'un contrat par son ID.
- **Validation principale** :
  - Les données du contrat retourné correspondent à celles insérées.

---

### **3. testUpdateContractStatus**
- **But** : Vérifie que le statut d'un contrat est correctement mis à jour.
- **Validation principale** :
  - Le champ `Status` reflète la nouvelle valeur.

---

### **4. testDeleteContract**
- **But** : Valide la suppression d'un contrat.
- **Validation principale** :
  - Le contrat est supprimé de la base de données.

---

### **5. testDeleteContractsByAccountId**
- **But** : Vérifie que tous les contrats liés à un compte spécifique peuvent être supprimés.
- **Validation principale** :
  - Aucun contrat ne reste lié au compte après la suppression.

---

## Couverture globale

| Méthode                 | Couverture | Validation principale                        |
|-------------------------|------------|---------------------------------------------|
| `createContractFromOpportunity` | 100% | Contrat correctement lié à une opportunité. |
| `getContractById`      | 100%       | Les données retournées sont exactes.         |
| `updateContractStatus` | 100%       | Statut correctement mis à jour.              |
| `deleteContract`       | 100%       | Contrat supprimé de la base.                 |
| `deleteContractsByAccountId` | 100% | Tous les contrats du compte supprimés.       |
