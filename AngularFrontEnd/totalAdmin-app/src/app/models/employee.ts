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
    seniorityDate: Date;
    jobStartDate: Date;
    dateOfBirth: Date;
    officeLocation: string;
    workPhoneNumber: string;
    cellPhoneNumber: string;
    retiredDate: Date | null;
    terminatedDate: Date | null;
    statusId: number;
    supervisorEmployeeNumber: number;
    departmentId: number;
    roleId: number;
    rowVersion: any;
  }