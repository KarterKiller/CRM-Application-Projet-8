import { LightningElement, wire, track } from 'lwc';
import getTaskHistory from '@salesforce/apex/TaskController.getTaskHistory';

export default class TaskTable extends LightningElement {
    tasks = [];
    error;

    // Colonnes pour le tableau
    columns = [
        { label: 'Sujet', fieldName: 'Subject', type: 'text' },
        { label: 'Statut', fieldName: 'Status', type: 'text' },
        { label: 'Priorité', fieldName: 'Priority', type: 'text' },
        { label: 'Date de l\'activité', fieldName: 'ActivityDate', type: 'date' },
        { label: 'Qui', fieldName: 'WhoName', type: 'text' },
        { label: 'Quoi', fieldName: 'WhatName', type: 'text' }
    ];

    @track data = [];
    // Récupérer les données via Apex
    @wire(getTaskHistory)
    wiredTasks({ data, error }) {
        if (data) {
            this.tasks = data.map(task => ({
                ...task,
                WhoName: task.Who ? task.Who.Name : '',
                WhatName: task.What ? task.What.Name : ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.tasks = [];
        }
    }
}
