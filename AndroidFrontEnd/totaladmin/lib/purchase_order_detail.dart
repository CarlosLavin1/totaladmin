import 'package:flutter/material.dart';
import 'models/po_search_sesults_api_dto.dart';

class PoDetailPage extends StatelessWidget {
  final POSearchResultsApiDTO po;

  const PoDetailPage({Key? key, required this.po}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PO NUM: ${po.formattedPoNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Material(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'Supervisor\n',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: '${po.supervisorName}',
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Status: ${po.status}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text('Total number of items: ${po.totalItems}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text('Grand Total: \$${po.grandTotal?.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
