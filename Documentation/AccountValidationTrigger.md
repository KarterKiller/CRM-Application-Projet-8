# AccountValidationTrigger

## Description
Le trigger **AccountValidationTrigger** permet d'effectuer des validations personnalisées lors de la création ou de la mise à jour d'un enregistrement **Account** dans Salesforce. Il s'exécute dans les événements **before insert** et **before update** pour s'assurer que les données saisies respectent les règles métiers définies.

---

## Logique du Trigger
Le trigger vérifie plusieurs conditions avant d'autoriser l'insertion ou la mise à jour d'un compte. Si une condition échoue, un message d'erreur est renvoyé à l'utilisateur grâce à `addError()`.

### Conditions de validation :
1. **Nom obligatoire :**
   - Le champ `Name` ne doit pas être vide.
   ```apex
   if (String.isBlank(acc.Name)) {
       acc.addError('Le nom du compte est obligatoire.');
   }
   ```

2. **Industrie obligatoire :**
   - Le champ `Industry` doit être renseigné.
   ```apex
   if (String.isBlank(acc.Industry)) {
       acc.addError('Le champ "Industry" est obligatoire.');
   }
   ```

3. **Numéro de téléphone valide :**
   - Le champ `Phone` doit contenir exactement **10 chiffres** si rempli.
   ```apex
   if (!String.isBlank(acc.Phone) && !Pattern.matches('\\d{10}', acc.Phone)) {
       acc.addError('Le numéro de téléphone doit contenir exactement 10 chiffres.');
   }
   ```

4. **Statut actif requis :**
   - Le champ personnalisé `Active__c` doit avoir la valeur **"Yes"**.
   ```apex
   if (acc.Active__c != null && acc.Active__c != 'Yes') {
       acc.addError('Le champ "Active__c" doit avoir la valeur "Yes".');
   }
   ```

---

## Exemple de Code
Voici le code complet du trigger :
```apex
trigger AccountValidationTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        // Vérification : Le nom du compte est obligatoire
        if (String.isBlank(acc.Name)) {
            acc.addError('Le nom du compte est obligatoire.');
        }

        // Vérification : L'industrie est obligatoire
        if (String.isBlank(acc.Industry)) {
            acc.addError('Le champ "Industry" est obligatoire.');
        }

        // Vérification : Le numéro de téléphone doit être valide
        if (!String.isBlank(acc.Phone) && !Pattern.matches('\d{10}', acc.Phone)) {
            acc.addError('Le numéro de téléphone doit contenir exactement 10 chiffres.');
        }

        // Vérification : Le champ "Active__c" doit être "Yes"
        if (acc.Active__c != null && acc.Active__c != 'Yes') {
            acc.addError('Le champ "Active__c" doit avoir la valeur "Yes".');
        }
    }
}
```

---

## Points Importants
1. **Utilisation de `addError`** :
   - `addError` interrompt la transaction DML si une validation échoue et affiche un message d'erreur à l'utilisateur.
   - Exemple :
     ```apex
     acc.addError('Le nom du compte est obligatoire.');
     ```

2. **Validation dans les événements `before` :**
   - Les événements `before insert` et `before update` sont utilisés pour éviter les opérations inutiles (comme les requêtes SOQL ou DML) si les données ne respectent pas les règles métiers.

3. **Champ personnalisé `Active__c` :**
   - `Active__c` est une picklist avec des valeurs prédéfinies (ex. **Yes/No**). Le trigger vérifie que la valeur est bien **Yes** pour garantir la cohérence des données.

---

## Avantages du Trigger
- **Contrôle centralisé :** Toutes les règles de validation métier sont centralisées dans un seul trigger.
- **Meilleure expérience utilisateur :** Les utilisateurs reçoivent des messages d'erreur clairs et précis lors de la saisie des données.
- **Réduction des erreurs de données :** Empêche l'insertion ou la mise à jour de données non conformes aux règles métiers.

---

## Tests Unitaires
Un test unitaire doit vérifier chaque règle de validation pour garantir que le trigger fonctionne correctement.

### Exemple de Test Unitaire
```apex
@isTest
private class AccountValidationTriggerTest {
    @isTest
    static void testNameValidation() {
        Account acc = new Account(Industry = 'Finance', Phone = '1234567890', Active__c = 'Yes');

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Une exception aurait dû être levée pour un nom manquant.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le nom du compte est obligatoire.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testActiveFieldValidation() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Finance', Phone = '1234567890', Active__c = 'No');

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Une exception aurait dû être levée pour Active__c invalide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le champ "Active__c" doit avoir la valeur "Yes".'));
        }
        Test.stopTest();
    }
}
```

---

## Bonnes Pratiques
- **Éviter les triggers volumineux** : Conservez le trigger léger et déplacez la logique métier dans une classe handler.
- **Cohérence des données** : Vérifiez que les champs obligatoires et les relations respectent les règles métier.
- **Tests Unitaires Complets** : Assurez-vous de tester chaque validation pour couvrir tous les scénarios.

---

## Résumé
Le trigger **AccountValidationTrigger** garantit la qualité et la cohérence des données **Account** dans Salesforce en appliquant des validations strictes sur les champs clés : `Name`, `Industry`, `Phone` et `Active__c`. Grâce à des validations précises, il améliore la fiabilité des données dans l'organisation Salesforce.
