class PODisplayDTO {
  final int poNumber;
  final DateTime creationDate;
  final String status;
  final double subtotal;
  final double tax;
  final double grandTotal;
  final String formattedPoNumber;

  PODisplayDTO({
    required this.poNumber,
    required this.creationDate,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.grandTotal,
    required this.formattedPoNumber,
  });

  factory PODisplayDTO.fromJson(Map<String, dynamic> json) {
    return PODisplayDTO(
      poNumber: json['poNumber'],
      creationDate: DateTime.parse(json['creationDate']),
      status: json['status'],
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      grandTotal: json['grandTotal'].toDouble(),
      formattedPoNumber: json['formattedPoNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poNumber': poNumber,
      'creationDate': creationDate.toIso8601String(),
      'status': status,
      'subtotal': subtotal,
      'tax': tax,
      'grandTotal': grandTotal,
      'formattedPoNumber': formattedPoNumber,
    };
  }
}
