import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class EmployeeService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Employee>> searchEmployees(
      int employeeNumber, int departmentId, String lastName) async {
    String token = await _storage.read(key: 'token') ?? "";
    Uri url = Uri.parse('https://10.0.2.2:7161/api/employee/search');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = json.encode({
      'department': departmentId,
      'employeeNumber': employeeNumber,
      'lastName': lastName
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Employee.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}
