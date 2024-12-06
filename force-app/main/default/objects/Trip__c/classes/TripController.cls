public with sharing class TripController {
    @AuraEnabled(cacheable=true)
    public static List<Trip__c> getTrips() {
        return [
            SELECT Id, Name, StartTripDate__c, EndTripDate__c, Number_of_Participants__c, Destination__c, Status__c, 
                   Account__r.Name
            FROM Trip__c
            
        ];
    }
}
