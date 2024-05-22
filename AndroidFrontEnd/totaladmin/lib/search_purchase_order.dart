import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:totaladmin/view_po_details.dart';

class SearchPo extends StatefulWidget {
  const SearchPo({super.key});

  @override
  _SearchPoState createState() => _SearchPoState();
}

class _SearchPoState extends State<SearchPo> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

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
              decoration: InputDecoration(
                labelText: 'Enter PO Number ex. 0000101',
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () {
                if (_controller.text.isEmpty) {
                  setState(() {
                    _errorMessage = 'Please enter a Purchase Order Number.';
                  });
                } else if (_controller.text.startsWith('00001')) {
                  final poNumber =
                      int.tryParse(_controller.text.replaceAll('00001', ''));
                  if (poNumber != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPo(poNumber: poNumber),
                      ),
                    );
                    setState(() {
                      _errorMessage = null;
                    });
                  } else {
                    setState(() {
                      _errorMessage =
                          'Please enter a valid Purchase Order Number';
                    });
                  }
                } else {
                  setState(() {
                    _errorMessage =
                        'Please enter a valid Purchase Order Number.';
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
