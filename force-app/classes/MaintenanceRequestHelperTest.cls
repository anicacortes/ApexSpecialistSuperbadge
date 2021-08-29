@IsTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here

    @TestSetup
    private static void prepareData() {
        CreateDefaultData.createDefaultData();
        //4 vehicles, 4 equipments, 2 MaintRequest (with the 2 first vehicles), 6 EquipmMaintItems (3 with each MainRequest)
    }

    @IsTest
    public static void updateWorkOrdersPositiveTest() {

        List<Case> existingCasesToUpdate = [SELECT Id, Status, Vehicle__c, ParentId FROM Case];

        List<Equipment_Maintenance_Item__c> itemsRelatedBefore =
        [SELECT Id, Maintenance_Request__c, Maintenance_Request__r.Date_Due__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :existingCasesToUpdate];

        Equipment_Maintenance_Item__c itemBeforeId = itemsRelatedBefore.get(1);
        Map<Id, Integer> mapDueDate = getMapDueDate(itemsRelatedBefore);

        Date dueExpected = mapDueDate.get(itemBeforeId.Maintenance_Request__c) != null ? Date.today() + mapDueDate.get(itemBeforeId.Maintenance_Request__c) : Date.today();

        List<Case> listCasesToUpdate = new List<Case>();
        Set<String> parentsIds = new Set<String>();
        List<String> vehicleIds = new List<String>();
        for(Case currentCase : existingCasesToUpdate) {
            currentCase.Status = 'Closed';

            listCasesToUpdate.add(currentCase);
            parentsIds.add(currentCase.ParentId);
            vehicleIds.add(currentCase.Vehicle__c);
        }


        //This will cause the trigger
        Test.startTest();
        update listCasesToUpdate;
        Test.stopTest();

        List<Case> existingCasesAfterTrigger = [SELECT Id, Status, Vehicle__c, ParentId, Date_Due__c FROM Case];
        System.assertEquals(4, existingCasesAfterTrigger.size());

        Case caseDueDate = [SELECT Id, ParentId, Date_Due__c FROM Case WHERE ParentId =: itemBeforeId.Maintenance_Request__c];
        System.assertEquals(dueExpected, caseDueDate.Date_Due__c);

        List<Case> newCasesWithSameParentIds = [SELECT Id, Status, Vehicle__c, ParentId FROM Case WHERE ParentId IN :parentsIds];
        System.assertEquals(2, newCasesWithSameParentIds.size());
        System.assertEquals(vehicleIds.get(0), newCasesWithSameParentIds.get(0).Vehicle__c);

        List<Equipment_Maintenance_Item__c> itemsRelatedAfter =
        [SELECT Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :existingCasesToUpdate];

        System.assert(itemsRelatedAfter.size() == 0);

    }

    @IsTest
    public static void updateWorkOrdersNegativeTest() {
        List<Case> listCasesToUpdate = new List<Case>();
        List<Case> existingCasesBefore = [SELECT Id, Status, Vehicle__c, ParentId FROM Case];

        for(Case currentCaseToUpdate : existingCasesBefore) {
            currentCaseToUpdate.Status = 'Closed';
            currentCaseToUpdate.Type = 'Electrical';
            listCasesToUpdate.add(currentCaseToUpdate);
        }

        Test.startTest();
        update listCasesToUpdate;
        Test.stopTest();

        List<Case> existingCasesAfter = [SELECT Id, Status, Vehicle__c, ParentId FROM Case];
        System.assertEquals(existingCasesBefore.size(), existingCasesAfter.size());
    }

    @IsTest
    public static void updateWorkOrdersBulk() {
        List<Case> maintenanceRequests = new List<Case>();

        for(Integer i = 0; i < 150; i++) {
            Case electr = new Case();
            electr.Status = 'New';
            electr.Type = 'Electrical';
            maintenanceRequests.add(electr);
        }

        for(Integer i = 0; i < 150; i++) {
            Case maintenance = new Case();
            maintenance.Status = 'New';
            maintenance.Type = 'Repair';
            maintenanceRequests.add(maintenance);
        }

        insert maintenanceRequests; //Bulk 300 records

        List<Case> maintenanceRequestsToUpdate = new List<Case>();
        for(Case maint : maintenanceRequests) {
            maint.Status = 'Closed';
            maintenanceRequestsToUpdate.add(maint);
        }

        Test.startTest();
        update maintenanceRequestsToUpdate;
        Test.stopTest();

        //There should be 450 cases + 2 initial cases
        List<Case> casesAfterUpdate = [SELECT Id FROM Case];
        System.assertEquals(casesAfterUpdate.size(), 452);
        casesAfterUpdate = [SELECT Id FROM Case WHERE ParentId != NULL];
        System.assertEquals(casesAfterUpdate.size(), 150);
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
        return mapDueDate;
    }
}