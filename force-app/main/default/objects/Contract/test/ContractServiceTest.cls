@isTest
private class ContractServiceTest {

    @isTest
    static void testCreateContractFromOpportunity() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
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
            Destination__c = 'Paris',
            Number_of_Participants__c = 20
        );
        insert testOpportunity;

        // Créer un contrat à partir de l'opportunité
        Id contractId = ContractService.createContractFromOpportunity(testOpportunity.Id);

        // Vérifier les données du contrat créé
        Contract createdContract = [
            SELECT Id, Opportunity__c, AccountId, Name, Amount__c, Destination__c, Number_of_Participants__c 
            FROM Contract 
            WHERE Id = :contractId
        ];
        System.assertNotEquals(null, createdContract, 'Le contrat aurait dû être créé.');
        System.assertEquals(testOpportunity.Id, createdContract.Opportunity__c, 'Le contrat doit être lié à l\'opportunité.');
        System.assertEquals(testAccount.Id, createdContract.AccountId, 'Le contrat doit être lié au compte de l\'opportunité.');
    }

    @isTest
    static void testCreateContractValidationErrors() {
        // Créer un compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Tester la création avec un montant négatif
        Opportunity invalidOpportunity = new Opportunity(
            AccountId = testAccount.Id,
            Name = 'Invalid Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = -1000,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Destination__c = 'Paris',
            Number_of_Participants__c = 20
        );
        insert invalidOpportunity;

        try {
            ContractService.createContractFromOpportunity(invalidOpportunity.Id);
            System.assert(false, 'Une exception aurait dû être levée pour un montant négatif.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('Le montant de l\'opportunité doit être positif'), 'L\'exception doit indiquer une erreur sur le montant.');
        }

        // Tester la création avec des dates invalides
        Opportunity invalidDateOpportunity = new Opportunity(
            AccountId = testAccount.Id,
            Name = 'Invalid Date Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 1000,
            StartTripDate__c = Date.today().addDays(7),
            EndTripDate__c = Date.today(), // Date de fin avant date de début
            Destination__c = 'Paris',
            Number_of_Participants__c = 20
        );
        insert invalidDateOpportunity;

        try {
            ContractService.createContractFromOpportunity(invalidDateOpportunity.Id);
            System.assert(false, 'Une exception aurait dû être levée pour des dates invalides.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('La date de fin doit être postérieure à la date de début'), 'L\'exception doit indiquer une erreur sur les dates.');
        }
    }

    @isTest
    static void testUpdateContractStatus() {
        // Créer un contrat
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            Name = 'Test Contract',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 1000,
            Status = 'Draft'
        );
        insert testContract;

        // Appeler la méthode pour mettre à jour le statut
        ContractService.updateContractStatus(testContract.Id, 'Activated');

        // Vérifier le statut mis à jour
        Contract updatedContract = [
            SELECT Status 
            FROM Contract 
            WHERE Id = :testContract.Id
        ];
        System.assertEquals('Activated', updatedContract.Status, 'Le statut du contrat devrait être "Activated".');
    }

    @isTest
    static void testDeleteContract() {
        // Créer un contrat
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contract testContract = new Contract(
            AccountId = testAccount.Id,
            Name = 'Test Contract',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 1000,
            Status = 'Draft'
        );
        insert testContract;

        // Supprimer le contrat
        ContractService.deleteContract(testContract.Id);

        // Vérifier que le contrat a été supprimé
        List<Contract> contracts = [SELECT Id FROM Contract WHERE Id = :testContract.Id];
        System.assertEquals(0, contracts.size(), 'Le contrat aurait dû être supprimé.');
    }

    @isTest
    static void testDeleteContractsByAccountId() {
        // Créer un compte et plusieurs contrats
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        List<Contract> contracts = new List<Contract>();
        for (Integer i = 0; i < 3; i++) {
            contracts.add(new Contract(
                AccountId = testAccount.Id,
                Name = 'Contract ' + i,
                StartTripDate__c = Date.today(),
                EndTripDate__c = Date.today().addDays(7),
                Amount__c = 1000,
                Status = 'Draft'
            ));
        }
        insert contracts;

        // Supprimer les contrats liés au compte
        ContractService.deleteContractsByAccountId(testAccount.Id);

        // Vérifier que tous les contrats ont été supprimés
        List<Contract> remainingContracts = [SELECT Id FROM Contract WHERE AccountId = :testAccount.Id];
        System.assertEquals(0, remainingContracts.size(), 'Tous les contrats liés au compte devraient être supprimés.');
    }
}
