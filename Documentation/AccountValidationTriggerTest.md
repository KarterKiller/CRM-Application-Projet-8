1. Objectif
La classe AccountValidationTriggerTest est conçue pour tester les règles de validation définies dans le trigger AccountValidationTrigger.
Elle s'assure que les erreurs appropriées sont levées lors de la création ou de la mise à jour d'un compte.

2. Scénarios de test
2.1 Validation du nom obligatoire
Règle testée : Le champ Name est obligatoire.
Scénario :
Tenter d'insérer un compte sans nom.
Vérifier qu'une erreur est levée avec le bon message.


2.2 Validation du numéro de téléphone
Règle testée : Le champ Phone doit contenir exactement 10 chiffres.
Scénario :
Tenter d'insérer un compte avec un numéro de téléphone incorrect.
Vérifier qu'une erreur est levée avec le bon message.


2.3 Validation du statut "Active__c"
Règle testée : Le champ Active__c doit avoir la valeur "Yes".
Scénario :
Tenter d'insérer un compte avec Active__c = "No".
Vérifier qu'une erreur est levée avec le bon message.

3. Couverture de code
Nom du test	                    Cas de test	                                      Résultat attendu
testAccountNameValidation	      Création d'un compte sans nom	                    Erreur : "Le nom du compte est obligatoire."
testPhoneValidation	            Création d'un compte avec un numéro invalide	        Erreur : "Le numéro de téléphone doit contenir exactement 10 chiffres."
testStatusValidation	          Création d'un compte avec Active__c = "No"	          Erreur : "Le champ Active__c doit avoir la valeur Yes."


4. Bonnes pratiques respectées
Isolation des tests : Chaque méthode teste une règle métier spécifique.
Assertions détaillées : Les messages d'erreur sont validés précisément.
Tests négatifs : Les cas d'erreur sont systématiquement couverts.
Données minimales : Utilisation d'objets avec uniquement les champs requis pour chaque scénario.


5. Exécution des tests
Pour exécuter cette classe de test :

Developer Console :

Ouvrir la Developer Console dans Salesforce.
Aller dans Test > New Run.
Sélectionner AccountValidationTriggerTest et exécuter.


6. Résumé
Trigger testé : AccountValidationTrigger
Classe de test : AccountValidationTriggerTest
Nombre de méthodes : 3
Objectif principal : Valider que les règles métiers sont respectées avant la création ou mise à jour des comptes.