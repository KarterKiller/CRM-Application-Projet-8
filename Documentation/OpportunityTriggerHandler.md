# OpportunityTriggerHandler

---

## **Objectif**

La classe **`OpportunityTriggerHandler`** est une classe Apex de gestion des règles métiers pour l'objet **`Opportunity`**.  
Elle applique des validations sur les champs d'une opportunité et effectue des opérations supplémentaires comme la création d'un **voyage** (**Trip__c**) et d'un **contrat** (**Contract**) lorsque l'opportunité atteint le statut **"Closed Won"**.

---

## **1. Méthodes Principales**

### **1.1 Méthode `validateOpportunity`**

#### **Objectif :**  
Valider les champs obligatoires et les règles métiers pour chaque opportunité.

#### **Validations effectuées :**  
1. **Montant de l'opportunité :**  
   - `Amount` ne doit pas être null ou ≤ 0.  
   - **Message :** *"Le montant de l'opportunité est obligatoire et doit être supérieur à 0."*

2. **Dates de début et de fin du voyage :**  
   - `StartTripDate__c` et `EndTripDate__c` doivent être renseignées.  
   - La date de fin doit être postérieure à la date de début.  
   - **Message :**  
     - *"Les dates de début et de fin du voyage sont obligatoires."*  
     - *"La date de fin du voyage doit être postérieure à la date de début."*

3. **Relation avec un compte :**  
   - `AccountId` doit être renseigné.  
   - **Message :** *"L'opportunité doit être associée à un compte."*

4. **Nom de l'opportunité :**  
   - `Name` est obligatoire.  
   - **Message :** *"Le nom de l'opportunité est obligatoire."*

5. **Destination :**  
   - `Destination__c` est obligatoire.  
   - **Message :** *"La destination est obligatoire."*

6. **Nombre de participants :**  
   - `Number_of_Participants__c` ne doit pas être null ou ≤ 0.  
   - **Message :** *"Le nombre de participants est obligatoire et doit être supérieur à 0."*

#### **Code :**
```apex
public static void validateOpportunity(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
    for (Opportunity opp : newOpps) {
        if (opp.Amount == null || opp.Amount <= 0) {
            opp.addError('Le montant de l\'opportunité est obligatoire et doit être supérieur à 0.');
        }

        if (opp.StartTripDate__c == null || opp.EndTripDate__c == null) {
            opp.addError('Les dates de début et de fin du voyage sont obligatoires.');
        } else if (opp.EndTripDate__c <= opp.StartTripDate__c) {
            opp.addError('La date de fin du voyage doit être postérieure à la date de début.');
        }

        if (opp.AccountId == null) {
            opp.addError('L\'opportunité doit être associée à un compte.');
        }

        if (String.isBlank(opp.Name)) {
            opp.addError('Le nom de l\'opportunité est obligatoire.');
        }

        if (String.isBlank(opp.Destination__c)) {
            opp.addError('La destination est obligatoire.');
        }

        if (opp.Number_of_Participants__c == null || opp.Number_of_Participants__c <= 0) {
            opp.addError('Le nombre de participants est obligatoire et doit être supérieur à 0.');
        }
    }
}
