import 'package:flutter/material.dart';
import 'package:totaladmin/main.dart';
import 'package:get/get.dart';

class AuthLogic {
  static void logIn(
      BuildContext context,
      TextEditingController employeeNumberController,
      TextEditingController passwordController,
      Function login,
      Function showError) async {
    // Get the values entered by the user
    final employeeNumber = employeeNumberController.text;
    final password = passwordController.text;

    // Check if a user with the entered email and password exists in the database
    bool success = await login(employeeNumber, password);

    if (success) {
      // If a user is found, navigate to the main page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // If no user is found, show an error message
      showError("Invalid credentials");
      // Get.snackbar(
      //   'Error',
      //   'Invalid login credentials',
      //   backgroundColor: Colors.red,
      //   snackPosition: SnackPosition.TOP,
      // );
    }
  }
}
