export class Employee {
    employeeNumber: number;
    firstName: string;
    middleInitial: string;
    lastName: string;
    email: string;
    hashedPassword: string;
    streetAddress: string;
    city: string;
    postalCode: string;
    sin: string;
    jobTitle: string;
    seniorityDate: Date | string;
    jobStartDate: Date | string;
    dateOfBirth: Date | string;
    officeLocation: string;
    workPhoneNumber: string;
    cellPhoneNumber: string;
    retiredDate: Date | null | string;
    terminatedDate: Date | null | string;
    statusId: number;
    supervisorEmployeeNumber: number;
    departmentId: number;
    roleId: number;
    rowVersion: any;
  }