import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService {
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    Uri url = Uri.parse(
        'https://10.0.2.2:7161/api/login'); // Use 10.0.2.2 for Android emulator
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        // write user data to stored prefs
        await _storage.write(key: 'token', value: data['token']);
        await _storage.write(key: 'role', value: data['role']);
        await _storage.write(
            key: 'employeeNumber', value: data['employeeNumber'].toString());
        await _storage.write(key: 'email', value: data['email']);
        return true;
      } else {
        print("Failed to login: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error logging in: $e");
      return false;
    }
  }

  //retrieve emp number from stored prefs
  Future<String> getEmployeeNumberFormatted() async {
    String? data = await _storage.read(key: 'employeeNumber') ?? "";
    int number = int.tryParse(data) ?? 0;
    String paddedNumber = number.toString().padLeft(8, '0');
    return paddedNumber;
  }

  Future<String?> getEmployeeNumber() async {
    return await _storage.read(key: 'employeeNumber');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: 'role');
  }

  Future<void> clearAllData() async {
    // Clear all secure storage data
    await _storage.deleteAll();
  }
}
