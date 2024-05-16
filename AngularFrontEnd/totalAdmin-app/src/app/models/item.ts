export class Item {
    itemId: number;
    name?: string;
    quantity?: number | null;
    description?: string;
    price?: number | null;
    justification?: string;
    location?: string;
    statusId?: number;
    itemStatus?: string | null
    poNumber?: number;
    subtotal?: number;
    tax?: number;
    grandTotal?: number;
    rejectedReason?: string | null
    modifiedReason?: string | null
    isEditing?: boolean
    editingColumn?: string | null
}
