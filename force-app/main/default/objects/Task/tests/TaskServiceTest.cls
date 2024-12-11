@isTest
public class TaskServiceTest {

    @isTest
    static void testCRUDOperations() {
        // Créer un compte pour lier les tâches
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Étape 1 : Créer une tâche
        Id taskId = TaskService.createTask(
            'Appel client',
            'Not Started',
            'High',
            Date.today().addDays(3),
            acc.Id,
            null // Pas de WhoId pour ce test
        );
        System.assertNotEquals(null, taskId, 'La tâche aurait dû être créée.');

        // Étape 2 : Lire la tâche
        Task retrievedTask = TaskService.getTaskById(taskId);
        System.assertEquals('Not Started', retrievedTask.Status, 'Le statut initial devrait être "Not Started".');
        System.assertEquals('High', retrievedTask.Priority, 'La priorité initiale devrait être "High".');

        // Étape 3 : Mettre à jour le statut
        TaskService.updateTaskStatus(taskId, 'Completed');
        retrievedTask = TaskService.getTaskById(taskId);
        System.assertEquals('Completed', retrievedTask.Status, 'Le statut devrait être "Completed".');

        // Étape 4 : Supprimer la tâche
        TaskService.deleteTask(taskId);
        List<Task> tasks = [SELECT Id FROM Task WHERE Id = :taskId];
        System.assertEquals(0, tasks.size(), 'La tâche aurait dû être supprimée.');
    }

    @isTest
    static void testCreateTaskValidation() {
        // Tester la création d'une tâche avec des données invalides
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        try {
            // Tester la validation : Sujet vide
            TaskService.createTask(
                '',
                'Not Started',
                'High',
                Date.today().addDays(2),
                acc.Id,
                null
            );
            System.assert(false, 'Une exception aurait dû être levée pour un sujet vide.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Le sujet de la tâche est obligatoire.', e.getMessage());
        }

        try {
            // Tester la validation : Date d'activité passée
            TaskService.createTask(
                'Task invalid',
                'Not Started',
                'High',
                Date.today().addDays(-1),
                acc.Id,
                null
            );
            System.assert(false, 'Une exception aurait dû être levée pour une date passée.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('La date de l\'activité doit être aujourd\'hui ou dans le futur.', e.getMessage());
        }

        try {
            // Tester la validation : Priorité invalide
            TaskService.createTask(
                'Task invalid priority',
                'Not Started',
                'Critical',
                Date.today().addDays(2),
                acc.Id,
                null
            );
            System.assert(false, 'Une exception aurait dû être levée pour une priorité invalide.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('La priorité doit être "High", "Medium" ou "Low".', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateTaskPriorityValidation() {
        // Créer un compte pour lier la tâche
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer une tâche
        Task task = new Task(
            Subject = 'Follow-up Call',
            Status = 'Not Started',
            Priority = 'Medium',
            ActivityDate = Date.today().addDays(2),
            WhatId = acc.Id
        );
        insert task;

        Test.startTest();
        try {
            // Tester la mise à jour avec une priorité invalide
            TaskService.updateTaskPriority(task.Id, 'Critical');
            System.assert(false, 'Une exception aurait dû être levée pour une priorité invalide.');
        } catch (IllegalArgumentException e) {
            System.assertEquals('La priorité doit être "High", "Medium" ou "Low".', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testDeleteTasksByWhatId() {
        // Créer un compte pour lier les tâches
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer plusieurs tâches pour le même compte
        List<Task> tasksToCreate = new List<Task>();
        for (Integer i = 0; i < 3; i++) {
            tasksToCreate.add(new Task(
                Subject = 'Task ' + i,
                Status = 'Not Started',
                Priority = 'Medium',
                ActivityDate = Date.today().addDays(i + 1),
                WhatId = acc.Id
            ));
        }
        insert tasksToCreate;

        // Supprimer toutes les tâches associées au compte
        TaskService.deleteTasksByWhatId(acc.Id);

        // Vérifier qu'il n'y a plus de tâches associées au compte
        List<Task> tasksAfterDelete = [SELECT Id FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(0, tasksAfterDelete.size(), 'Aucune tâche n\'a été supprimée pour le compte.');
    }
}
