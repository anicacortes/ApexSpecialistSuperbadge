@IsTest
public with sharing class WarehouseSyncScheduleTest {

    @IsTest
    public static void syncScheduleTest() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        WarehouseSyncSchedule service = new WarehouseSyncSchedule();
        String sch = '0 0 1 * * ? *';
        Test.startTest();
        String jobID = System.schedule('WarehouseSyncScheduleJob2', sch, service);
        Test.stopTest();
        System.assert(jobID != null);
    }
}