public class SalesTrackingController {

    @AuraEnabled(cacheable=true)
    public static List<SalesData> getSalesData() {
        List<SalesData> results = new List<SalesData>();

        // Requête SOQL pour récupérer les données nécessaires
        List<Account> accounts = [SELECT Id, Name, CreatedDate FROM Account LIMIT 10]; // Limité à 10 pour l'exemple
        List<Opportunity> opportunities = [SELECT Id, AccountId, Amount, StageName FROM Opportunity WHERE StageName IN ('Closed Won', 'Negotiation')];
        List<Contract> contracts = [SELECT Id, AccountId, EndDate, Conditions__c, Status FROM Contract WHERE EndDate > :Date.today()];

        // Mapper les opportunités et contrats par AccountId
        Map<Id, Opportunity> opportunitiesMap = new Map<Id, Opportunity>();
        for (Opportunity opp : opportunities) {
            opportunitiesMap.put(opp.AccountId, opp);
        }

        Map<Id, Contract> contractsMap = new Map<Id, Contract>();
        for (Contract contract : contracts) {
            contractsMap.put(contract.AccountId, contract);
        }

        // Mapper les données des comptes, opportunités et contrats dans un objet SalesData
        for (Account acc : accounts) {
            SalesData salesRecord = new SalesData();
            salesRecord.accountId = acc.Id;
            salesRecord.accountName = acc.Name;
            salesRecord.accountCreatedDate = acc.CreatedDate.date(); // Convertir Datetime en Date

            // Recherche de l'opportunité et du contrat associé à ce compte
            Opportunity opp = opportunitiesMap.get(acc.Id);
            if (opp != null) {
                salesRecord.opportunityAmount = opp.Amount;
                salesRecord.opportunityStatus = opp.StageName;
            }

            Contract contract = contractsMap.get(acc.Id);
            if (contract != null) {
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
