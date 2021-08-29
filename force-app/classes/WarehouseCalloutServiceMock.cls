@IsTest
public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // Implement this interface method
    public HttpResponse respond(HttpRequest req) {

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[\n' +
                '{\n' +
                '"_id": "55d66226726b611100aaf741",\n' +
                '"replacement": false,\n' +
                '"quantity": 5,\n' +
                '"name": "Generator 1000 kW",\n' +
                '"maintenanceperiod": 365,\n' +
                '"lifespan": 120,\n' +
                '"cost": 5000,\n' +
                '"sku": "100003"\n' +
                '},\n' +
                '{\n' +
                '"_id": "55d66226726b611100aaf744",\n' +
                '"replacement": false,\n' +
                '"quantity": 5,\n' +
                '"name": "Generator 2000 kw",\n' +
                '"maintenanceperiod": 365,\n' +
                '"lifespan": 120,\n' +
                '"cost": 6000,\n' +
                '"sku": "100006"\n' +
                '},\n' +
                '{\n' +
                '"_id": "55d66226726b611100aaf745",\n' +
                '"replacement": true,\n' +
                '"quantity": 142,\n' +
                '"name": "Fuse 25A",\n' +
                '"maintenanceperiod": 0,\n' +
                '"lifespan": 0,\n' +
                '"cost": 28,\n' +
                '"sku": "100007"\n' +
                '},\n' +
                '{\n' +
                '"_id": "55d66226726b611100aaf748",\n' +
                '"replacement": false,\n' +
                '"quantity": 2,\n' +
                '"name": "Converter",\n' +
                '"maintenanceperiod": 180,\n' +
                '"lifespan": 120,\n' +
                '"cost": 3000,\n' +
                '"sku": "100010"\n' +
                '},\n' +
                '{\n' +
                '"_id": "55d66226726b611100aaf74b",\n' +
                '"replacement": true,\n' +
                '"quantity": 150,\n' +
                '"name": "Switch",\n' +
                '"maintenanceperiod": 0,\n' +
                '"lifespan": 0,\n' +
                '"cost": 100,\n' +
                '"sku": "100013"\n' +
                '},\n' +
                '{\n' +
                '"_id": "55d66226726b611100aaf74c",\n' +
                '"replacement": true,\n' +
                '"quantity": 200,\n' +
                '"name": "Ball Valve 5 cm",\n' +
                '"maintenanceperiod": 0,\n' +
                '"lifespan": 0,\n' +
                '"cost": 30,\n' +
                '"sku": "100014"\n' +
                '},\n' +
                '{\n' +
                '"_id": "55d66226726b611100aaf750",\n' +
                '"replacement": false,\n' +
                '"quantity": 2,\n' +
                '"name": "Cooling Tower",\n' +
                '"maintenanceperiod": 365,\n' +
                '"lifespan": 120,\n' +
                '"cost": 10000,\n' +
                '"sku": "100018"\n' +
                '}' +
                ']');
        res.setStatusCode(200);
        return res;
    }
}