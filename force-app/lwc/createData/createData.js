import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import isDataCreated from '@salesforce/apex/CreateDefaultData.isDataCreated';
import createDefaultData from '@salesforce/apex/CreateDefaultData.createDefaultData';
export default class createData extends LightningElement {
    @track isButtonDisabled = true;
    connectedCallback(){
        isDataCreated()
            .then((result) => {
                this.isButtonDisabled = result;
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    variant: 'error',
                    title: 'Error when checking if default data was created',
                    message: 'Error received: code' + error.errorCode + ', message: ' + error.body.message
                });
                this.dispatchEvent(event);
            });
    }

    createData(){ 
        createDefaultData()
            .then(() => {
                this.isButtonDisabled = true;
                const event = new ShowToastEvent({
                    variant: 'success',
                    title: 'Data successfully created!',
                    message: 'Data was successfully created. Go through the tabs in the How We Roll Maintenance app to check it out'
                });
                this.dispatchEvent(event);
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    variant: 'error',
                    title: 'Error when creating test data',
                    message: 'Error received: code' + error.errorCode + ', message: ' + error.body.message
                });
                this.dispatchEvent(event);
            });
    }
}