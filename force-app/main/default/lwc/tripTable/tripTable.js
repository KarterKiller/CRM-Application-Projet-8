import { LightningElement, wire } from 'lwc';
import getTrips from '@salesforce/apex/TripController.getTrips';

export default class TripTable extends LightningElement {
    trips = [];
    error;

    // Définitions des colonnes pour le tableau
    columns = [
        { label: 'Nom', fieldName: 'name', type: 'text' },
        { label: 'Nombre de Participants', fieldName: 'participants', type: 'number' },
        { label: 'Date de Début', fieldName: 'startDate', type: 'date' },
        { label: 'Date de Fin', fieldName: 'endDate', type: 'date' },
        { label: 'Destination', fieldName: 'destination', type: 'text' },
        { label: 'Nom du Compte', fieldName: 'accountName', type: 'text' },
        { label: 'Statut', fieldName: 'status', type: 'text' }
    ];

    // Récupération des données des voyages via Apex
    @wire(getTrips)
    wiredTrips({ data, error }) {
        if (data) {
            this.trips = data.map(trip => ({
                id: trip.Id,
                name: trip.Name,
                participants: trip.Number_of_Participants__c,
                startDate: trip.Start_Date__c,
                endDate: trip.End_Date__c,
                destination: trip.Destination__c,
                accountName: trip.Account__r?.Name,
                status: trip.Status__c
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.trips = [];
        }
    }
}
