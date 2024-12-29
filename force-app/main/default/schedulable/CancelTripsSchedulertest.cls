@isTest
public class CancelTripsSchedulertest {

    @isTest
    static void testSchedulerExecution() {
        // Simuler une exécution planifiée de CancelTripsScheduler
        Test.startTest();

        // Appeler la méthode execute pour simuler l'exécution planifiée
        CancelTripsScheduler scheduler = new CancelTripsScheduler();
        String cronExp = '0 0 12 * * ?'; // Expression CRON pour une exécution quotidienne à midi
        System.schedule('Test CancelTripsScheduler', cronExp, scheduler);

        Test.stopTest();

        // Aucune assertion nécessaire car la validation se fait sur l'absence d'erreurs
    }
}
