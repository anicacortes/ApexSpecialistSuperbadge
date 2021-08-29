@IsTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here

    @TestSetup
    private static void prepareData() {
        CreateDefaultData.createDefaultData();
        //4 vehicles, 4 equipments, 2 MaintRequest (with the 2 first vehicles), 6 EquipmMaintItems (3 with each MainRequest)
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

    @IsTest
    public static void updateWorkOrdersPositiveTest() {
        //prepareData();

        List<Case> existingCasesToUpdate = [SELECT Id, Status, Vehicle__c, ParentId FROM Case];
        System.debug('existingCasesToUpdate:' + existingCasesToUpdate);

        List<Equipment_Maintenance_Item__c> itemsRelatedBefore =
        [SELECT Id, Maintenance_Request__c, Maintenance_Request__r.Date_Due__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :existingCasesToUpdate];

        Equipment_Maintenance_Item__c itemBeforeId = itemsRelatedBefore.get(1);
        Map<Id, Integer> mapDueDate = getMapDueDate(itemsRelatedBefore);
        Date dueExpected = mapDueDate.get(itemBeforeId.Id) != null ? Date.today() + mapDueDate.get(itemBeforeId.Id) : Date.today();

        List<Case> listCasesToUpdate = new List<Case>();
        Set<String> parentsIds = new Set<String>();
        List<String> vehicleIds = new List<String>();
        for(Case currentCase : existingCasesToUpdate) {
            currentCase.Status = 'Closed';

            listCasesToUpdate.add(currentCase);
            parentsIds.add(currentCase.ParentId);
            vehicleIds.add(currentCase.Vehicle__c);
        }

        System.debug(listCasesToUpdate);

        //This will cause the trigger
        Test.startTest();
        update listCasesToUpdate;
        Test.stopTest();

        List<Case> existingCasesAfterTrigger = [SELECT Id, Status, Vehicle__c, ParentId, Date_Due__c FROM Case];
        System.assertEquals(4, existingCasesAfterTrigger.size());
        System.debug('existingCasesAfterTrigger:' + existingCasesAfterTrigger);

        //Case caseDueDate = [SELECT Id, ParentId, Date_Due__c FROM Case WHERE ParentId =: itemBeforeId.Maintenance_Request__c];
        //System.assertEquals(dueExpected, caseDueDate.Date_Due__c);

        //System.assert(mapDueDate.get(existingCasesAfterTrigger.get(0).ParentId) != null ? Date.today() + mapDueDate.get(updatedRequest.Id) : Date.today())

        List<Case> newCasesWithSameParentIds = [SELECT Id, Status, Vehicle__c, ParentId FROM Case WHERE ParentId IN :parentsIds];
        System.assertEquals(2, newCasesWithSameParentIds.size());
        System.assertEquals(vehicleIds.get(0), newCasesWithSameParentIds.get(0).Vehicle__c);

        List<Equipment_Maintenance_Item__c> itemsRelatedAfter =
        [SELECT Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :existingCasesToUpdate];

        System.assert(itemsRelatedAfter.size() == 0);


        System.debug('casesWithSameParentIds:' + newCasesWithSameParentIds);

    }
}