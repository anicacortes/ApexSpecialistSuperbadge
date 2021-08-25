global class WarehouseSyncSchedule implements Schedulable{

    public static String CRON_EXP = '0 0 1 * * ? *';

    global void execute(SchedulableContext sc) {
        System.enqueueJob(new WarehouseCalloutService());
    }
}
