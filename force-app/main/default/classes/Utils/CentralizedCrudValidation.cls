public class CentralizedCrudValidation {

    public static void validateCrud(String objectName, String operation) {
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectName).getDescribe();

        if (operation.toLowerCase() == 'create') {
            if (!describeResult.isCreateable()) {
                throw new SecurityException('Vous n\'avez pas la permission de créer des enregistrements pour ' + objectName);
            }
        } else if (operation.toLowerCase() == 'read') {
            if (!describeResult.isAccessible()) {
                throw new SecurityException('Vous n\'avez pas la permission de lire des enregistrements pour ' + objectName);
            }
        } else if (operation.toLowerCase() == 'update') {
            if (!describeResult.isUpdateable()) {
                throw new SecurityException('Vous n\'avez pas la permission de mettre à jour des enregistrements pour ' + objectName);
            }
        } else if (operation.toLowerCase() == 'delete') {
            if (!describeResult.isDeletable()) {
                throw new SecurityException('Vous n\'avez pas la permission de supprimer des enregistrements pour ' + objectName);
            }
        } else {
            throw new IllegalArgumentException('Opération non prise en charge : ' + operation);
        }
    }
}
