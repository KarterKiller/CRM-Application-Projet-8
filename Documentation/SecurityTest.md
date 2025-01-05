# Documentation : SecurityTest

## Objectif du Test

Le test **SecurityTest** a pour objectif de vérifier que :
1. Les utilisateurs avec des permissions restreintes (ex. profil **Standard User Test**) ne peuvent pas effectuer des actions non autorisées, comme modifier des enregistrements.
2. Les contrôles de sécurité, comme les **Organisation-Wide Defaults (OWD)** et les permissions de profil, sont correctement appliqués.
3. Les modifications non autorisées sur des objets Salesforce (ex. `Account`) sont bloquées.

---

## Structure du Test

### Classe : `SecurityTest`

#### Méthode : `testPreventUnauthorizedAccess`

1. **Création d’un utilisateur avec profil restreint :**
   - Utilisation du profil **"Standard User Test"** pour créer un utilisateur de test.
   - Cela simule un utilisateur avec des permissions limitées.

   ```apex
   Profile standardTestProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User Test' LIMIT 1];
   User standardUser = new User(
       FirstName = 'Test',
       LastName = 'User',
       Alias = 'tuser',
       Email = 'test.user@example.com',
       Username = 'test.user' + System.currentTimeMillis() + '@example.com',
       ProfileId = standardTestProfile.Id,
       TimeZoneSidKey = 'GMT',
       LocaleSidKey = 'en_US',
       EmailEncodingKey = 'UTF-8',
       LanguageLocaleKey = 'en_US'
   );
   insert standardUser;
