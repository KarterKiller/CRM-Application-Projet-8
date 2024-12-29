# ContractTriggerTest

---

## **Objectif**

La classe **`ContractTriggerTest`** est une classe de test unitaire en Apex pour vérifier les règles métiers définies dans le trigger associé à l'objet **`Contract`**.

Cette classe garantit que :
1. **Les validations métiers** (montant positif, dates valides, etc.) sont correctement appliquées.
2. **Les erreurs appropriées** sont levées en cas de données non conformes.
3. Les inserts, updates et deletes respectent les contraintes spécifiques.

---

## **1. Structure des Tests**

### **1.1 Méthode `testValidationOnInsertNegativeAmount`**

- **Objectif :** Vérifier qu'un contrat avec un montant négatif ne peut pas être inséré.
- **Condition testée :**
   - `Amount__c <= 0`
- **Message attendu :** "Le montant du contrat doit être supérieur à 0."

#### **Code :**
```apex
@isTest
static void testValidationOnInsertNegativeAmount() {
    Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
    insert acc;

    Contract con = new Contract(
        Name = 'Test Contract',
        AccountId = acc.Id,
        StartTripDate__c = Date.today(),
        EndTripDate__c = Date.today().addDays(7),
        Amount__c = -500,
        Number_of_Participants__c = 10,
        Status = 'Draft'
    );

    Test.startTest();
    try {
        insert con;
        System.assert(false, 'Une exception aurait dû être levée pour un montant négatif.');
    } catch (DmlException e) {
        System.assert(e.getMessage().contains('Le montant du contrat doit être supérieur à 0.'));
    }
    Test.stopTest();
}
