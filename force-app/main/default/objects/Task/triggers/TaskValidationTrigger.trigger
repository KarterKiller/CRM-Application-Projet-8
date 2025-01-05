trigger TaskValidationTrigger on Task (before insert, before update) {
    // Appeler ValidationHelper pour gérer les validations des tâches
    ValidationHelper.validateTask(Trigger.new, Trigger.oldMap);
}
