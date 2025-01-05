@isTest
public class SalesTrackingControllerTest {

    @isTest
    static void testGetSalesData() {
        // 1. Préparation des données de test
        // Créer un compte via TestDataFactory
        Account acc = TestDataFactory.createAccount(true);

        // Créer une opportunité via TestDataFactory
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id, false);
        opp.StageName = 'Closed Won'; // Modifier le statut pour le test
        opp.Amount = 1000;
        opp.Number_of_Participants__c = 10;
        opp.StartTripDate__c = Date.today();
        opp.EndTripDate__c = Date.today().addDays(5);
        opp.Destination__c = 'Paris';
        insert opp;

        // Créer un contrat via TestDataFactory
        Contract contract = TestDataFactory.createContract(acc.Id, false);
        contract.Status = 'Draft';
        contract.StartTripDate__c = Date.today();
        contract.EndTripDate__c = Date.today().addDays(7);
        contract.Amount__c = 500;
        contract.Number_of_Participants__c = 10;
        contract.Conditions__c = 'Terms and conditions applied';
        insert contract;

        // 2. Appeler la méthode à tester
        Test.startTest();
        List<SalesTrackingController.SalesData> salesDataList = SalesTrackingController.getSalesData();
        Test.stopTest();

        // 3. Vérification des résultats
        System.assertNotEquals(0, salesDataList.size(), 'La liste des données de ventes ne devrait pas être vide.');
        System.assertEquals('Test Account', salesDataList[0].accountName, 'Le nom du compte devrait être "Test Account".');
        System.assertEquals('Closed Won', salesDataList[0].opportunityStatus, 'Le statut de l\'opportunité devrait être "Closed Won".');
    }
}
