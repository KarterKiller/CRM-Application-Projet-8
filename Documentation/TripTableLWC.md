# Explication du code : TripTable (LWC)

Fichier expliquatif du composant Web Lightning (LWC) `TripTable`, qui affiche une table des voyages récupérés depuis Salesforce à l'aide d'une méthode Apex.

## Déclaration du composant
```javascript
import { LightningElement, wire, track } from 'lwc';
import getTrips from '@salesforce/apex/TripController.getTrips';
```
- **`LightningElement`** : Classe de base pour tous les composants LWC.
- **`wire`** : Décorateur pour intégrer les données ou des fonctions réactives à partir de Salesforce.
- **`track`** : Décorateur pour rendre les propriétés réactives.
- **`getTrips`** : Méthode Apex importée depuis `TripController` pour récupérer les voyages.

---

## Attributs principaux

### `trips`
```javascript
trips = [];
```
Stocke les voyages récupérés.

### `error`
```javascript
error;
```
Stocke les éventuelles erreurs lors de la récupération des données.

### `columns`
```javascript
columns = [
    { label: 'Nom', fieldName: 'name', type: 'text' },
    ...
];
```
- Définit les colonnes du tableau avec des métadonnées.
- Chaque colonne contient :
  - **`label`** : Titre de la colonne.
  - **`fieldName`** : Nom du champ correspondant dans les données de la ligne.
  - **`type`** : Type de données affiché (par exemple, `text`, `number`, `date`).
  - **`cellAttributes`** : Permet de personnaliser les styles ou les attributs dynamiques des cellules.

---

## Décorateur `@wire`
### Fonctionnalité
```javascript
@wire(getTrips)
wiredTrips({ data, error }) {
    if (data) {
        this.trips = data.map(trip => ({
            ...
        }));
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.trips = [];
    }
}
```
- Utilise la méthode Apex `getTrips` pour récupérer les voyages.
- Gère deux cas :
  - **Données disponibles** :
    - Formate les données brutes pour s'adapter à la structure du tableau.
    - Ajoute des styles dynamiques en fonction des statuts des voyages (par exemple, rouge pour "Annulé", vert pour "A venir").
  - **Erreur** :
    - Stocke l'erreur et vide la liste des voyages.

---

## Transformation des données
### Exemple de transformation
```javascript
this.trips = data.map(trip => ({
    id: trip.Id,
    name: trip.Name,
    participants: trip.Number_of_Participants__c,
    startTripDate: trip.StartTripDate__c,
    endTripDate: trip.EndTripDate__c,
    destination: trip.Destination__c,
    accountName: trip.Account__r?.Name,
    status: trip.Status__c,
    
    // Style pour centrer les valeurs dans la colonne "Nombre de Participants"
    participantsStyle: 'text-align: center;',

    // Style dynamique pour la colonne "Statut"
    statusStyle: trip.Status__c === 'Annulé'
        ? 'color: red; font-weight: bold;'
        : (trip.Status__c === 'A venir' || trip.Status__c === 'En cours')
        ? (trip.Status__c === 'En cours' ? 'color: blue; font-weight: bold;' : 'color: green; font-weight: bold;')
        : ''
}));
```
- **Ajout de styles dynamiques** :
  - `statusStyle` : Applique des couleurs différentes en fonction du statut des voyages.
    - Rouge : Annulé.
    - Bleu : En cours.
    - Vert : À venir.

---

## Résumé
Le composant `TripTable` :
1. **Récupère les données** via une méthode Apex (`getTrips`).
2. **Affiche un tableau** avec des colonnes définies dynamiquement.
3. **Ajoute des styles conditionnels** pour améliorer la lisibilité (par exemple, mise en évidence des statuts).
4. **Gère les erreurs** en affichant un message ou en vidant les données si nécessaire.

Ce composant offre une interface réactive et dynamique pour afficher les voyages dans Salesforce.
