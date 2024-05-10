import 'package:flutter/material.dart';
import 'package:totaladmin/employee_search.dart';
import 'package:totaladmin/login.dart';
import 'dart:io';

import 'package:totaladmin/services/auth_service.dart';

import 'browse_department_po.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TotalAdmin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

// this to ignore any ssl certificates for the https connection
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthenticationService();
  String role = "";
  String employeeNumber = "";

  void _getEmployeeNumber() async {
    employeeNumber = await authService.getEmployeeNumberFormatted();
    setState(() {});
  }

  void _getEmployeeRole() async {
    role = await authService.getUserRole() ?? "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getEmployeeNumber();
    _getEmployeeRole();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TotalAdmin"), // replace this with logo image
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              if (role.startsWith("Employee")) ...[
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Employee Search'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmployeeSearch(),
                      ),
                    );
                  },
                ),
              ],
              if (role.startsWith("Supervisor")) ...[
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Browse Department Purchase Orders'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BrowseDepartmentPo(),
                      ),
                    );
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  // Handle user logout
                  authService.clearAllData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                  //print(authService.getEmployeeNumberFormatted());
                },
              ),
            ],
          ),
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text("Welcome, #$employeeNumber", textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
