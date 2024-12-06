@isTest
private class ContractServiceTest {

    @isTest
    static void testCreateContractFromOpportunity() {
        // Créer un compte de test
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Créer une opportunité liée au compte
        Opportunity testOpportunity = new Opportunity(
            AccountId = testAccount.Id,
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 5000,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(7),
            Destination__c = 'Paris',
            Number_of_Participants__c = 20
        );
        insert testOpportunity;

        // Créer un contrat à partir de l'opportunité
        Id contractId = ContractService.createContractFromOpportunity(testOpportunity.Id);

        // Récupérer le contrat après création
        Contract createdContract = [SELECT Id, Opportunity__c, AccountId, Name, Amount__c, Destination__c, Number_of_Participants__c 
                                    FROM Contract 
                                    WHERE Id = :contractId];
        
        // Vérifier que le contrat a bien été créé et que les données sont correctement insérées
        System.assertEquals(testOpportunity.Id, createdContract.Opportunity__c, 'Le contrat doit être lié à l\'opportunité');
        System.assertEquals(testOpportunity.AccountId, createdContract.AccountId, 'Le contrat doit être lié au même compte que l\'opportunité');
        System.assertEquals('Contract for Test Opportunity', createdContract.Name, 'Le nom du contrat doit correspondre à l\'opportunité');
        System.assertEquals(5000, createdContract.Amount__c, 'Le montant du contrat doit correspondre à celui de l\'opportunité');
        System.assertEquals('Paris', createdContract.Destination__c, 'La destination doit être correctement récupérée de l\'opportunité');
        System.assertEquals(20, createdContract.Number_of_Participants__c, 'Le nombre de participants doit correspondre à celui de l\'opportunité');
    }

    @isTest
    static void testGetContractById() {
        // Créer un compte et un contrat
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            Opportunity__c = null, // Aucune opportunité liée pour ce test
            Name = 'Test Contract',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 1000,
            Status = 'Draft'
        );
        insert testContract;

        // Récupérer le contrat par ID
        Contract retrievedContract = [SELECT Id, Name, Amount__c, Status FROM Contract WHERE Id = :testContract.Id LIMIT 1];

        // Vérifier les données du contrat récupéré
        System.assertNotEquals(null, retrievedContract, 'Le contrat devrait être récupéré.');
        System.assertEquals('Test Contract', retrievedContract.Name, 'Le nom du contrat doit correspondre.');
        System.assertEquals(1000, retrievedContract.Amount__c, 'Le montant du contrat doit correspondre.');
        System.assertEquals('Draft', retrievedContract.Status, 'Le statut du contrat doit correspondre.');
    }

    @isTest
    static void testUpdateContractStatus() {
        // Créer un compte et un contrat
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            Opportunity__c = null, // Aucune opportunité liée pour ce test
            Name = 'Test Contract',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 1000,
            Status = 'Draft'
        );
        insert testContract;

        // Appeler la méthode pour mettre à jour le statut du contrat
        ContractService.updateContractStatus(testContract.Id, 'Activated');

        // Récupérer le contrat mis à jour et vérifier son statut
        testContract = [SELECT Status FROM Contract WHERE Id = :testContract.Id];
        System.assertEquals('Activated', testContract.Status, 'Le statut du contrat doit être mis à jour.');
    }

    @isTest
    static void testDeleteContract() {
        // Créer un compte et un contrat
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            Opportunity__c = null, // Aucune opportunité liée pour ce test
            Name = 'Test Contract',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 1000,
            Status = 'Draft'
        );
        insert testContract;

        // Vérifier que le contrat existe avant la suppression
        Contract contractBeforeDelete = [SELECT Id FROM Contract WHERE Id = :testContract.Id LIMIT 1];
        System.assertNotEquals(null, contractBeforeDelete, 'Le contrat devrait exister avant la suppression.');

        // Supprimer le contrat
        ContractService.deleteContract(testContract.Id);

        // Vérifier que le contrat a bien été supprimé
        try {
            Contract contractAfterDelete = [SELECT Id FROM Contract WHERE Id = :testContract.Id LIMIT 1];
            System.assert(false, 'Le contrat devrait être supprimé.');
        } catch (QueryException e) {
            System.debug('Contrat bien supprimé, erreur attendue : ' + e.getMessage());
        }
    }

    @isTest
    static void testDeleteContractsByAccountId() {
        // Créer un compte
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Créer plusieurs contrats pour le compte
        List<Contract> contracts = new List<Contract>();
        for (Integer i = 0; i < 3; i++) {
            contracts.add(new Contract(
                AccountId = testAccount.Id,
                Opportunity__c = null,
                Name = 'Contract ' + i,
                StartTripDate__c = Date.today(),
                EndTripDate__c = Date.today().addDays(7),
                Amount__c = 1000,
                Status = 'Draft'
            ));
        }
        insert contracts;

        // Vérifier qu'il y a 3 contrats avant suppression
        List<Contract> contractsBeforeDelete = [SELECT Id FROM Contract WHERE AccountId = :testAccount.Id];
        System.assertEquals(3, contractsBeforeDelete.size(), 'Il devrait y avoir 3 contrats avant suppression.');

        // Supprimer tous les contrats du compte
        ContractService.deleteContractsByAccountId(testAccount.Id);

        // Vérifier qu'il n'y a plus de contrats associés au compte
        List<Contract> contractsAfterDelete = [SELECT Id FROM Contract WHERE AccountId = :testAccount.Id];
        System.assertEquals(0, contractsAfterDelete.size(), 'Tous les contrats associés au compte devraient être supprimés.');
    }
}
