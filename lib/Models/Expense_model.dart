// expense_detail.dart
class ExpenseDetail {
  int id;
  String? invoiceNo;
  String inDate;
  String inTime;
  int expenseId;
  String amount;
  String vatAmount;
  String totalAmount;
  String description;
  String status;
  String? rejectedReason;
  String? approvedReason;
  int storeId;
  int vanId;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  List<Expense> expense;
  List<Document> documents;

  ExpenseDetail({
    required this.id,
    this.invoiceNo,
    required this.inDate,
    required this.inTime,
    required this.expenseId,
    required this.amount,
    required this.totalAmount,
    required this.vatAmount,
    required this.description,
    required this.status,
    this.rejectedReason,
    this.approvedReason,
    required this.storeId,
    required this.vanId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.expense,
    required this.documents,
  });

  factory ExpenseDetail.fromJson(Map<String, dynamic> json) {
    return ExpenseDetail(
      id: json['id'],
      invoiceNo: json['invoice_no'],
      inDate: json['in_date'],
      inTime: json['in_time'],
      expenseId: json['expense_id'],
      amount: json['amount'],
      vatAmount: json['vat_amount'],
      totalAmount: json['total_amount'],
      description: json['description'] ?? "",
      status: json['status'],
      rejectedReason: json['rejected_reason'],
      approvedReason: json['approved_reason'],
      storeId: json['store_id'],
      vanId: json['van_id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      expense:
          (json['expense'] as List).map((e) => Expense.fromJson(e)).toList(),
      documents:
          (json['documents'] as List).map((e) => Document.fromJson(e)).toList(),
    );
  }
}

class Expense {
  int id;
  String name;
  String? description;
  int storeId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

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
      name: json['name'] ?? "",
      description: json['description'],
      storeId: json['store_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}

class Document {
  int id;
  int expenseDetailId;
  String documentName;
  int storeId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  Document({
    required this.id,
    required this.expenseDetailId,
    required this.documentName,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      expenseDetailId: json['expense_detail_id'],
      documentName: json['document_name'],
      storeId: json['store_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}
