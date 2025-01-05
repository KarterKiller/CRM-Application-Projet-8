import { LightningElement, wire, track } from 'lwc';
import getTrips from '@salesforce/apex/TripController.getTrips';

export default class TripTable extends LightningElement {
    trips = [];
    error;

    // Définitions des colonnes pour le tableau
    columns = [
        { label: 'Nom', fieldName: 'name', type: 'text' },
        { 
            label: 'Nombre de Participants',
            fieldName: 'participants', 
            type: 'number',
            cellAttributes: {
                style: 'text-align: center;'  // Centrer les valeurs
            }
        },
        { label: 'Date de Début', fieldName: 'startTripDate', type: 'date' },
        { label: 'Date de Fin', fieldName: 'endTripDate', type: 'date' },
        { label: 'Destination', fieldName: 'destination', type: 'text' },
        { label: 'Nom du Compte', fieldName: 'accountName', type: 'text' },
        {
            label: 'Statut',
            fieldName: 'status',
            type: 'text',
            cellAttributes: {
                style: { fieldName: 'statusStyle' } // Appliquer un style dynamique en fonction du statut
            }
        }
    ];

    @track data = [];
    // Récupération des données des voyages via la méthode getTrips
    @wire(getTrips)
    wiredTrips({ data, error }) {
        if (data) {
            this.trips = data.map(trip => ({
                id: trip.Id,
                name: trip.Name,
                participants: trip.Number_of_Participants__c,
                startTripDate: trip.StartTripDate__c,
                endTripDate: trip.EndTripDate__c,
                destination: trip.Destination__c,
                accountName: trip.Account__r?.Name,
                status: trip.Status__c,
                participantsStyle: 'text-align: center;',  // Style pour centrer les valeurs dans la colonne "Nombre de Participants"

                // Dynamique des styles pour la colonne "Statut"
                statusStyle: trip.Status__c === 'Annulé'
                    ? 'color: red; font-weight: bold;'  // Rouge pour "Annulé"
                    : (trip.Status__c === 'A venir' || trip.Status__c === 'En cours')
                    ? (trip.Status__c === 'En cours' ? 'color: blue; font-weight: bold;' : 'color: green; font-weight: bold;') // Bleu pour "En cours", Vert pour "A venir"
                    : ''  // Aucun style pour les autres statuts
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.trips = [];
        }
    }
}
