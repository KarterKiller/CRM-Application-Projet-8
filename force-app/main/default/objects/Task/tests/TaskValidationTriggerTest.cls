@isTest
public class TaskValidationTriggerTest {

    @isTest
    static void testValidationOnInsert() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        // Test avec un sujet vide
        Task task = new Task(
            Subject = '',
            Priority = 'High',
            ActivityDate = Date.today().addDays(1),
            WhatId = acc.Id
        );

        try {
            insert task;
            System.assert(false, 'L\'insertion aurait dû échouer en raison d\'un sujet vide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Le sujet de la tâche est obligatoire.'), 'Message d\'erreur inattendu.');
        }

        // Test avec une date d'activité passée
        task.Subject = 'Test Task';
        task.ActivityDate = Date.today().addDays(-1);

        try {
            insert task;
            System.assert(false, 'L\'insertion aurait dû échouer en raison d\'une date d\'activité passée.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La date de l\'activité doit être aujourd\'hui ou dans le futur.'), 'Message d\'erreur inattendu.');
        }
    }

    @isTest
    static void testValidationOnUpdate() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        Task task = new Task(
            Subject = 'Test Task',
            Priority = 'High',
            ActivityDate = Date.today(),
            WhatId = acc.Id
        );
        insert task;

        // Essayer de mettre à jour la tâche avec une priorité invalide
        task.Priority = 'Urgent';

        try {
            update task;
            System.assert(false, 'La mise à jour aurait dû échouer en raison d\'une priorité invalide.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La priorité doit être "High", "Medium" ou "Low".'), 'Message d\'erreur inattendu.');
        }

        // Essayer de mettre à jour la tâche avec une date future et le statut "Completed"
        task.Priority = 'Medium';
        task.Status = 'Completed';
        task.ActivityDate = Date.today().addDays(5);

        try {
            update task;
            System.assert(false, 'La mise à jour aurait dû échouer car la date d\'activité est dans le futur.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Une tâche avec une date d\'activité dans le futur ne peut pas être marquée comme "Completed".'), 'Message d\'erreur inattendu.');
        }
    }

    @isTest
    static void testSuccessfulInsertAndUpdate() {
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        // Insertion réussie
        Task task = new Task(
            Subject = 'Test Task',
            Priority = 'High',
            ActivityDate = Date.today().addDays(1),
            WhatId = acc.Id
        );
        insert task;
        System.assertNotEquals(null, task.Id, 'La tâche aurait dû être insérée.');

        // Mise à jour réussie
        task.Status = 'Completed';
        task.ActivityDate = Date.today();
        update task;
        Task updatedTask = [SELECT Status FROM Task WHERE Id = :task.Id];
        System.assertEquals('Completed', updatedTask.Status, 'Le statut de la tâche aurait dû être mis à jour.');
    }
}
