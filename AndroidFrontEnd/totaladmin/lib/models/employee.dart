class Employee {
  final int employeeNumber;
  final String firstName;
  final String lastName;
  final String workPhone;
  final String officeLocation;
  final String jobTitle;

  Employee(
      {required this.employeeNumber,
      required this.firstName,
      required this.lastName,
      required this.workPhone,
      required this.officeLocation,
      required this.jobTitle});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeNumber: json['employeeNumber'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      workPhone: json['workPhone'],
      officeLocation: json['officeLocation'],
      jobTitle: json['jobTitle'],
    );
  }
}
