({
    // Fetch the accounts from the Apex controller
    getDuplicateLeadList: function(component) {
        var action = component.get('c.getDuplicateLeads');
        console.log('recordid: ' + component.get("v.recordId"));
        action.setParams({cID : component.get("v.recordId")
		});
        // Set up the callback
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            console.log('state: ' + actionResult.getState());
            if (state === 'ERROR') {
                var errors = actionResult.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            var lds = actionResult.getReturnValue(); // Duplicate leads will go into this array
            console.log(actionResult);
            component.set('v.leads', lds); // Set leads attribute in lightning component
            console.log('LDS: '+ lds);
            console.log(component.get('v.leads'));
        });
        $A.enqueueAction(action);
    }
})