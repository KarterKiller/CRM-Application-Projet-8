@isTest
public class TaskControllerTest {

    @isTest
    static void testGetTaskHistory() {
        // 1. Préparer les données de test
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        Contact contact = new Contact(LastName = 'Test Contact', AccountId = acc.Id, Email = 'test@test.com');
        insert contact;

        Task task1 = new Task(
            Subject = 'Test Task 1',
            Status = 'Not Started',
            Priority = 'High',
            ActivityDate = Date.today().addDays(2),
            WhatId = acc.Id,
            WhoId = contact.Id
        );

        Task task2 = new Task(
            Subject = 'Test Task 2',
            Status = 'Completed',
            Priority = 'Medium',
            ActivityDate = Date.today().addDays(1),
            WhatId = acc.Id
        );

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
