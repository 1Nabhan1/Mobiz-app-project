class ExpenseDetail {
  final int? id;
  final String? invoiceNo;
  final String? inDate;
  final String? inTime;
  final int? expenseId;
  final String? amount;
  final String? description;
  final String? status;
  final String? rejectedReason;
  final String? approvedReason;
  final int? storeId;
  final int? vanId;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final List<Expense>? expenses;

  ExpenseDetail({
    this.id,
    required this.invoiceNo,
    required this.inDate,
    required this.inTime,
    required this.expenseId,
    required this.amount,
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
    required this.expenses,
  });

  factory ExpenseDetail.fromJson(Map<String, dynamic> json) {
    var expenseList = json['expense'] as List;
    List<Expense> expenses = expenseList.map((e) => Expense.fromJson(e)).toList();

    return ExpenseDetail(
      id: json['id'],
      invoiceNo: json['invoice_no'],
      inDate: json['in_date'],
      inTime: json['in_time'],
      expenseId: json['expense_id'],
      amount: json['amount'],
      description: json['description'],
      status: json['status'],
      rejectedReason: json['rejected_reason'],
      approvedReason: json['approved_reason'],
      storeId: json['store_id'],
      vanId: json['van_id'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      expenses: expenses,
    );
  }
}

class Expense {
  final int? id;
  final String? name;
  final String? description;
  final int? storeId;
  final String? createdAt;
  final String? updatedAt;
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