import 'item.dart';

class PurchaseOrder {
  final int poNumber;
  final DateTime creationDate;
  final List<int>? rowVersion;
  final int employeeNumber;
  final String employeeName;
  final String employeeSupervisorName;
  final String empDepartmentName;
  final String purchaseOrderStatus;
  final int statusId;
  final List<Item>? items;
  final bool hasMergeOccurred;
  final String formattedPoNumber;

  // Derived properties
  double get subtotal =>
      items?.fold(0, (prev, item) => prev! + item.price * item.quantity) ?? 0;
  double get tax => subtotal * 0.05;
  double get grandTotal => subtotal + tax;

  

  PurchaseOrder({
    required this.poNumber,
    required this.creationDate,
    this.rowVersion,
    required this.employeeNumber,
    required this.employeeName,
    required this.employeeSupervisorName,
    required this.empDepartmentName,
    required this.purchaseOrderStatus,
    required this.statusId,
    this.items,
    required this.hasMergeOccurred,
    required this.formattedPoNumber,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      poNumber: json['poNumber'],
      creationDate: DateTime.parse(json['creationDate']),
      rowVersion: json['rowVersion'].cast<int>(),
      employeeNumber: json['employeeNumber'],
      employeeName: json['employeeName'],
      employeeSupervisorName: json['employeeSupervisorName'],
      empDepartmentName: json['empDepartmentName'],
      purchaseOrderStatus: json['purchaseOrderStatus'],
      statusId: json['statusId'],
      items: (json['items'] as List).map((i) => Item.fromJson(i)).toList(),
      hasMergeOccurred: json['hasMergeOccurred'],
      formattedPoNumber: json['formattedPoNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poNumber': poNumber,
      'creationDate': creationDate.toIso8601String(),
      'rowVersion': rowVersion,
      'employeeNumber': employeeNumber,
      'employeeName': employeeName,
      'employeeSupervisorName': employeeSupervisorName,
      'empDepartmentName': empDepartmentName,
      'purchaseOrderStatus': purchaseOrderStatus,
      'statusId': statusId,
      'items': items?.map((item) => item.toJson()).toList(),
      'hasMergeOccurred': hasMergeOccurred,
      'formattedPoNumber': formattedPoNumber,
    };
  }
}
