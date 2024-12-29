# **Structure de l'Ensemble des Classes et Triggers**

---

## **1. Classes Apex**

### **1.1. `AccountValidationTriggerTest`**
- **Objectif :** Tester les validations sur l'objet `Account`.
- **Tests réalisés :**
  - Nom du compte obligatoire.
  - Numéro de téléphone valide (10 chiffres).
  - Statut `Active__c` doit être "Yes".

---

### **1.2. `ContractTriggerHandler`**
- **Objectif :** Valider les règles métier pour l'objet `Contract`.
- **Méthodes :**
  - **`validateInsert` :** Vérifie le montant, le nombre de participants et les dates.
  - **`validateUpdate` :** Empêche la modification d'un contrat signé.
  - **`validateDelete` :** Interdit la suppression d'un contrat avec le statut `Activated`.

---

### **1.3. `ContractTriggerTest`**
- **Objectif :** Tester les validations sur l'objet `Contract`.
- **Tests réalisés :**
  - Montant négatif.
  - Nombre de participants invalide.
  - Dates invalides.
  - Suppression interdite pour les contrats `Activated`.

---

### **1.4. `OpportunityTriggerHandler`**
- **Objectif :** Valider les règles métier sur `Opportunity` et automatiser la création de `Trip` et `Contract`.
- **Méthodes :**
  - **`validateOpportunity` :** Vérifie le montant, les dates, la destination et les participants.
  - **`createTripAndContractForClosedWon` :** Crée un `Trip` et un `Contract` lorsque l'opportunité passe en `Closed Won`.

---

### **1.5. `OpportunityValidationTriggerTest`**
- **Objectif :** Tester les validations et automatisations sur l'objet `Opportunity`.
- **Tests réalisés :**
  - Montant invalide.
  - Dates invalides.
  - Création d'un `Trip` et `Contract` pour les opportunités `Closed Won`.

---

### **1.6. `TaskValidationTriggerTest`**
- **Objectif :** Tester les validations sur les tâches.
- **Tests réalisés :**
  - Sujet obligatoire.
  - Date d'activité doit être dans le futur ou aujourd'hui.
  - Priorité doit être "High", "Medium", ou "Low".
  - Statut "Completed" interdit si la date d'activité est dans le futur.

---

### **1.7. `TripValidationTriggerTest`**
- **Objectif :** Tester les validations sur les voyages (`Trip__c`).
- **Tests réalisés :**
  - Nom obligatoire.
  - Dates invalides.
  - Coût total négatif.
  - Statut `Terminé` interdit si la date de fin est dans le futur.

---

### **1.8. `CancelTripsBatch`**
- **Objectif :** Annuler les voyages dont le nombre de participants est inférieur à 10.
- **Méthodes :**
  - **`start` :** Sélectionne les voyages à traiter.
  - **`execute` :** Annule les voyages ne remplissant pas les conditions.
  - **`finish` :** Logique de fin de batch.

---

### **1.9. `CancelTripsScheduler`**
- **Objectif :** Automatiser l'exécution du batch `CancelTripsBatch`.
- **Méthode :**
  - **`execute` :** Appelle `Database.executeBatch`.

---

### **1.10. `UpdateTripStatusBatch`**
- **Objectif :** Mettre à jour le statut des voyages en fonction de la date actuelle.
- **Statuts :**
  - `A venir` : Date de début dans le futur.
  - `En cours` : Date actuelle entre la date de début et de fin.
  - `Terminé` : Date de fin dépassée.
- **Méthodes :**
  - **`start` :** Sélectionne les voyages actifs.
  - **`execute` :** Met à jour les statuts.
  - **`finish` :** Logique de fin de batch.

---

### **1.11. `TriggerHelper`**
- **Objectif :** Contrôler l'exécution des validations dans les triggers.
- **Attribut :**
  - **`skipValidation` :** Permet de désactiver temporairement les validations.

---

## **2. Triggers**

### **2.1. `AccountValidationTrigger`**
- **Objectif :** Valider les règles métier sur `Account`.
- **Validations :**
  - Nom obligatoire.
  - Industrie obligatoire.
  - Numéro de téléphone valide.
  - Statut `Active__c` doit être "Yes".

---

### **2.2. `OpportunityValidationTrigger`**
- **Objectif :**
  - Valider les règles métier sur `Opportunity`.
  - Créer automatiquement un `Trip` et un `Contract` si l'opportunité passe en `Closed Won`.
- **Types d'exécution :**
  - **Before Insert/Update :** Validations.
  - **After Update :** Automatisation des créations.

---

### **2.3. `TaskValidationTrigger`**
- **Objectif :** Valider les tâches.
- **Validations :**
  - Sujet obligatoire.
  - Date d'activité dans le futur ou aujourd'hui.
  - Priorité valide.
  - Statut "Completed" impossible si la date d'activité est future.

---

### **2.4. `TripValidationTrigger`**
- **Objectif :** Valider les voyages (`Trip__c`).
- **Validations :**
  - Nom obligatoire.
  - Statut obligatoire.
  - Dates valides.
  - Coût total non négatif.
  - Statut `Terminé` interdit si la date de fin est future.

---

## **3. Résumé des Automatisations**

| **Objet**           | **Automatisation**                                          | **Statut**          |
|----------------------|------------------------------------------------------------|---------------------|
| `Opportunity`       | Création de `Trip__c` et `Contract` en `Closed Won`.       | ✅                 |
| `Trip__c`           | Mise à jour du statut via `UpdateTripStatusBatch`.         | ✅                 |
| `Trip__c`           | Annulation via `CancelTripsBatch`.                         | ✅                 |

---

## **4. Exécution Planifiée**

| **Classe**              | **Fréquence**                     | **Batch Appelé**            |
|-------------------------|----------------------------------|-----------------------------|
| `CancelTripsScheduler`  | Planification quotidienne.       | `CancelTripsBatch`          |
| `UpdateTripStatusBatch` | Planification régulière (cron).  | Met à jour les statuts.     |

---

## **5. Structure de Validation**

| **Objet**           | **Champs Validés**                         | **Règles Appliquées**                                    |
|----------------------|------------------------------------------|---------------------------------------------------------|
| `Account`           | `Name`, `Industry`, `Phone`, `Active__c` | Champs obligatoires, format téléphone, statut "Yes".    |
| `Opportunity`       | `Amount`, `StartTripDate__c`, `Destination__c` | Montant > 0, dates valides, destination obligatoire.   |
| `Task`              | `Subject`, `ActivityDate`, `Priority`    | Champs obligatoires, priorité, statut "Completed".      |
| `Trip__c`           | `Name`, `Status__c`, `Total_Cost__c`     | Champs obligatoires, coût positif, statut cohérent.     |
| `Contract`          | `Amount__c`, `Number_of_Participants__c`, `Status` | Montant > 0, dates valides, suppression interdite.      |

---

Tayassi Karim  
**Dernière mise à jour :[27/12/2024]
