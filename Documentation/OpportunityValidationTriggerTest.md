# OpportunityValidationTriggerTest

---

## **Objectif**

La classe **`OpportunityValidationTriggerTest`** est une classe de test unitaire Apex pour valider les règles métiers imposées par le trigger **`OpportunityValidationTrigger`**.  
Elle couvre les scénarios d'insertion et de mise à jour des opportunités, en simulant des cas de réussite et d'échec.

---

## **Scénarios Testés**

### **1. Validation sur insertion (`testValidationOnInsert`)**

#### **Cas testé :**  
- L'insertion d'une opportunité avec un **montant négatif**.

#### **Règle vérifiée :**  
- Le champ **`Amount`** doit être supérieur à **0**.  
- **Message attendu :** *"Le montant de l'opportunité est obligatoire et doit être supérieur à 0."*

#### **Exemple de Code :**  
```apex
@isTest
static void testValidationOnInsert() {
    Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
    insert acc;

    Opportunity opp = new Opportunity(
        Name = 'Invalid Opportunity',
        StageName = 'Prospecting',
        CloseDate = Date.today().addDays(10),
        AccountId = acc.Id,
        Amount = -100, // Montant négatif
        number_of_Participants__c = 10,
        StartTripDate__c = Date.today(),
        EndTripDate__c = Date.today().addDays(7),
        Destination__c = 'Paris'
    );

    try {
        insert opp;
        System.assert(false, 'L\'insertion aurait dû échouer en raison d\'un montant négatif.');
    } catch (DmlException e) {
        System.assert(e.getMessage().contains('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.'), 'Message d\'erreur inattendu.');
    }
}
