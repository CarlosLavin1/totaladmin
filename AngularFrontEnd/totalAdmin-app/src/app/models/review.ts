export class Review {
    id: number;
    ratingId: number;
    comment: string;
    reviewDate: Date | string;
    employeeNumber: number;
    supervisorEmployeeNumber: number;
    hasBeenRead: boolean;
}