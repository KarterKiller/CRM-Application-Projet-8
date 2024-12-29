# ContractTriggerHandler

---

## **1. Objectif**

La classe **`ContractTriggerHandler`** centralise la logique de validation des règles métiers pour l'objet **`Contract`**. Elle est appelée dans les triggers pour s'assurer que les données respectent les contraintes avant l'insertion, la mise à jour ou la suppression d'un contrat.

---

## **2. Méthodes**

### **2.1 Méthode `validateInsert`**

- **Objectif :** Valider les données des contrats **avant l'insertion**.
- **Paramètre :** `List<Contract> newContracts` → Liste des contrats à insérer.
- **Règles métiers appliquées :**
    1. **Montant obligatoire et positif :**
        - Le champ `Amount__c` doit être renseigné et supérieur à 0.
        - **Message d'erreur :** "Le montant du contrat doit être supérieur à 0."
    2. **Nombre de participants obligatoire et positif :**
        - Le champ `Number_of_Participants__c` doit être renseigné et supérieur à 0.
        - **Message d'erreur :** "Le nombre de participants doit être supérieur à 0."
    3. **Dates de voyage valides :**
        - Les champs `StartTripDate__c` et `EndTripDate__c` sont obligatoires.
        - La date de fin (`EndTripDate__c`) doit être postérieure à la date de début (`StartTripDate__c`).
        - **Message d'erreur :**
            - "Les dates de début et de fin du voyage sont obligatoires."
            - "La date de fin doit être postérieure à la date de début."

#### **Exemple :**
```apex
Contract con = new Contract(
    Amount__c = 0, // Erreur
    Number_of_Participants__c = 0, // Erreur
    StartTripDate__c = Date.today(),
    EndTripDate__c = Date.today().addDays(-1) // Erreur
);
