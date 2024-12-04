@isTest
public class OpportunityTriggerHandlerTest {
    @isTest
    static void testHandleOpportunityUpdate() {
        // Créer un compte pour l'opportunité
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer une opportunité
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = acc.Id,
            Destination__c = 'Paris',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(5),
            Number_of_Participants__c = 15,
            Amount = 5000
        );
        insert opp;

        // Mettre à jour l'opportunité à "Closed Won"
        opp.StageName = 'Closed Won';
        update opp;

        // Vérifier que le Trip__c a été créé
        List<Trip__c> trips = [SELECT Name, Status__c, Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c, Total_Cost__c, Account__c, Opportunity__c 
                               FROM Trip__c WHERE Opportunity__c = :opp.Id];

        System.assertEquals(1, trips.size());
        System.assertEquals('A venir', trips[0].Status__c);
        System.assertEquals('Paris', trips[0].Destination__c);
        System.assertEquals(5000, trips[0].Total_Cost__c);
        System.assertEquals(acc.Id, trips[0].Account__c);
    }
}
