import { Item } from "./item";

export class PurchaseOrder {
    poNumber: number;
    creationDate: Date;
    rowVersion: number;
    employeeNumber: number;
    employeeName: string | null;
    employeeSupervisorName: string | null;
    empDepartmentName: string | null;
    purchaseOrderStatus: any;
    statusId: number;
    items: Item[];
    hasMergeOccurred: boolean;
    formattedPoNumber: string | null;
}

  