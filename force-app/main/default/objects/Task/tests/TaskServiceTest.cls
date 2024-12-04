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
}
