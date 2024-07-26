class Expense {
  final int id;
  final String name;
  final String? description;
  final int storeId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Expense({
    required this.id,
    required this.name,
    this.description,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      storeId: json['store_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

class VisitReasonResponse {
  List<Expense> data;
  bool success;
  List<dynamic> messages;

  VisitReasonResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory VisitReasonResponse.fromJson(Map<String, dynamic> json) {
    return VisitReasonResponse(
      data: List<Expense>.from(json['data'].map((x) => Expense.fromJson(x))),
      success: json['success'],
      messages: List<dynamic>.from(json['messages']),
    );
  }
}
