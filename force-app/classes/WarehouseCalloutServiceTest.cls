@IsTest
private class WarehouseCalloutServiceTest {

    @IsTest
    public static void calloutServiceTest() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        //HttpResponse res = Wa.getInfoFromExternalService();

        Id jobID = System.enqueueJob(new WarehouseCalloutService());
        System.assert(jobID != null);
    }

}