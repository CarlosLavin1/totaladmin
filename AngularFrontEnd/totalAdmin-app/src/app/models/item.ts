export class Item {
    itemId: number;
    name?: string;
    quantity?: number;
    description?: string;
    price?: number;
    justification?: string;
    location?: string;
    statusId?: number;
    itemStatus?: string | null
    poNumber?: number;
    subtotal?: number;
    tax?: number;
    grandTotal?: number;
    rejectedReason?: string | null
}
