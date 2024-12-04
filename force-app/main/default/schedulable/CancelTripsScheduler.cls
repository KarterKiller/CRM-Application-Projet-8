global class CancelTripsScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        // Appeler le batch à exécuter
        Database.executeBatch(new CancelTripsBatch());
    }
}
