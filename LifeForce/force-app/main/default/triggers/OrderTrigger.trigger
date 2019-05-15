// when an order is created add products related to the opportunity to order product 
trigger OrderTrigger on Order (after update){ 
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Id> invoicedOrders = new List<Id>();
        for(Order ord: Trigger.new){
            Order oldRecord = (Order) Trigger.oldMap.get( ord.id );
            //check status 
            if(ord.status == 'Activated' && oldRecord.status != 'Activated'){
                invoicedOrders.add(ord.id);
            }
        }
        System.debug('Size: '+ invoicedOrders.size());
        if(invoicedOrders.size() > 0){
            OrderTriggerHandler ordHandler = new OrderTriggerHandler();
            ordHandler.handleOrderItem(invoicedOrders);
        }
    }
}