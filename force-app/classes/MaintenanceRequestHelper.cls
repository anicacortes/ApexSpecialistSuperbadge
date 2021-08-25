public with sharing class MaintenanceRequestHelper {

    public static void updateWorkOrders(List<Case> oldRequests, List<Case> newRequests) {
        List<Case> newListRequest = new List<Case>();
        System.debug('newRequests:' + newRequests);

        List<Equipment_Maintenance_Item__c> currentMaintenanceList =
        [SELECT Id, Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :newRequests];

        Map<Id, Integer> mapDueDate = getMapDueDate(currentMaintenanceList);

        for(Case updatedRequest : newRequests) {
            //Check if new case type = Repair/Routine Maintenance and status = Closed, proceed
            if((updatedRequest.Type == 'Repair' || updatedRequest.Type == 'Routine Maintenance') && updatedRequest.Status == 'Closed') {
                Case newRequestRoutine = new Case();
                newRequestRoutine.Vehicle__c = updatedRequest.Vehicle__c;
                newRequestRoutine.Subject = 'Routine created by Ana';
                newRequestRoutine.Type = 'Routine Maintenance';
                newRequestRoutine.Date_Reported__c = Date.today();
                newRequestRoutine.Date_Due__c = mapDueDate.get(updatedRequest.Id) != null ? Date.today() + mapDueDate.get(updatedRequest.Id) : Date.today();
                newRequestRoutine.ParentId = updatedRequest.Id;
                newListRequest.add(newRequestRoutine);
            }
        }
        insert newListRequest;

        List<Equipment_Maintenance_Item__c> listMaintenanceToUpdate = new List<Equipment_Maintenance_Item__c>();
        System.debug('currentItems for whole list:' + currentMaintenanceList);

        for(Case newRequestRoutine : newListRequest) {
            for(Equipment_Maintenance_Item__c existingMaintenance : currentMaintenanceList) {
                //si este caso q se actualiza tiene alguna request, el nuevo caso tendra lo mismo -> en la request, actualizar el padre
                if(newRequestRoutine.ParentId == existingMaintenance.Maintenance_Request__c) {
                    existingMaintenance.Maintenance_Request__c = newRequestRoutine.Id;
                    listMaintenanceToUpdate.add(existingMaintenance);
                }
            }
        }
        System.debug('listMaintenanceToUpdate:' + listMaintenanceToUpdate);
        update listMaintenanceToUpdate;
    }

    private static Map<Id, Integer> getMapDueDate(List<Equipment_Maintenance_Item__c> currentMaintenanceList) {
        Map<Id, Integer> mapDueDate = new Map<Id, Integer>();
        for(Equipment_Maintenance_Item__c maintenance : currentMaintenanceList) {
            if(mapDueDate.containsKey(maintenance.Maintenance_Request__c)) {
                Integer storedDueDate = mapDueDate.get(maintenance.Maintenance_Request__c);
                mapDueDate.put(maintenance.Maintenance_Request__c, Integer.valueOf(Math.min(maintenance.Equipment__r.Maintenance_Cycle__c, storedDueDate)));
            }
            else {
                mapDueDate.put(maintenance.Maintenance_Request__c, Integer.valueOf(maintenance.Equipment__r.Maintenance_Cycle__c));
            }
        }
        System.debug('mapDueDate:' + mapDueDate);
        return mapDueDate;
    }
}