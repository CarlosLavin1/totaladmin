import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/employee.dart';

class EmployeeDetail extends StatefulWidget {
  final Employee employee;
  const EmployeeDetail({super.key, required this.employee});
  // display firstFirst name Middle initial (if present) Last Name Home mailing address Work phone number Cellphone number Work email address
  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${widget.employee.firstName} ${widget.employee.middleInitial.isNotEmpty ? "${widget.employee.middleInitial} " : ""}${widget.employee.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Home Mailing Address:\n${widget.employee.streetAddress}, ${widget.employee.city} ${widget.employee.postalCode}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _launchPhone(widget.employee.workPhone),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Work Phone: ',
                    ),
                    TextSpan(
                      text: widget.employee.workPhone, // Phone number
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _launchPhone(widget.employee.cellPhone),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Cell Phone: ',
                    ),
                    TextSpan(
                      text: widget.employee.cellPhone, // Phone number
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _launchEmail(widget.employee.email),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Email: ',
                    ),
                    TextSpan(
                      text: widget.employee.email, // email
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // send email method
  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(emailLaunchUri);
  }

  // make call
  void _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    await launchUrl(phoneLaunchUri);
  }
}
