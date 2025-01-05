# Documentation : CrudFLSTest

## Objectif du Test

Le test **CrudFLSTest** a pour but de valider que :
1. Les permissions **CRUD** (Create, Read, Update, Delete) sur l'objet `Account` sont correctement appliquées.
2. Les permissions **FLS** (Field-Level Security) sur les champs de l'objet `Account` sont respectées.
3. Les enregistrements de test sont créés et accessibles selon les permissions définies.

---

## Structure du Test

### Classe : `CrudFLSTest`

#### Méthode : `testCrudFlsEnforcement`

1. **Création d’un enregistrement de test :**
   - Utilisation de la méthode `TestDataFactory.createAccount(true)` pour générer et insérer un enregistrement `Account`.
   - Cette méthode centralise la création des données de test et garantit une uniformité.

   ```apex
   Account testAccount = TestDataFactory.createAccount(true);
