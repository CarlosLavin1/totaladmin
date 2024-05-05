import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:totaladmin/services/department_service.dart';
import 'package:totaladmin/services/employee_service.dart';
import 'models/department.dart';
import 'models/employee.dart';

class EmployeeSearch extends StatefulWidget {
  const EmployeeSearch({super.key});

  @override
  State<EmployeeSearch> createState() => _EmployeeSearchState();
}

class _EmployeeSearchState extends State<EmployeeSearch> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final departmentService = DepartmentService();
  final employeeService = EmployeeService();
  final TextEditingController _employeeNumberController =
      TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  List<Department> departments = [];
  List<Employee> searchResults = [];
  int selectedDepartmentId = 0;
  bool searched = false;

  @override
  void initState() {
    super.initState();
    loadDepartments();
    searched = false;
  }

  Future<void> loadDepartments() async {
    List<Department> fetchedDepartments =
        await departmentService.getActiveDepartments();
    setState(() {
      departments =
          [Department(id: 0, name: 'Select A Department')] + fetchedDepartments;
    });
  }

  void searchEmployees() async {
    searched = true;
    // make sure employee number is 8 digits
    String empNumber =
        RegExp(r'^\d{8}$').hasMatch(_employeeNumberController.text)
            ? _employeeNumberController.text
            : '999999999';
    int employeeNumber = int.tryParse(empNumber) ?? 0; // Default if parse fails
    if (_employeeNumberController.text.isEmpty) employeeNumber = 0;

    String lastName = _lastNameController.text;

    List<Employee> results = await employeeService.searchEmployees(
        employeeNumber, selectedDepartmentId, lastName);

    setState(() {
      searchResults = results;
    });

    if (results.isEmpty) {
      print('No results found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Search"),
        centerTitle: true,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButton<int>(
                value: selectedDepartmentId,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedDepartmentId = newValue!;
                  });
                },
                items: departments
                    .map<DropdownMenuItem<int>>((Department department) {
                  return DropdownMenuItem<int>(
                    value: department.id,
                    child: Text(department.name),
                  );
                }).toList(),
              ),
              TextField(
                controller: _employeeNumberController,
                decoration: const InputDecoration(
                  labelText: 'Employee Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              // vertical spacer
              const SizedBox(height: 10),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Employee Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              // vertical spacer
              const SizedBox(height: 20),
              // submit button
              ElevatedButton(
                onPressed: () {
                  // search employees
                  searchEmployees();
                },
                child: const Text('Search'),
              ),
              // vertical spacer
              const SizedBox(height: 5),
              Visibility(
                visible: searchResults.isNotEmpty,
                child: Expanded(
                  child: ListView.separated(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            '${searchResults[index].firstName} ${searchResults[index].lastName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                'Work Phone: ${searchResults[index].workPhone}'),
                            Text(
                                'Office Location: ${searchResults[index].officeLocation}'),
                            Text('Job Title: ${searchResults[index].jobTitle}'),
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
              ),
              Visibility(
                visible: searchResults.isEmpty && searched,
                child: const Center(
                  child: Text("No employees found"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _employeeNumberController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
