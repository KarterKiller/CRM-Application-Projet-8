public with sharing class TaskController {
    @AuraEnabled(cacheable=true)
    public static List<Task> getTaskHistory() {
        return [
            SELECT Id, Subject, Status, Priority, ActivityDate, Who.Name, What.Name 
            FROM Task 
            ORDER BY ActivityDate DESC
        ];
    }
}
