class Employee {
  final int employeeNumber;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String workPhone;
  final String cellPhone;
  final String email;
  final String streetAddress;
  final String city;
  final String postalCode;
  final String jobTitle;

  Employee({
    required this.employeeNumber,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.workPhone,
    required this.cellPhone,
    required this.email,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
    required this.jobTitle,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeNumber: json['employeeNumber'],
      firstName: json['firstName'],
      middleInitial: json['middleInitial'],
      lastName: json['lastName'],
      workPhone: json['workPhone'],
      cellPhone: json['cellPhone'],
      email: json['email'],
      streetAddress: json['streetAddress'],
      city: json['city'],
      postalCode: json['postalCode'],
      jobTitle: json['jobTitle'],
    );
  }
}
