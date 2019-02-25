({
    packItem1 : function(component, event, helper) {
		console.log('packItem action');
        var boton = event.getSource();
        component.set("v.item.Packed__c", true);
        boton.set("v.disabled", true);
	},
	
    packItem : function(component, event, helper) {
		var item = component.get("v.item");	//why do we need to explicitly call the Object variable? why not component.set("v.item.Packed__c", true); ?
        item.Packed__c = true;	// this line and below line doesnot seem to be needed? 
        component.set("v.item",item);	
        //component.set("v.disabled",true);  Tambien es valido
        var boton = event.getSource();
        boton.set("v.disabled", true);
	}
    
})