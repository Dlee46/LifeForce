public class OrderTriggerHandler {
    public void handleOrderItem(List<id> invoicedOrders){
        //get related products (Order items)
        List<OrderItem> relatedProducts = [SELECT Quantity, UnitPrice, OrderId, Order.Account.Name, Product2Id, Order.AccountId,
                                           Order.EffectiveDate, Order.Contract.contractTerm, Product2.Name
                                          FROM OrderItem
                                          WHERE OrderId IN:invoicedOrders];
        
        //list to hold assets
        List<Asset> assets = new List<Asset>();

        //create new asset and populate field with values from related order item
       
            for(OrderItem item : relatedProducts){
                Asset assetItem = new Asset(Name =  item.product2.name +' - ' + item.order.account.name, Product2Id = item.product2Id, AccountId = item.order.accountid,
                                            Quantity = item.Quantity, Price = item.UnitPrice, PurchaseDate = item.order.EffectiveDate);
                assetItem.UsageEndDate = assetItem.PurchaseDate + item.order.contract.ContractTerm;
                assets.add(assetItem);
            }
        if(assets.size() > 0 ){
            insert assets;
        }
      
    }
}