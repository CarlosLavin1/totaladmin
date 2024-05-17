import 'package:flutter/material.dart';
import 'package:totaladmin/models/purchaseOrder.dart';
import 'package:totaladmin/services/purchase_order_service.dart';

class ViewPo extends StatefulWidget {
  final int poNumber;

  const ViewPo({Key? key, required this.poNumber}) : super(key: key);

  @override
  _ViewPoState createState() => _ViewPoState();
}

class _ViewPoState extends State<ViewPo> {
  final PoService _purchaseOrderService = PoService();
  PurchaseOrder? _purchaseOrder;

  @override
  void initState() {
    super.initState();
    _fetchPurchaseOrderDetails();
  }

  Future<void> _fetchPurchaseOrderDetails() async {
    try {
      PurchaseOrder purchaseOrder =
          await _purchaseOrderService.getPurchaseOrderDetails(widget.poNumber);
      setState(() {
        _purchaseOrder = purchaseOrder;
      });
    } catch (e) {
      print('Error fetching purchase order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Order Details'),
      ),
      body: _purchaseOrder == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Purchase Order Number: ${_purchaseOrder!.formattedPoNumber}',
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Supervisor Name: ${_purchaseOrder!.employeeSupervisorName}',
                  ),
                  const SizedBox(height: 8.0),
                  Text('Purchase Order Status: ${_purchaseOrder!.statusId}'),
                  const SizedBox(height: 8.0),
                  Text(
                    'Number of Purchase Order Items: ${_purchaseOrder!.items?.length}',
                  ),
                ],
              ),
            ),
    );
  }
}
// po always null