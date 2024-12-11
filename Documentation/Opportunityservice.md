# OpportunityService

## Description
`OpportunityService` gère les opérations CRUD et les validations métiers pour l'objet Opportunity.

## Fonctionnalités principales
1. **createOpportunity** : Crée une opportunité avec validation des permissions et des données métier.
2. **getOpportunityByName** : Recherche une opportunité par son nom.
3. **updateOpportunityStage** : Met à jour le stade d'une opportunité.
4. **deleteOpportunity** : Supprime une opportunité.

## Règles métier
- Une opportunité doit être liée à un compte.
- Le montant (`Amount`) ne peut pas être négatif.
- La date de clôture (`CloseDate`) doit être une date future.
- La date de fin du voyage doit être postérieure à la date de début.

## Exemple d'utilisation
```apex
// Création d'une opportunité
Id oppId = OpportunityService.createOpportunity(
    'New Opportunity',
    'Prospecting',
    Date.today().addDays(10),
    accountId,
    Date.today(),
    Date.today().addDays(5)
);

// Mise à jour du stade
OpportunityService.updateOpportunityStage(oppId, 'Closed Won');

// Suppression de l'opportunité
OpportunityService.deleteOpportunity(oppId);
