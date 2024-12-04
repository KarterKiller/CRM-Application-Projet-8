public with sharing class TripController {
    @AuraEnabled(cacheable=true)
    public static List<Trip__c> getTrips() {
        return [
            SELECT Id, Name, Number_of_Participants__c, Start_Date__c, End_Date__c, Destination__c, 
                   Account__r.Name, Status__c
            FROM Trip__c
        ];
    }
}
