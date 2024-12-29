# TriggerHelper

## Description
`TriggerHelper` est une classe utilitaire conçue pour gérer la désactivation temporaire des validations dans les déclencheurs (triggers) Salesforce. 

Elle est principalement utilisée dans des cas spécifiques comme les traitements **Batch Apex** ou **Schedulers**, où l'exécution des triggers pourrait interférer avec la logique métier ou entraîner des erreurs inattendues.


## Structure de la classe
```apex
public class TriggerHelper {
    public static Boolean skipValidation = false; // Par défaut, les validations sont activées
}
```

### Attribut : `skipValidation`
- **Type** : `Boolean`
- **Valeur par défaut** : `false`
- **Rôle** : Indique si les validations doivent être ignorées (`true`) ou appliquées (`false`).
- **Visibilité** : `public static` permet un accès global et direct dans toute l'application Apex.


## Cas d'utilisation
### 1. **Désactiver les validations dans un Batch Apex**
Lors de l'exécution de traitements en lot avec **`Database.Batchable`**, certaines validations dans les triggers peuvent devenir redondantes ou entraîner des erreurs.

Exemple dans une méthode `execute()` :

```apex
TriggerHelper.skipValidation = true;
try {
    update tripsToUpdate; // Mise à jour des enregistrements sans déclencher les validations
} finally {
    TriggerHelper.skipValidation = false; // Réactivation des validations
}
```

### 2. **Éviter les conflits lors d'une planification avec un Schedulable**
Lorsque des batchs planifiés modifient des enregistrements, il peut être nécessaire d'éviter que les triggers appliquent les règles de validation métier.

Exemple dans une classe **Schedulable** :
```apex
public void execute(SchedulableContext sc) {
    TriggerHelper.skipValidation = true;
    Database.executeBatch(new MyBatchClass(), 200);
    TriggerHelper.skipValidation = false;
}
```

### 3. **Prévenir des boucles infinies**
Dans des triggers complexes, utiliser `skipValidation` permet d'éviter des appels récursifs où les validations sont inutilement réappliquées.


## Exemple dans un Trigger
Voici un exemple d'utilisation de `TriggerHelper` dans un trigger :

```apex
trigger TripValidationTrigger on Trip__c (before insert, before update) {
    if (TriggerHelper.skipValidation) {
        return; // Ignore les validations si elles sont désactivées
    }

    for (Trip__c trip : Trigger.new) {
        if (trip.Total_Cost__c != null && trip.Total_Cost__c < 0) {
            trip.addError('Le coût total ne peut pas être négatif.');
        }
    }
}
```

Dans cet exemple :
- **Si `skipValidation` est `true`** : Le trigger quitte immédiatement, et aucune validation n'est exécutée.
- **Sinon** : Les validations sont appliquées normalement.


## Points importants
1. **Réinitialisation obligatoire** : 
   Assurez-vous de remettre `TriggerHelper.skipValidation = false;` après une exécution pour éviter d'impacter d'autres traitements.

2. **Bonne pratique** :
   Utilisez cette classe **seulement** dans des cas où la logique métier l'exige. Désactiver les validations ne doit pas être une solution permanente.

3. **Contexte approprié** :
   - **Batch Apex**
   - **Scheduled Apex**
   - **Triggers nécessitant une gestion conditionnelle des validations**


## Avantages
- **Flexibilité** : Permet un contrôle granulaire de l'exécution des triggers.
- **Performance** : Évite les exécutions inutiles dans des traitements volumineux.
- **Réduction des erreurs** : Prévient les conflits entre les batchs et les règles de validation dans les triggers.


## Résumé
La classe **`TriggerHelper`** joue un rôle clé dans l'optimisation des traitements Apex, en permettant de désactiver temporairement les validations des déclencheurs. Utilisée avec précaution, elle améliore la robustesse et la performance de votre code Apex.
