({
    SearchHelper : function(component, event) {
        const action = component.get("c.getProducts");
        action.setParams({
            'searchKeyword': component.get("v.searchKeyword")
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                // set product list with return value from server.
                component.set("v.product", storeResponse); 
                
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    addSelectedProds : function(component, event, prodRecIds){
        // call apex method addCase
        let action = component.get("c.addProdToLead");
        // passing both product and case record id(s) to apex controller
        action.setParams({
            "ParentId" : component.get("v.recordId"),
            "listProdIds" : prodRecIds
        });
        action.setCallback(this, function(res){
            const state = res.getState();
            if(state === "SUCCESS"){
                console.log("It worked!")
            } else if (state === "ERROR") {
                console.log(action.getError()[0].message);
            }
            // init again to clear checkbox
            this.SearchHelper(component, event);
        });
        $A.enqueueAction(action);
    }
})