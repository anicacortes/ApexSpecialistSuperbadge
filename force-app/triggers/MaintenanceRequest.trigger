trigger MaintenanceRequest on Case (before update, after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    if(Trigger.isAfter) MaintenanceRequestHelper.updateWorkOrders(Trigger.old, Trigger.new);
}