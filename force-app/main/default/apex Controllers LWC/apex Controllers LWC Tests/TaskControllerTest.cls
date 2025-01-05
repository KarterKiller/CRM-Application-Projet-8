@isTest
public class TaskControllerTest {

    @isTest
    static void testGetTaskHistory() {
        // 1. Préparer les données de test
        // Créer un compte et un contact via TestDataFactory
        Account acc = TestDataFactory.createAccount(true);
        Contact contact = TestDataFactory.createContact(acc.Id, true);

        // Créer deux tâches via TestDataFactory
        Task task1 = TestDataFactory.createTask(acc.Id, contact.Id, false);
        task1.Subject = 'Test Task 1';
        task1.Status = 'Not Started';
        task1.Priority = 'High';
        task1.ActivityDate = Date.today().addDays(2);

        Task task2 = TestDataFactory.createTask(acc.Id, null, false);
        task2.Subject = 'Test Task 2';
        task2.Status = 'Completed';
        task2.Priority = 'Medium';
        task2.ActivityDate = Date.today().addDays(1);

        // Insérer les tâches
        insert new List<Task>{ task1, task2 };

        // 2. Appeler la méthode à tester
        Test.startTest();
        List<Task> tasks = TaskController.getTaskHistory();
        Test.stopTest();

        // 3. Vérifications
        System.assertNotEquals(0, tasks.size(), 'La liste des tâches ne devrait pas être vide.');
        System.assertEquals(2, tasks.size(), 'Le nombre de tâches récupérées devrait être 2.');
        System.assertEquals('Test Task 1', tasks[0].Subject, 'La tâche la plus récente devrait être "Test Task 1".');
        System.assertEquals('Test Task 2', tasks[1].Subject, 'La deuxième tâche devrait être "Test Task 2".');
    }
}
