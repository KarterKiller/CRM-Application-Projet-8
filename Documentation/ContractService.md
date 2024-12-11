# ContractService

## Description
`ContractService` gère les opérations CRUD et les validations métiers pour l'objet Contract. Cette classe permet de créer, lire, mettre à jour et supprimer des contrats, tout en garantissant le respect des règles métier.

## Fonctionnalités principales
1. **createContractFromOpportunity** : Crée un contrat basé sur une opportunité existante.
2. **getContractById** : Récupère un contrat spécifique par son ID.
3. **getContractsByStatus** : Récupère les contrats ayant un statut donné.
4. **updateContractStatus** : Met à jour le statut d'un contrat.
5. **updateContractTerm** : Met à jour la durée d'un contrat.
6. **deleteContract** : Supprime un contrat spécifique.
7. **deleteContractsByAccountId** : Supprime tous les contrats liés à un compte.

---

## Règles métier
1. **Montant du contrat** : Le montant (`Amount__c`) doit être positif.
2. **Dates de voyage** : Les dates de début et de fin (`StartTripDate__c`, `EndTripDate__c`) doivent être valides (la date de fin doit être postérieure à la date de début).
3. **Statut valide** : Les mises à jour de statut doivent utiliser des valeurs autorisées telles que `Draft`, `Activated`, ou `Terminated`.

---

## Méthodes

### **1. createContractFromOpportunity**
- **Description** : Crée un contrat en récupérant les informations d'une opportunité.
- **Paramètres** :
  - `opportunityId` : ID de l'opportunité liée.
- **Exemple** :
```apex
Id contractId = ContractService.createContractFromOpportunity(opportunityId);
