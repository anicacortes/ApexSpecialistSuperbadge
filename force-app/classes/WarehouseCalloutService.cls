public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    public void execute(QueueableContext context) {
        //Make the REST Callout
        Http http = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');

        HttpResponse response = http.send(req);
        List<HerokuParser> responseParserList = HerokuParser.parse(response.getBody());

        //Upsert Equipment records in Salesforce
        List<Product2> equipmentsToUpsert = new List<Product2>();
        for(HerokuParser equipmentRetrieved : responseParserList) {
            Product2 equipmToUpsert = new Product2();
            equipmToUpsert.Name = equipmentRetrieved.name;
            equipmToUpsert.Replacement_Part__c = true;
            equipmToUpsert.Cost__c = equipmentRetrieved.cost;
            equipmToUpsert.Current_Inventory__c = equipmentRetrieved.quantity;
            equipmToUpsert.Lifespan_Months__c = equipmentRetrieved.lifespan;
            equipmToUpsert.Maintenance_Cycle__c = equipmentRetrieved.maintenanceperiod;
            equipmToUpsert.Warehouse_SKU__c = equipmentRetrieved.sku;
            equipmentsToUpsert.add(equipmToUpsert);
        }

        upsert equipmentsToUpsert Warehouse_SKU__c;
    }
}