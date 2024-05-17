import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:totaladmin/view_po_details.dart';

class SearchPo extends StatefulWidget {
  @override
  _SearchPoState createState() => _SearchPoState();
}

class _SearchPoState extends State<SearchPo> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Purchase Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Purchase Order Number',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPo(poNumber: int.parse(_controller.text)),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
