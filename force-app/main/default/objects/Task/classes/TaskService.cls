public class TaskService {

    // **Créer une tâche**
    public static Id createTask(String subject, String status, String priority, Date activityDate, Id whatId, Id whoId) {
        // Validation des autorisations CRUD
        CentralizedCrudValidation.validateCrud('Task', 'create');

        // **Validation métier**
        if (String.isBlank(subject)) {
            throw new IllegalArgumentException('Le sujet de la tâche est obligatoire.');
        }

        if (activityDate == null || activityDate < Date.today()) {
            throw new IllegalArgumentException('La date de l\'activité doit être aujourd\'hui ou dans le futur.');
        }

        if (priority != 'High' && priority != 'Medium' && priority != 'Low') {
            throw new IllegalArgumentException('La priorité doit être "High", "Medium" ou "Low".');
        }

        Task newTask = new Task(
            Subject = subject,
            Status = status,
            Priority = priority,
            ActivityDate = activityDate,
            WhatId = whatId, // ID de l'objet lié (par exemple, Account, Opportunity)
            WhoId = whoId    // ID de la personne liée (Contact ou Lead)
        );

        insert newTask;
        System.debug('Nouvelle tâche créée : ' + newTask.Id);
        return newTask.Id;
    }

    // **Lire une tâche par ID**
    public static Task getTaskById(Id taskId) {
        // Validation des autorisations CRUD
        CentralizedCrudValidation.validateCrud('Task', 'read');

        return [SELECT Id, Subject, Status, Priority, ActivityDate, WhatId, WhoId 
                FROM Task 
                WHERE Id = :taskId];
    }

    // **Lire les tâches liées à un enregistrement**
    public static List<Task> getTasksByWhatId(Id whatId) {
        // Validation des autorisations CRUD
        CentralizedCrudValidation.validateCrud('Task', 'read');

        return [SELECT Id, Subject, Status, Priority, ActivityDate, WhatId, WhoId 
                FROM Task 
                WHERE WhatId = :whatId];
    }

    // **Lire les tâches ouvertes**
    public static List<Task> getOpenTasksByWhatId(Id whatId) {
        // Validation des autorisations CRUD
        CentralizedCrudValidation.validateCrud('Task', 'read');

        return [SELECT Id, Subject, Status, Priority, ActivityDate, WhatId, WhoId 
                FROM Task 
                WHERE WhatId = :whatId AND Status != 'Completed'];
    }

    // **Mettre à jour le statut d'une tâche**
    public static void updateTaskStatus(Id taskId, String newStatus) {
        // Validation des autorisations CRUD
        CentralizedCrudValidation.validateCrud('Task', 'update');

        Task taskToUpdate = [SELECT Id, Status FROM Task WHERE Id = :taskId];
        taskToUpdate.Status = newStatus;

        update taskToUpdate;
        System.debug('Statut de la tâche mis à jour : ' + taskToUpdate.Id + ' -> ' + newStatus);
    }

    // **Mettre à jour la priorité d'une tâche**
    public static void updateTaskPriority(Id taskId, String newPriority) {
        // Validation des autorisations CRUD
        CentralizedCrudValidation.validateCrud('Task', 'update');

        if (newPriority != 'High' && newPriority != 'Medium' && newPriority != 'Low') {
            throw new IllegalArgumentException('La priorité doit être "High", "Medium" ou "Low".');
        }

        Task taskToUpdate = [SELECT Id, Priority FROM Task WHERE Id = :taskId];
        taskToUpdate.Priority = newPriority;

        update taskToUpdate;
        System.debug('Priorité de la tâche mise à jour : ' + taskToUpdate.Id + ' -> ' + newPriority);
    }

    // **Supprimer une tâche**
    public static void deleteTask(Id taskId) {
        // Validation des autorisations CRUD
        CentralizedCrudValidation.validateCrud('Task', 'delete');

        Task taskToDelete = [SELECT Id FROM Task WHERE Id = :taskId];
        delete taskToDelete;
        System.debug('Tâche supprimée : ' + taskToDelete.Id);
    }

    // **Supprimer toutes les tâches liées à un enregistrement**
    public static void deleteTasksByWhatId(Id whatId) {
        // Validation des autorisations CRUD
        CentralizedCrudValidation.validateCrud('Task', 'delete');

        List<Task> tasksToDelete = [SELECT Id FROM Task WHERE WhatId = :whatId];
        delete tasksToDelete;
        System.debug('Tâches supprimées pour l\'enregistrement : ' + whatId);
    }
}
