declare module "@salesforce/apex/ProductSelectionController.getProducts" {
  export default function getProducts(param: {searchKeyword: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductSelectionController.addProdToCase" {
  export default function addProdToCase(param: {ParentId: any, listProdIds: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductSelectionController.addProdToLead" {
  export default function addProdToLead(param: {ParentId: any, listProdIds: any}): Promise<any>;
}
