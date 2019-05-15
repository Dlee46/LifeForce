({
   /*
    doInit : function(component, event, helper) {
        helper.getProductRecords(component, event);
    },
    */
    Search: function(component, event, helper) {
        var searchField = component.find('searchField');
            // call helper function 
            helper.SearchHelper(component, event);
    },
    selectAll : function(cmp, evt, helper) {
        // searches for the aura:id marked checkedboxRow and adds/removes them all
        let sc = evt.getSource().get("v.value");
        let getCheckedId = cmp.find("checkboxRow");
        
        if (sc == true) {
            for (let i = 0; i < getCheckedId.length; i++) {
                cmp.find("checkboxRow")[i].set("v.value", true);
            }
        } else {
            for ( let i = 0; i < getCheckedId.length; i++) {
                cmp.find("checkboxRow")[i].set("v.value", false);
            }
        }
    },
    unselectAll : function (cmp, evt, helper) {
        let scRow = evt.getSource().get("v.value");
        let getId = cmp.find("checkbox");
        if(scRow == false){
            cmp.find("checkbox").set("v.value", false);
        }
    },
    addSelected : function (cmp, evt, helper){
        // retrieve all the aura:id checkboxRow
        let getCheckedIds = cmp.find("checkboxRow");
        // store the id(s) from the selected checkbox in the variable
        let selectedRec = [];
        // loop through every checkbox value and if checked add those 
        // Id(s) in the selectedRec using the text attribute
        for(let i = 0; i < getCheckedIds.length; i++){
            if(getCheckedIds[i].get("v.value") == true){
                selectedRec.push(getCheckedIds[i].get("v.text"));
            }
        }
        // pass all the ids using the helper function
        helper.addSelectedProds(cmp, evt, selectedRec);
        $A.get('e.force:refreshView').fire();
    }
})