import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:totaladmin/models/department.dart';

class DepartmentService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Department>> getActiveDepartments() async {
    String token = await _storage.read(key: 'token') ?? "";
    Uri url = Uri.parse('https://10.0.2.2:7161/api/department');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Department.fromJson(data)).toList();
    } else {
      return [];
    }
  }
}
