# OpportunityValidationTrigger

---

## **Objectif**

Le trigger **`OpportunityValidationTrigger`** permet de gérer les règles métiers associées à l'objet **`Opportunity`**.  
Il effectue deux types d'opérations :  
1. **Validation des opportunités** avant leur création ou mise à jour.  
2. **Création automatique de voyages** (**Trip__c**) et **contrats** (**Contract**) après qu'une opportunité atteint le statut **"Closed Won"**.

---

## **1. Structure du Trigger**

### **1.1 Déclenchement**

| **Événement**      | **Action**                                      |
|---------------------|------------------------------------------------|
| `before insert`     | Validation des données avec **`validateOpportunity`**. |
| `before update`     | Validation des données avec **`validateOpportunity`**. |
| `after update`      | Création des enregistrements **Trip__c** et **Contract** avec **`createTripAndContractForClosedWon`**. |

---

## **2. Code**

```apex
trigger OpportunityValidationTrigger on Opportunity (before insert, before update, after update) {
    if (Trigger.isBefore) {
        OpportunityTriggerHandler.validateOpportunity(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.createTripAndContractForClosedWon(Trigger.new, Trigger.oldMap);
    }
}
