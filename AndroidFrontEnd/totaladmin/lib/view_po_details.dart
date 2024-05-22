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
  bool _isLoading = true; // Add this line

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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Order Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _purchaseOrder == null
              ? const Center(child: Text('Purchase order not found.', style: TextStyle(fontSize: 20, color: Colors.black54)))
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Purchase Order Number: ${_purchaseOrder?.formattedPoNumber ?? _purchaseOrder!.poNumber}',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 20),
                        Text(
                            'Supervisor: ${_purchaseOrder?.employeeSupervisorName ?? 'N/A'}',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 20),
                        Text(
                            'Status: ${_purchaseOrder?.purchaseOrderStatus ?? 'N/A'}',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 20),
                        Text('Has ${_purchaseOrder?.items?.length ?? 0} Items',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 20),
                        Text(
                            'Total: \$${_purchaseOrder?.grandTotal?.toStringAsFixed(2) ?? 0}',
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
    );
  }
}
