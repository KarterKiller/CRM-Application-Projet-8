# TripValidationTrigger

---

## **Objectif**

Le trigger **`TripValidationTrigger`** assure la validation des règles métier pour l'objet **`Trip__c`**. Il s'exécute avant l'insertion (**`before insert`**) et la mise à jour (**`before update`**) des enregistrements.  
Le trigger utilise **`TriggerHelper.skipValidation`** pour désactiver temporairement les validations lorsque nécessaire, notamment lors de l'exécution de batchs Apex.

---

## **Règles de Validation Implémentées**

### **1. Validation du nom obligatoire**
- **Condition :** Le champ `Name` ne doit pas être vide.
- **Message d'erreur :** *"Le nom du voyage est obligatoire."*

---

### **2. Validation des dates de début et de fin**
- **Condition :** La date de fin `EndTripDate__c` doit être strictement postérieure à la date de début `StartTripDate__c`.
- **Message d'erreur :** *"La date de fin doit être postérieure à la date de début."*

---

### **3. Validation du statut obligatoire**
- **Condition :** Le champ `Status__c` ne doit pas être vide.
- **Message d'erreur :** *"Le statut du voyage est obligatoire."*

---

### **4. Validation du coût total**
- **Condition :** Le champ `Total_Cost__c` doit être supérieur ou égal à zéro.
- **Message d'erreur :** *"Le coût total ne peut pas être négatif."*

---

### **5. Validation de l'association avec un compte**
- **Condition :** Le champ `Account__c` (relation avec un compte) ne doit pas être vide.
- **Message d'erreur :** *"Le voyage doit être associé à un compte."*

---

### **6. Validation des voyages avec statut "Terminé"**
- **Condition :** Un voyage marqué comme **"Terminé"** ne peut pas avoir une `EndTripDate__c` dans le futur.
- **Message d'erreur :** *"Un voyage avec une date de fin dans le futur ne peut pas être marqué comme 'Terminé'."*

---

## **Logique d'Exécution**

1. **Désactivation conditionnelle des validations :**
   - Si **`TriggerHelper.skipValidation`** est activé, les validations ne sont pas exécutées.
   ```apex
   if (TriggerHelper.skipValidation) {
       return; // Ne pas exécuter les validations si elles sont désactivées
   }
