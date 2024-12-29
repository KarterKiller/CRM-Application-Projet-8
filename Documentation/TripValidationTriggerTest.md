# Tests Unitaires pour `TripValidationTrigger`

---

## **Objectif**

La classe **`TripValidationTriggerTest`** teste les règles de validation implémentées dans le trigger **`TripValidationTrigger`** pour l'objet personnalisé **`Trip__c`**.  
Elle couvre les scénarios d'insertion et de mise à jour des enregistrements pour s'assurer que les validations fonctionnent correctement.

---

## **Scénarios de Test Couverts**

### **1. Validation à l'insertion (`testValidationOnInsert`)**

#### **a. Nom vide**
- **Condition :** Le champ `Name` est vide.
- **Résultat attendu :** Une exception est levée avec le message :  
  *"Le nom du voyage est obligatoire."*

#### **b. Date de fin invalide**
- **Condition :** `EndTripDate__c` ≤ `StartTripDate__c`.
- **Résultat attendu :** Une exception est levée avec le message :  
  *"La date de fin doit être postérieure à la date de début."*

#### **c. Coût total négatif**
- **Condition :** `Total_Cost__c` < 0.
- **Résultat attendu :** Une exception est levée avec le message :  
  *"Le coût total ne peut pas être négatif."*

---

### **2. Validation à la mise à jour (`testValidationOnUpdate`)**

#### **a. Statut "Terminé" avec une date de fin future**
- **Condition :** Le champ `Status__c` est défini sur **"Terminé"** alors que `EndTripDate__c` est dans le futur.
- **Résultat attendu :** Une exception est levée avec le message :  
  *"Un voyage avec une date de fin dans le futur ne peut pas être marqué comme 'Terminé'."*

---

### **3. Insertion et mise à jour réussies (`testSuccessfulInsertAndUpdate`)**

#### **a. Insertion réussie**
- **Condition :** Tous les champs obligatoires sont remplis et valides.
- **Résultat attendu :** Le voyage est inséré avec succès.

#### **b. Mise à jour réussie**
- **Condition :** Mise à jour du champ `Status__c` sur **"Annulé"**.
- **Résultat attendu :** Le statut est mis à jour avec succès.

---

## **Code Complet**

```apex
@isTest
public class TripValidationTriggerTest {

    @isTest
    static void testValidationOnInsert() {
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        insert testAccount;

        // Test avec un nom vide
        Trip__c trip = new Trip__c(
            Name = '',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Status__c = 'A venir',
            Total_Cost__c = 1000,
            Account__c = testAccount.Id
        );

        try {
            insert trip;
            System.assert(false, 'L\'insertion aurait dû échouer en raison d\'un nom vide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le nom du voyage est obligatoire.'), 'Message d\'erreur inattendu.');
        }

        // Test avec une date de fin invalide
        trip.Name = 'Test Trip';
        trip.EndTripDate__c = Date.today();

        try {
            insert trip;
            System.assert(false, 'L\'insertion aurait dû échouer en raison d\'une date de fin invalide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La date de fin doit être postérieure à la date de début.'), 'Message d\'erreur inattendu.');
        }

        // Test avec un coût négatif
        trip.EndTripDate__c = Date.today().addDays(7);
        trip.Total_Cost__c = -500;

        try {
            insert trip;
            System.assert(false, 'L\'insertion aurait dû échouer en raison d\'un coût total négatif.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le coût total ne peut pas être négatif.'), 'Message d\'erreur inattendu.');
        }
    }

    @isTest
    static void testValidationOnUpdate() {
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        insert testAccount;

        Trip__c trip = new Trip__c(
            Name = 'Test Trip',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Status__c = 'A venir',
            Total_Cost__c = 1000,
            Account__c = testAccount.Id
        );
        insert trip;

        // Essayer de mettre à jour le voyage avec un statut "Terminé" et une date de fin future
        trip.Status__c = 'Terminé';
        trip.EndTripDate__c = Date.today().addDays(10);

        try {
            update trip;
            System.assert(false, 'La mise à jour aurait dû échouer car le voyage ne peut pas être terminé avec une date de fin future.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Un voyage avec une date de fin dans le futur ne peut pas être marqué comme "Terminé".'), 'Message d\'erreur inattendu.');
        }
    }

    @isTest
    static void testSuccessfulInsertAndUpdate() {
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        insert testAccount;

        // Insertion réussie
        Trip__c trip = new Trip__c(
            Name = 'Valid Trip',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Status__c = 'A venir',
            Total_Cost__c = 2000,
            Account__c = testAccount.Id
        );
        insert trip;
        System.assertNotEquals(null, trip.Id, 'Le voyage aurait dû être inséré.');

        // Mise à jour réussie
        trip.Status__c = 'Annulé';
        trip.EndTripDate__c = Date.today().addDays(1);
        update trip;

        Trip__c updatedTrip = [SELECT Status__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals('Annulé', updatedTrip.Status__c, 'Le statut du voyage aurait dû être mis à jour.');
    }
}
