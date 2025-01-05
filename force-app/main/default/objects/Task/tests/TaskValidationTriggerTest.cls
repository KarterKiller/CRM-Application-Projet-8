@isTest
public class TaskValidationTriggerTest {

    @isTest
    static void testValidationOnInsertSubjectEmpty() {
        // Créer un compte et un contact de test pour l'association
        Account acc = TestDataFactory.createAccount(true);
        Contact con = TestDataFactory.createContact(acc.Id, true);

        // Tâche avec un sujet vide
        Task task = TestDataFactory.createTask(acc.Id, con.Id, false);
        task.Subject = ''; // Sujet vide
        task.Status = 'Not Started'; // Statut valide
        task.WhoId = con.Id; // Association avec un contact valide

        Test.startTest();
        try {
            insert task;
            System.assertEquals(false, true, 'L\'insertion aurait dû échouer en raison d\'un sujet vide.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Le sujet de la tâche est obligatoire.'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertActivityDatePast() {
        // Créer un compte et un contact de test pour l'association
        Account acc = TestDataFactory.createAccount(true);
        Contact con = TestDataFactory.createContact(acc.Id, true);

        // Tâche avec une date d'activité passée
        Task task = TestDataFactory.createTask(acc.Id, con.Id, false);
        task.Subject = 'Test Task'; // Sujet valide
        task.Status = 'Not Started'; // Statut valide
        task.WhoId = con.Id; // Association avec un contact valide
        task.ActivityDate = Date.today().addDays(-1); // Date passée

        Test.startTest();
        try {
            insert task;
            System.assertEquals(false, true, 'L\'insertion aurait dû échouer en raison d\'une date d\'activité passée.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('La date de l\'activité doit être aujourd\'hui ou dans le futur.'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnInsertMissingWhoIdAndWhatId() {
        // Tâche sans relation associée (WhoId et WhatId)
        Task task = TestDataFactory.createTask(null, null, false);
        task.WhatId = null;
        task.WhoId = null;

        Test.startTest();
        try {
            insert task;
            System.assertEquals(false, true, 'L\'insertion aurait dû échouer en raison de l\'absence de WhatId et WhoId.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('La tâche doit être associée à un enregistrement via WhatId ou WhoId.'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnUpdateInvalidPriority() {
        // Insérer une tâche valide
        Account acc = TestDataFactory.createAccount(true);
        Task task = TestDataFactory.createTask(acc.Id, null, true);

        // Mettre une priorité invalide
        task.Priority = 'Urgent';

        Test.startTest();
        try {
            update task;
            System.assertEquals(false, true, 'La mise à jour aurait dû échouer en raison d\'une priorité invalide.');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('La priorité doit être "High", "Medium" ou "Low".'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidationOnUpdateCompletedStatusWithFutureDate() {
        // Insérer une tâche valide
        Account acc = TestDataFactory.createAccount(true);
        Task task = TestDataFactory.createTask(acc.Id, null, true);

        // Essayer de mettre le statut à "Completed" avec une date future
        task.Status = 'Completed';
        task.ActivityDate = Date.today().addDays(5); // Date future

        Test.startTest();
        try {
            update task;
            System.assertEquals(false, true, 'La mise à jour aurait dû échouer car une tâche avec une date future ne peut pas être "Completed".');
        } catch (DmlException e) {
            System.assertEquals(true, e.getMessage().contains('Une tâche avec une date d\'activité dans le futur ne peut pas être marquée comme "Completed".'), 'Message d\'erreur inattendu.');
        }
        Test.stopTest();
    }
}
