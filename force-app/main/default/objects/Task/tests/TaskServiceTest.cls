@isTest
public class TaskServiceTest {

    @isTest
    static void testCRUDOperations() {
        // Créer un compte pour lier les tâches
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer une tâche
        Id taskId = TaskService.createTask(
            'Appel client',
            'Not Started',
            'High',
            Date.today().addDays(3),
            acc.Id,
            null // Pas de WhoId
        );
        System.assertNotEquals(null, taskId, 'La tâche aurait dû être créée.');

        // Lire la tâche
        Task retrievedTask = TaskService.getTaskById(taskId);
        System.assertEquals('Not Started', retrievedTask.Status, 'Le statut initial devrait être "Not Started".');

        // Mettre à jour le statut
        TaskService.updateTaskStatus(taskId, 'Completed');
        retrievedTask = TaskService.getTaskById(taskId);
        System.assertEquals('Completed', retrievedTask.Status, 'Le statut devrait être "Completed".');

        // Supprimer la tâche
        TaskService.deleteTask(taskId);
        List<Task> tasks = [SELECT Id FROM Task WHERE Id = :taskId];
        System.assertEquals(0, tasks.size(), 'La tâche aurait dû être supprimée.');
    }

    // Test de création d'une tâche
    @isTest
    static void testCreateTask() {
        // Créer un compte pour lier la tâche
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer une tâche
        Id taskId = TaskService.createTask(
            'Follow-up Call',
            'Not Started',  // Statut de la tâche
            'High',         // Priorité de la tâche
            Date.today().addDays(2), // Date de l'activité
            acc.Id,         // Lier à un enregistrement (Account)
            null            // Pas de contact spécifique
        );

        // Vérifier que la tâche a été créée
        Task newTask = [SELECT Id, Subject, Status, Priority, ActivityDate, WhatId FROM Task WHERE Id = :taskId];
        System.assertNotEquals(null, newTask, 'La tâche n\'a pas été créée.');
        System.assertEquals('Follow-up Call', newTask.Subject, 'Le sujet de la tâche est incorrect.');
        System.assertEquals('Not Started', newTask.Status, 'Le statut de la tâche est incorrect.');
        System.assertEquals('High', newTask.Priority, 'La priorité de la tâche est incorrecte.');
        System.assertEquals(acc.Id, newTask.WhatId, 'Le WhatId de la tâche est incorrect.');
    }

    // Test de mise à jour du statut d'une tâche
    @isTest
    static void testUpdateTaskStatus() {
        // Créer un compte pour lier la tâche
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer une tâche
        Task task = new Task(
            Subject = 'Follow-up Call',
            Status = 'Not Started',
            Priority = 'High',
            ActivityDate = Date.today().addDays(2),
            WhatId = acc.Id
        );
        insert task;

        // Mettre à jour le statut de la tâche
        TaskService.updateTaskStatus(task.Id, 'Completed');
        
        // Vérifier la mise à jour du statut
        task = [SELECT Status FROM Task WHERE Id = :task.Id];
        System.assertEquals('Completed', task.Status, 'Le statut de la tâche n\'a pas été mis à jour correctement.');
    }

    // Test de mise à jour de la priorité d'une tâche
    @isTest
    static void testUpdateTaskPriority() {
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

        // Mettre à jour la priorité de la tâche
        TaskService.updateTaskPriority(task.Id, 'High');
        
        // Vérifier la mise à jour de la priorité
        task = [SELECT Priority FROM Task WHERE Id = :task.Id];
        System.assertEquals('High', task.Priority, 'La priorité de la tâche n\'a pas été mise à jour correctement.');
    }

    // Test de suppression d'une tâche
    @isTest
    static void testDeleteTask() {
        // Créer un compte pour lier la tâche
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer une tâche
        Task task = new Task(
            Subject = 'Follow-up Call',
            Status = 'Not Started',
            Priority = 'High',
            ActivityDate = Date.today().addDays(2),
            WhatId = acc.Id
        );
        insert task;

        // Supprimer la tâche
        TaskService.deleteTask(task.Id);

        // Vérifier que la tâche a bien été supprimée
        List<Task> tasks = [SELECT Id FROM Task WHERE Id = :task.Id];
        System.assertEquals(0, tasks.size(), 'La tâche n\'a pas été supprimée.');
    }

    // Test de suppression de toutes les tâches liées à un enregistrement (par exemple, Account)
    @isTest
    static void testDeleteTasksByWhatId() {
        // Créer un compte pour lier les tâches
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer plusieurs tâches pour le même compte
        List<Task> tasksToCreate = new List<Task>();
        for (Integer i = 0; i < 5; i++) {
            tasksToCreate.add(new Task(
                Subject = 'Follow-up Call ' + i,
                Status = 'Not Started',
                Priority = 'Medium',
                ActivityDate = Date.today().addDays(2),
                WhatId = acc.Id
            ));
        }
        insert tasksToCreate;

        // Vérifier qu'il y a bien 5 tâches associées au compte
        List<Task> tasksBeforeDelete = [SELECT Id FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(5, tasksBeforeDelete.size(), 'Il devrait y avoir 5 tâches.');

        // Supprimer toutes les tâches associées au compte
        TaskService.deleteTasksByWhatId(acc.Id);

        // Vérifier qu'il n'y a plus de tâches associées au compte
        List<Task> tasksAfterDelete = [SELECT Id FROM Task WHERE WhatId = :acc.Id];
        System.assertEquals(0, tasksAfterDelete.size(), 'Aucune tâche n\'a été supprimée pour le compte.');
    }
}

