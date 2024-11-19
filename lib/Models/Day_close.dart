// Rename DataResponse to DayCloseDataResponse
class DayCloseDataResponse {
  final List<DayCloseData> data;
  final bool success;
  final List<String> messages;

  DayCloseDataResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory DayCloseDataResponse.fromJson(Map<String, dynamic> json) {
    return DayCloseDataResponse(
      data: List<DayCloseData>.from(
          json['data'].map((item) => DayCloseData.fromJson(item))),
      success: json['success'],
      messages: List<String>.from(json['messages']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'success': success,
      'messages': messages,
    };
  }
}

class DayCloseData {
  final int id;
  final String inDate;
  final String invoiceNo;
  final int approvel;

  DayCloseData({
    required this.id,
    required this.inDate,
    required this.invoiceNo,
    required this.approvel,
  });

  factory DayCloseData.fromJson(Map<String, dynamic> json) {
    return DayCloseData(
      id: json['id'],
      inDate: json['in_date'],
      invoiceNo: json['invoice_no'],
      approvel: json['approvel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'in_date': inDate,
      'invoice_no': invoiceNo,
      'approvel': approvel,
    };
  }
}

class DataResponse {
  final Data data;
  final bool success;
  final List<String> messages;

  DataResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      data: Data.fromJson(json['data']),
      success: json['success'],
      messages: List<String>.from(json['messages']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'success': success,
      'messages': messages,
    };
  }
}

class Data {
  final int id;
  final String inDate;
  final String inTime;
  final int storeId;
  final int vanId;
  final int userId;
  final int scheduled;
  final int visited;
  final int notVisited;
  final int visitPending;
  final int noOfSales;
  final String amountOfSales;
  final int noOfOrder;
  final String amountOfOrder;
  final int noOfReturns;
  final String amountOfReturns;
  final String collectionCashAmount;
  final int collectionNoOfCheque;
  final String collectionChequeAmount;
  final String lastDayBalanceAmount;
  final String lastDayBalanceNoOfCheque;
  final String lastDayBalanceChequeAmount;
  final String expense;
  final String cashDeposited;
  final String cashHandOver;
  final int noOfChequeDeposited;
  final String chequeDepositedAmount;
  final int noOfChequeHandOver;
  final String chequeHandOverAmount;
  final String balanceCashInHand;
  final int noOfChequeInHand;
  final String chequeAmountInHand;
  final int approval;
  final String invoiceNo;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  List<Sale>? sales;
  List<SaleReturn>? salesReturn;

