class POSearchFiltersDTO {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? poNumber;
  final int? employeeNumber;

  POSearchFiltersDTO({
    this.startDate,
    this.endDate,
    this.poNumber,
    this.employeeNumber,
  });

  factory POSearchFiltersDTO.fromJson(Map<String, dynamic> json) {
    return POSearchFiltersDTO(
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      poNumber: json['poNumber'],
      employeeNumber: json['employeeNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'poNumber': poNumber,
      'employeeNumber': employeeNumber,
    };
  }
}