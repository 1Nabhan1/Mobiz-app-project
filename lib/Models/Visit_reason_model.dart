class VisitReason {
  int id;
  String? visitType;
  String? reason;
  String? description;
  int storeId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  VisitReason({
    required this.id,
    this.visitType,
    this.reason,
    this.description,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory VisitReason.fromJson(Map<String, dynamic> json) {
    return VisitReason(
      id: json['id'],
      visitType: json['vistit_type'],
      reason: json['reasone'],
      description: json['description'],
      storeId: json['store_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'],
    );
  }
}

class VisitReasonResponse {
  List<VisitReason> data;
  bool success;
  List<dynamic> messages;

  VisitReasonResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory VisitReasonResponse.fromJson(Map<String, dynamic> json) {
    return VisitReasonResponse(
      data: List<VisitReason>.from(json['data'].map((x) => VisitReason.fromJson(x))),
      success: json['success'],
      messages: List<dynamic>.from(json['messages']),
    );
  }
}
