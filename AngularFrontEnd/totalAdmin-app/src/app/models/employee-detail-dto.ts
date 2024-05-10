export interface EmployeeDetailDTO {
    employeeNumber: number;
    firstName: string | null;
    middleInitial: string | null;
    lastName: string | null;
    streetAddress: string | null;
    city: string | null;
    postalCode: string | null;
    workPhone: string | null;
    cellPhone: string | null;
    email: string | null;
    jobTitle: string | null;
    showDetails: boolean;
}