({
    // Load expenses from Salesforce
    doInit: function(component, event, helper) {
        // Create the action
        var action = component.get("c.getItems");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState(); ff
            if (state === "SUCCESS") {
                component.set("v.items", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    handleAddItem : function(component, event, helper) {
        /*var validExpense = component.find('itemForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(validExpense){*/
            var theCampings = component.get("v.items");
            var item = event.getParam("item");
            var newCamping = component.get("v.newItem");
            console.log("Create Camping: " + JSON.stringify(newCamping));
            
            var action = component.get("c.saveItem");
            action.setParams({
                "item": item
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var items = component.get("v.items");
                    items.push(response.getReturnValue());
                    component.set("v.items", items);
                }
            });
            $A.enqueueAction(action);
        //}
    }
})