  Data({
    required this.id,
    required this.inDate,
    required this.inTime,
    required this.storeId,
    required this.vanId,
    required this.userId,
    required this.scheduled,
    required this.visited,
    required this.notVisited,
    required this.visitPending,
    required this.noOfSales,
    required this.amountOfSales,
    required this.noOfOrder,
    required this.amountOfOrder,
    required this.noOfReturns,
    required this.amountOfReturns,
    required this.collectionCashAmount,
    required this.collectionNoOfCheque,
    required this.collectionChequeAmount,
    required this.lastDayBalanceAmount,
    required this.lastDayBalanceNoOfCheque,
    required this.lastDayBalanceChequeAmount,
    required this.expense,
    required this.cashDeposited,
    required this.cashHandOver,
    required this.noOfChequeDeposited,
    required this.chequeDepositedAmount,
    required this.noOfChequeHandOver,
    required this.chequeHandOverAmount,
    required this.balanceCashInHand,
    required this.noOfChequeInHand,
    required this.chequeAmountInHand,
    required this.approval,
    required this.invoiceNo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.sales,
    this.salesReturn,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      inDate: json['in_date'],
      inTime: json['in_time'],
      storeId: json['store_id'],
      vanId: json['van_id'],
      userId: json['user_id'],
      scheduled: json['scheduled'],
      visited: json['visited'],
      notVisited: json['not_visited'],
      visitPending: json['visit_pending'],
      noOfSales: json['no_of_sales'],
      amountOfSales: json['amount_of_sales'],
      noOfOrder: json['no_of_order'],
      amountOfOrder: json['amount_of_order'],
      noOfReturns: json['no_of_returns'],
      amountOfReturns: json['amount_of_returns'],
      collectionCashAmount: json['collection_cash_amount'],
      collectionNoOfCheque: json['collection_no_of_cheque'],
      collectionChequeAmount: json['collection_cheque_amount'],
      lastDayBalanceAmount: json['last_day_balance_amount'],
      lastDayBalanceNoOfCheque:
          json['last_day_balance_no_of_cheque'].toString(),
      lastDayBalanceChequeAmount: json['last_day_balance_cheque_amount'],
      expense: json['expense'],
      cashDeposited: json['cash_deposited'],
      cashHandOver: json['cash_hand_over'],
      noOfChequeDeposited: json['no_of_cheque_deposited'],
      chequeDepositedAmount: json['cheque_deposited_amount'],
      noOfChequeHandOver: json['no_of_cheque_hand_over'],
      chequeHandOverAmount: json['cheque_hand_over_amount'],
      balanceCashInHand: json['balance_cash_in_hand'],
      noOfChequeInHand: json['no_of_cheque_in_hand'],
      chequeAmountInHand: json['cheque_amount_in_hand'],
      approval: json['approvel'],
      invoiceNo: json['invoice_no'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      sales: json['sales'] != null
          ? List<Sale>.from(json['sales'].map((x) => Sale.fromJson(x)))
          : [],
      salesReturn: json['sales_return'] != null
          ? List<SaleReturn>.from(json['sales_return'].map((x) => SaleReturn.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'in_date': inDate,
      'in_time': inTime,
      'store_id': storeId,
      'van_id': vanId,
      'user_id': userId,
      'scheduled': scheduled,
      'visited': visited,
      'not_visited': notVisited,
      'visit_pending': visitPending,
      'no_of_sales': noOfSales,
      'amount_of_sales': amountOfSales,
      'no_of_order': noOfOrder,
      'amount_of_order': amountOfOrder,
      'no_of_returns': noOfReturns,
      'amount_of_returns': amountOfReturns,
      'collection_cash_amount': collectionCashAmount,
      'collection_no_of_cheque': collectionNoOfCheque,
      'collection_cheque_amount': collectionChequeAmount,
      'last_day_balance_amount': lastDayBalanceAmount,
      'last_day_balance_no_of_cheque': lastDayBalanceNoOfCheque,
      'last_day_balance_cheque_amount': lastDayBalanceChequeAmount,
      'expense': expense,
      'cash_deposited': cashDeposited,
      'cash_hand_over': cashHandOver,
      'no_of_cheque_deposited': noOfChequeDeposited,
      'cheque_deposited_amount': chequeDepositedAmount,
      'no_of_cheque_hand_over': noOfChequeHandOver,
      'cheque_hand_over_amount': chequeHandOverAmount,
      'balance_cash_in_hand': balanceCashInHand,
      'no_of_cheque_in_hand': noOfChequeInHand,
      'cheque_amount_in_hand': chequeAmountInHand,
      'approvel': approval,
      'invoice_no': invoiceNo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
class Sale {
  int? customerId;
  String? invoiceNo;
  num? grandTotal; // Changed from int? to num?
  List<Customer>? customer;

  Sale({
    this.customerId,
    this.invoiceNo,
    this.grandTotal,
    this.customer,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      customerId: json['customer_id'],
      invoiceNo: json['invoice_no'],
      grandTotal: json['grand_total'],
      customer: json['customer'] != null
          ? List<Customer>.from(json['customer'].map((x) => Customer.fromJson(x)))
          : [],
    );
  }
}

class SaleReturn {
  int? customerId;
  String? invoiceNo;
  num? grandTotal; // Changed from int? to num?
  List<Customer>? customer;

  SaleReturn({
    this.customerId,
    this.invoiceNo,
    this.grandTotal,
    this.customer,
  });

  factory SaleReturn.fromJson(Map<String, dynamic> json) {
    return SaleReturn(
      customerId: json['customer_id'],
      invoiceNo: json['invoice_no'],
      grandTotal: json['grand_total'],
      customer: json['customer'] != null
          ? List<Customer>.from(json['customer'].map((x) => Customer.fromJson(x)))
          : [],
    );
  }
}

class Customer {
  int? id;
  String? name;
  String? contactNumber;
  String? whatsappNumber;
  String? email;

  Customer({
    this.id,
    this.name,
    this.contactNumber,
    this.whatsappNumber,
    this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contact_number'],
      whatsappNumber: json['whatsapp_number'],
      email: json['email'],
    );
  }
}
