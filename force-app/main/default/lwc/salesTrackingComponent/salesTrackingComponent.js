import { LightningElement, wire, track } from 'lwc';
import getSalesData from '@salesforce/apex/SalesTrackingController.getSalesData';

export default class SalesTrackingComponent extends LightningElement {
    // Colonnes du tableau
    columns = [
        { label: 'Nom du Client', fieldName: 'accountName' },
        { label: 'Date de Création', fieldName: 'accountCreatedDate', type: 'date' },
        { label: 'Montant Opportunité', fieldName: 'opportunityAmount', type: 'currency' },
        { label: 'Statut Opportunité', fieldName: 'opportunityStatus' },
        { label: 'Date d\'Expiration du Contrat', fieldName: 'endDate', type: 'date' },
        { label: 'Conditions du Contrat', fieldName: 'conditions', type: 'text' },
        { label: 'Statut du Contrat', fieldName: 'contractStatus' }
    ];

    @track data = []; // Pour stocker les données à afficher dans le tableau

    // Récupération des données via Apex
    @wire(getSalesData)
    wiredSalesData({ data, error }) {
        if (data) {
            this.data = data.map(record => ({
                id: record.accountId,
                accountName: record.accountName,
                accountCreatedDate: record.accountCreatedDate,
                opportunityAmount: record.opportunityAmount,
                opportunityStatus: record.opportunityStatus,
                endDate: record.endDate,
                conditions: record.conditions,
                contractStatus: record.contractStatus
            }));
        } else if (error) {
            console.error('Erreur lors de la récupération des données : ', error);
        }
    }
}
