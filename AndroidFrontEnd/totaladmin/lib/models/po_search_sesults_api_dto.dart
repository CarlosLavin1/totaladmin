
import 'dart:convert';

class POSearchResultsApiDTO {
  final int poNumber;
  final DateTime creationDate;
  final String? supervisorName;
  final String? status;
  final int? totalItems;
  final double? grandTotal;
  final String? formattedPoNumber;

  POSearchResultsApiDTO(
      {required this.poNumber,
      required this.creationDate,
      this.supervisorName,
      this.status,
      this.totalItems,
      this.grandTotal,
      this.formattedPoNumber
  });

  factory POSearchResultsApiDTO.fromJson(Map<String, dynamic> json) {
    return POSearchResultsApiDTO(
      poNumber: json['poNumber'],
      creationDate: DateTime.parse(json['creationDate']),
      supervisorName: json['supervisorName'],
      status: json['status'],
      totalItems: json['totalItems'],
      grandTotal: json['grandTotal'],
      formattedPoNumber: json['formattedPoNumber']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poNumber': poNumber,
      'creationDate': creationDate.toIso8601String(),
      'supervisorName': supervisorName,
      'status': status,
      'totalItems': totalItems,
      'grandTotal': grandTotal,
      'formattedPoNumber': formattedPoNumber
    };
  }
}
