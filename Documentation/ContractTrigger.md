# Explication du code : ContractTrigger

Ce fichier explique le fonctionnement du déclencheur Apex `ContractTrigger`, qui applique des règles de validation sur les contrats (`Contract`) dans Salesforce lors des opérations d'insertion, de mise à jour et de suppression.

## Déclaration du déclencheur
```java
trigger ContractTrigger on Contract (before insert, before update, before delete) {
```
Le déclencheur est configuré pour s'exécuter :
- **Avant l'insertion (`before insert`)** : pour valider les données des nouveaux contrats avant leur insertion dans la base de données.
- **Avant la mise à jour (`before update`)** : pour valider les modifications apportées aux contrats existants avant leur enregistrement.
- **Avant la suppression (`before delete`)** : pour valider les contrats avant leur suppression.

---

## Logique principale

### Insertion (`Trigger.isInsert`)
#### Code
```java
if (Trigger.isInsert) {
    for (Contract con : Trigger.new) {
        ValidationHelper.validateContractInsert(con);
    }
}
```
#### Fonctionnement
1. Parcourt les nouveaux contrats dans `Trigger.new`.
2. Appelle la méthode `ValidationHelper.validateContractInsert` pour valider chaque contrat.

### Mise à jour (`Trigger.isUpdate`)
#### Code
```java
if (Trigger.isUpdate) {
    for (Contract con : Trigger.new) {
        Contract oldCon = Trigger.oldMap.get(con.Id);
        ValidationHelper.validateContractUpdate(con, oldCon);
    }
}
```
#### Fonctionnement
1. Parcourt les contrats mis à jour dans `Trigger.new`.
2. Récupère l'ancienne version de chaque contrat à partir de `Trigger.oldMap`.
3. Appelle la méthode `ValidationHelper.validateContractUpdate` pour comparer les valeurs nouvelles et anciennes.

### Suppression (`Trigger.isDelete`)
#### Code
```java
if (Trigger.isDelete) {
    for (Contract con : Trigger.old) {
        ValidationHelper.validateContractDelete(con);
    }
}
```
#### Fonctionnement
1. Parcourt les contrats à supprimer dans `Trigger.old`.
2. Appelle la méthode `ValidationHelper.validateContractDelete` pour valider chaque contrat avant sa suppression.

---

## Points clés
1. **Modularité** :
   - Les validations sont déléguées à des méthodes spécifiques dans la classe `ValidationHelper`, rendant le code du déclencheur simple et maintenable.

2. **Gestion des trois événements principaux** :
   - Le déclencheur gère les validations séparément pour les insertions, mises à jour et suppressions.

3. **Utilisation de `Trigger.oldMap`** :
   - Lors des mises à jour, `Trigger.oldMap` permet de comparer les anciennes et nouvelles valeurs des enregistrements pour des validations plus précises.

---

## Résumé
Le déclencheur `ContractTrigger` :
1. Valide les contrats avant insertion, mise à jour ou suppression.
2. Délègue la logique de validation à la classe `ValidationHelper`.
3. Assure que les règles métier sont respectées pour tous les contrats manipulés dans Salesforce.

Ce déclencheur suit les bonnes pratiques en séparant les responsabilités et en gérant les validations spécifiques à chaque type d'événement.