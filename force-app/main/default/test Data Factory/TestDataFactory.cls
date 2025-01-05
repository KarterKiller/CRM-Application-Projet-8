@isTest
public class TestDataFactory {

    // Création d'un compte (Account)
    public static Account createAccount(Boolean insertRecord) {
        Account acc = new Account(
            Name = 'Test Account',
            Industry = 'Technology',
            Phone = '0123456789',
            Active__c = 'Yes'
        );

        if (insertRecord) {
            insert acc;
        }
        return acc;
    }

    // Création d'une opportunité (Opportunity)
    public static Opportunity createOpportunity(Id accountId, Boolean insertRecord) {
        if (accountId == null) {
            throw new IllegalArgumentException('AccountId est requis pour créer une opportunité.');
        }

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = accountId,
            Amount = 1000,
            StartTripDate__c = Date.today().addDays(10),
            EndTripDate__c = Date.today().addDays(20),
            Destination__c = 'Paris',
            Number_of_Participants__c = 10
        );

        if (insertRecord) {
            insert opp;
        }
        return opp;
    }

    // Création d'un contrat (Contract)
    public static Contract createContract(Id accountId, Boolean insertRecord) {
        if (accountId == null) {
            throw new IllegalArgumentException('AccountId est requis pour créer un contrat.');
        }

        Contract con = new Contract(
            Name = 'Test Contract',
            AccountId = accountId,
            StartTripDate__c = Date.today().addDays(5),
            EndTripDate__c = Date.today().addDays(15),
            Amount__c = 5000,
            Number_of_Participants__c = 5,
            Destination__c = 'London',
            Status = 'Draft'
        );

        if (insertRecord) {
            insert con;
        }
        return con;
    }

    // Création d'une tâche (Task)
    public static Task createTask(Id whatId, Id whoId, Boolean insertRecord) {
        Task task = new Task(
            Subject = 'Test Task',
            Status = 'Not Started',
            Priority = 'Medium',
            ActivityDate = Date.today().addDays(7),
            WhoId = whoId, // Peut être lié à un Lead ou un Contact
            WhatId = whatId // Peut être lié à un Objet lié (par exemple Account, Opportunity)
        );

        if (insertRecord) {
            insert task;
        }
        return task;
    }

    // Création d'un voyage (Trip__c)
    public static Trip__c createTrip(Id accountId, Boolean insertRecord) {
        if (accountId == null) {
            throw new IllegalArgumentException('AccountId est requis pour créer un voyage.');
        }

        Trip__c trip = new Trip__c(
            Name = 'Test Trip',
            StartTripDate__c = Date.today().addDays(1),
            EndTripDate__c = Date.today().addDays(5),
            Number_of_Participants__c = 8,
            Destination__c = 'Rome',
            Status__c = 'A venir',
            Total_Cost__c = 2000,
            Account__c = accountId
        );

        if (insertRecord) {
            insert trip;
        }
        return trip;
    }

    // Création d'un contact (Contact)
    public static Contact createContact(Id accountId, Boolean insertRecord) {
        if (accountId == null) {
            throw new IllegalArgumentException('AccountId est requis pour créer un contact.');
        }

        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test.contact@example.com',
            Phone = '0123456789',
            AccountId = accountId
        );

        if (insertRecord) {
            insert con;
        }
        return con;
    }
}
