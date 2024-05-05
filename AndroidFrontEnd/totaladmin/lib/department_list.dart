import 'package:flutter/material.dart';
import 'package:totaladmin/services/department_service.dart';

import 'models/department.dart';

class DepartmentList extends StatefulWidget {
  const DepartmentList({super.key});

  @override
  State<DepartmentList> createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  final departmentService = DepartmentService();
  late Future<List<Department>> departments;

  @override
  void initState() {
    super.initState();
    departments = departmentService.getActiveDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Department List"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Department>>(
        future: departments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Department department = snapshot.data![index];
                return ListTile(
                  title: Text(department.name),
                  subtitle: Text('ID: ${department.id}'),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
