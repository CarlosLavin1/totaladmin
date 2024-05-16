export class Review {
    [x: string]: any;
    id: number;
    ratingId: number;
    comment: string;
    reviewDate: Date | string;
    employeeNumber: number;
    supervisorEmployeeNumber: number;
    hasBeenRead: boolean;
}