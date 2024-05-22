import 'item.dart';

class PurchaseOrder {
  final int poNumber;
  final DateTime creationDate;
  final int employeeNumber;
  final String? employeeName;
  final String? employeeSupervisorName;
  final String? empDepartmentName;
  final String? purchaseOrderStatus;
  final int statusId;
  final List<Item>? items;
  final bool? hasMergeOccurred;
  final String? formattedPoNumber;
  final double? grandTotal;
  final double? subtotal;
  final double? tax;
  final double? totalExpenseAmt;
  final List<dynamic>? errors;
  final String? employeeEmail;

  PurchaseOrder({
    required this.poNumber,
    required this.creationDate,
    required this.employeeNumber,
    this.employeeName,
    this.employeeSupervisorName,
    this.empDepartmentName,
    this.purchaseOrderStatus,
    required this.statusId,
    this.items,
    this.hasMergeOccurred,
    this.formattedPoNumber,
    this.grandTotal,
    this.subtotal,
    this.tax,
    this.totalExpenseAmt,
    this.errors,
    this.employeeEmail,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      poNumber: json['poNumber'],
      creationDate: DateTime.parse(json['creationDate']),
      employeeNumber: json['employeeNumber'],
      employeeName: json['employeeName'] as String?,
      employeeSupervisorName: json['employeeSupervisorName'] as String?,
      empDepartmentName: json['empDepartmentName'] as String?,
      purchaseOrderStatus: json['purchaseOrderStatus'] as String?,
      statusId: json['statusId'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => Item.fromJson(item))
          .toList(),
      hasMergeOccurred: json['hasMergeOccurred'] as bool?,
      formattedPoNumber: json['formattedPoNumber'] as String?,
      grandTotal: (json['grandTotal'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      totalExpenseAmt: (json['totalExpenseAmt'] as num?)?.toDouble(),
      errors: json['errors'] as List<dynamic>?,
      employeeEmail: json['employeeEmail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poNumber': poNumber,
      'creationDate': creationDate.toIso8601String(),
      'employeeNumber': employeeNumber,
      'employeeName': employeeName,
      'employeeSupervisorName': employeeSupervisorName,
      'empDepartmentName': empDepartmentName,
      'purchaseOrderStatus': purchaseOrderStatus,
      'statusId': statusId,
      'items': items?.map((item) => item.toJson()).toList(),
      'hasMergeOccurred': hasMergeOccurred,
      'formattedPoNumber': formattedPoNumber,
      'grandTotal': grandTotal,
      'subtotal': subtotal,
      'tax': tax,
      'totalExpenseAmt': totalExpenseAmt,
      'errors': errors,
      'employeeEmail': employeeEmail,
    };
  }

  @override
  String toString() {
    return 'PurchaseOrder{poNumber: $poNumber, creationDate: $creationDate, employeeNumber: $employeeNumber, employeeName: $employeeName, employeeSupervisorName: $employeeSupervisorName, empDepartmentName: $empDepartmentName, purchaseOrderStatus: $purchaseOrderStatus, statusId: $statusId, items: $items, hasMergeOccurred: $hasMergeOccurred, formattedPoNumber: $formattedPoNumber, grandTotal: $grandTotal, subtotal: $subtotal, tax: $tax, totalExpenseAmt: $totalExpenseAmt, errors: $errors, employeeEmail: $employeeEmail}';
  }
}
