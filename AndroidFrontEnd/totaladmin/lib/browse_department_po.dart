import 'package:flutter/material.dart';
import 'package:totaladmin/models/po_search_sesults_api_dto.dart';
import 'package:totaladmin/purchase_order_detail.dart';
import 'package:totaladmin/services/department_service.dart';
import 'package:totaladmin/services/purchase_order_service.dart';

import 'models/department.dart';

class BrowseDepartmentPo extends StatefulWidget {
  const BrowseDepartmentPo({Key? key}) : super(key: key);

  @override
  _BrowseDepartmentPoState createState() => _BrowseDepartmentPoState();
}

class _BrowseDepartmentPoState extends State<BrowseDepartmentPo> {
  final poService = PoService();
  final departmentService = DepartmentService();
  late Future<List<POSearchResultsApiDTO>> futurePoList;
  List<Department> departments = [];
  int? selectedDepartmentId;

  @override
  void initState() {
    super.initState();
    loadDepartments();
    futurePoList = Future.value([]);
  }

  Future<void> loadDepartments() async {
    List<Department> fetchedDepartments =
        await departmentService.getActiveDepartments();
    setState(() {
      departments =
          [Department(id: 0, name: 'Select A Department')] + fetchedDepartments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Purchase Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            DropdownButton<int>(
              hint: const Text('Select Department', style: TextStyle(fontSize: 18)),
              value: selectedDepartmentId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedDepartmentId = newValue;
                  futurePoList = poService
                      .getPuchaseOrdersForDepartment(selectedDepartmentId);
                });
              },
              items:
                  departments.map<DropdownMenuItem<int>>((Department department) {
                return DropdownMenuItem<int>(
                  value: department.id,
                  child: Text(department.name),
                );
              }).toList(),
            ),
            FutureBuilder<List<POSearchResultsApiDTO>>(
              future: futurePoList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (selectedDepartmentId == null) {
                  return const Center(
                    child: Text(
                        'Please select a department to view its purchase orders'),
                  );
                } else if (snapshot.data?.isEmpty ?? false) {
                  return const Text(
                      'No purchase orders found for this department');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              'PO Number: ${snapshot.data![index].formattedPoNumber}', style: const TextStyle(fontSize: 20)),
                          subtitle: Text(
                              'Creation Date: ${snapshot.data![index].creationDate}\n'
                              'Supervisor Name: ${snapshot.data![index].supervisorName}\n'
                              'PO Status: ${snapshot.data![index].status}', style: const TextStyle(fontSize: 16)),
                          onTap: () {
                            // Navigate to detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PoDetailPage(po: snapshot.data![index]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
