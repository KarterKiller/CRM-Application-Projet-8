@isTest
public class ContractServiceTest {

    @isTest
    static void testCRUDOperations() {
        // Créer un compte pour les tests
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer un contrat
        Id contractId = ContractService.createContract(acc.Id, 12, Date.today(), 'Draft');
        System.assertNotEquals(null, contractId, 'Le contrat aurait dû être créé.');

        // Lire le contrat
        Contract retrievedContract = ContractService.getContractById(contractId);
        System.assertEquals('Draft', retrievedContract.Status, 'Le statut initial devrait être "Draft".');

        // Mettre à jour le statut
        ContractService.updateContractStatus(contractId, 'Activated');
        retrievedContract = ContractService.getContractById(contractId);
        System.assertEquals('Activated', retrievedContract.Status, 'Le statut devrait être "Activated".');

        // Supprimer le contrat
        ContractService.deleteContract(contractId);
        List<Contract> contracts = [SELECT Id FROM Contract WHERE Id = :contractId];
        System.assertEquals(0, contracts.size(), 'Le contrat aurait dû être supprimé.');
    }
}
