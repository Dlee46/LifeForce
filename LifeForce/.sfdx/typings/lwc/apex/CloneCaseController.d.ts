declare module "@salesforce/apex/CloneCaseController.cloneCaseAndReturnProducts" {
  export default function cloneCaseAndReturnProducts(param: {C: any, sourceCaseRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/CloneCaseController.cloneProductSelections" {
  export default function cloneProductSelections(param: {sourceCaseRecordId: any, clonedCRecordId: any, lstSourceLineItemIds: any, lstLineItemsChanges: any}): Promise<any>;
}
