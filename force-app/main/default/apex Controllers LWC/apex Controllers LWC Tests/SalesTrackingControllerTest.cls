@isTest
public class SalesTrackingControllerTest {

    @isTest
    static void testGetSalesData() {
        // 1. Préparation des données de test
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed Won',
            CloseDate = Date.today().addDays(10),
            Amount = 1000,
            Number_of_Participants__c = 10,
            AccountId = acc.Id,
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(5),
            Destination__c = 'Paris'
        );
        insert opp;

        Contract contract = new Contract(
            Name = 'Test Contract',
            AccountId = acc.Id,
            Status = 'Draft',
            StartTripDate__c = Date.today(),
            EndTripDate__c = Date.today().addDays(7),
            Amount__c = 500,
            Number_of_Participants__c = 10,
            Conditions__c = 'Terms and conditions applied'
        );
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
