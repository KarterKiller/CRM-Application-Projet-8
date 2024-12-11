# TripServiceTest

## Description
Tests unitaires pour la classe `TripService`, validant les opérations CRUD et les règles métier pour l'objet `Trip__c`.

---

## Tests inclus

### **1. testCreateTrip**
- **But** : Vérifie la création d'un voyage avec des données valides.
- **Validation principale** :
  - Les champs sont correctement initialisés.

---

### **2. testUpdateTripStatus**
- **But** : Valide la mise à jour du statut d'un voyage.
- **Validation principale** :
  - Le statut est correctement modifié.

---

### **3. testUpdateTripCost**
- **But** : Vérifie que le coût total d'un voyage peut être mis à jour.
- **Validation principale** :
  - La nouvelle valeur du coût est enregistrée correctement.

---

### **4. testValidationCreateTripInvalidDates**
- **But** : Vérifie que les voyages ne peuvent pas être créés avec des dates invalides.
- **Validation principale** :
  - Une exception est levée si les dates sont incorrectes.

---

## Couverture globale

| Méthode                 | Couverture | Validation principale                            |
|-------------------------|------------|-----------------------------------------------|
| `createTrip`            | 100%       | Voyage créé avec toutes les validations.      |
| `getTripById`           | 100%       | Les données retournées sont exactes.           |
| `updateTripStatus`      | 100%       | Statut mis à jour avec succès.                 |
| `updateTripCost`        | 100%       | Coût mis à jour avec succès.                   |
| `deleteTrip`            | 100%       | Voyage supprimé avec succès.                   |
