({
	clickCreateItem : function(component, event, helper) {
        var validExpense = component.find('itemForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(validExpense){
            //var theCampings = component.get("v.items");
            // Create the new camping
            var newCamping = component.get("v.newItem");
            console.log("Create Camping: " + JSON.stringify(newCamping));
            helper.createItem(component, newCamping);
            
            //theCampings.push(newCamping);
            //component.set("v.items", theCampings);
            
            component.set("v.newItem",{'sobjectType':'Camping_Item__c',
                                       'Name':'',
                                       'Price__c':0,
                                       'Quantity':0,
                                       'Packed__c': false});
        }
    }
})