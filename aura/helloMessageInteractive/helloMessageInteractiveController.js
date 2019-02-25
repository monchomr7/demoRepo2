({
	handleClick : function(component, event, helper) {
		var boton = event.getSource();
        var texto = boton.get("v.label");
        component.set("v.message", texto);
	},
    handleClick2: function(component, event, helper) {
        var newMessage = event.getSource().get("v.label");
        component.set("v.message", newMessage);
    },
    handleClick3: function(component, event, helper) {
        component.set("v.message", event.getSource().get("v.label"));
    }

})