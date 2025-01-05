public with sharing class SalesTrackingController {

    @AuraEnabled(cacheable=true)
    public static List<SalesData> getSalesData() {
        List<SalesData> results = new List<SalesData>();

        // Requête unique pour récupérer les comptes avec leurs opportunités et contrats liés
        List<Account> accounts = [
            SELECT 
                Id, 
                Name, 
                CreatedDate,
                (SELECT Id, Amount, StageName FROM Opportunities WHERE StageName IN ('Closed Won', 'Negotiation')),
                (SELECT Id, EndDate, Conditions__c, Status FROM Contracts WHERE EndDate > :Date.today())
            FROM Account
            LIMIT 10
        ];

        // Mapper les données des comptes, opportunités et contrats dans un objet SalesData
        for (Account acc : accounts) {
            SalesData salesRecord = new SalesData();
            salesRecord.accountId = acc.Id;
            salesRecord.accountName = acc.Name;
            salesRecord.accountCreatedDate = acc.CreatedDate.date(); // Convertir Datetime en Date

            // Récupérer la première opportunité associée (si disponible)
            if (!acc.Opportunities.isEmpty()) {
                Opportunity opp = acc.Opportunities[0];
                salesRecord.opportunityAmount = opp.Amount;
                salesRecord.opportunityStatus = opp.StageName;
            }

            // Récupérer le premier contrat associé (si disponible)
            if (!acc.Contracts.isEmpty()) {
                Contract contract = acc.Contracts[0];
                salesRecord.endDate = contract.EndDate;
                salesRecord.conditions = contract.Conditions__c;
                salesRecord.contractStatus = contract.Status;
            }

            results.add(salesRecord);
        }

        return results;
    }

    // Objet personnalisé pour retourner les données sous forme d'un tableau
    public class SalesData {
        @AuraEnabled public Id accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public Date accountCreatedDate; 
        @AuraEnabled public Decimal opportunityAmount;
        @AuraEnabled public String opportunityStatus;
        @AuraEnabled public Date endDate;
        @AuraEnabled public String conditions;
        @AuraEnabled public String contractStatus;
    }
}
