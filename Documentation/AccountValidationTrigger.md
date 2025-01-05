# Explication du code : AccountValidationTrigger

Ce fichier explique le fonctionnement du déclencheur Apex `AccountValidationTrigger`, qui applique des règles de validation sur les comptes (`Account`) dans Salesforce.

## Déclaration du déclencheur
```java
trigger AccountValidationTrigger on Account (before insert, before update) {
```
Le déclencheur est configuré pour s'exécuter :
- **Avant l'insertion (`before insert`)** : pour valider les données des nouveaux comptes avant leur insertion dans la base de données.
- **Avant la mise à jour (`before update`)** : pour valider les modifications apportées aux comptes existants avant leur enregistrement.

---

## Logique principale

### Parcours des enregistrements dans `Trigger.new`
```java
for (Account acc : Trigger.new) {
    Account oldAcc = Trigger.isUpdate ? Trigger.oldMap.get(acc.Id) : null;
    ValidationHelper.validateAccount(acc, oldAcc);
}
```
#### Étapes :
1. **Parcours des nouveaux enregistrements** :
   - `Trigger.new` contient les comptes nouvellement insérés ou mis à jour.

2. **Gestion des mises à jour** :
   - Si le déclencheur est exécuté lors d'une mise à jour (`Trigger.isUpdate`), récupère la version précédente du compte à partir de `Trigger.oldMap`.
   - Si le déclencheur est exécuté lors d'une insertion, l'ancien compte (`oldAcc`) est défini sur `null`.

3. **Validation des comptes** :
   - Appelle la méthode `ValidationHelper.validateAccount`, qui applique les règles de validation sur l'enregistrement actuel.

---

## Points clés
1. **Réutilisation de la logique** :
   - La logique de validation est centralisée dans la classe `ValidationHelper`, ce qui facilite la maintenance et l'évolution des règles métier.

2. **Gestion des cas d'insertion et de mise à jour** :
   - Le déclencheur est capable de différencier les insertions des mises à jour et d'agir en conséquence.

3. **Robustesse** :
   - L'utilisation de `Trigger.new` et `Trigger.oldMap` permet de comparer les valeurs anciennes et nouvelles pour valider les modifications apportées aux enregistrements.

---

## Résumé
Le déclencheur `AccountValidationTrigger` :
1. S'exécute avant l'insertion ou la mise à jour des comptes.
2. Appelle la méthode `validateAccount` de la classe `ValidationHelper` pour appliquer les règles de validation définies.
3. Garantit que les comptes respectent les règles métier avant d'être enregistrés dans Salesforce.

Ce déclencheur suit les bonnes pratiques en séparant les responsabilités entre le déclencheur et la logique métier, tout en assurant une gestion claire des cas d'insertion et de mise à jour.
