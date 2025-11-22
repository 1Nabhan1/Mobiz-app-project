
class StockResponse {
  bool? success;
  List<String>? messages;
  List<StockData>? data;

  StockResponse({
    this.success,
    this.messages,
    this.data,
  });

  StockResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messages = List<String>.from(json['messages']);
    if (json['data'] != null) {
      data = <StockData>[];
      json['data'].forEach((v) {
        data!.add(StockData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['messages'] = messages;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}



class StockData {
  final int id;
  final int vanId;
  final int userId;
  final String inDate;
  final String inTime;
  final String invoiceNo;
  final String? approvedDate;
  final String? approvedTime;
  final int approvedUser;
  final int storeId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final List<StockDetail> detail;

  StockData({
    required this.id,
    required this.vanId,
    required this.userId,
    required this.inDate,
    required this.inTime,
    required this.invoiceNo,
    this.approvedDate,
    this.approvedTime,
    required this.approvedUser,
    required this.storeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.detail,
  });

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      id: json['id'],
      vanId: json['van_id'],
      userId: json['user_id'],
      inDate: json['in_date'],
      inTime: json['in_time'],
      invoiceNo: json['invoice_no'],
      approvedDate: json['approved_date'],
      approvedTime: json['approved_time'],
      approvedUser: json['approved_user'],
      storeId: json['store_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      detail: List<StockDetail>.from(
          json['detail'].map((x) => StockDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'van_id': vanId,
      'user_id': userId,
      'in_date': inDate,
      'in_time': inTime,
      'invoice_no': invoiceNo,
      'approved_date': approvedDate,
      'approved_time': approvedTime,
      'approved_user': approvedUser,
      'store_id': storeId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'detail': detail.map((x) => x.toJson()).toList(),
    };
  }
}

class StockDetail {
  final int id;
  final int stockTakeId;
  final String? productType;
  final int itemId;
  final String unit;
  final int quantity;
  final String approvedQuantity;
  final int convertQty;
  final int vanId;
  final int userId;
  final int storeId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int productId;
  final String productName;
  final String productCode;

  StockDetail({
    required this.id,
    required this.stockTakeId,
    this.productType,
    required this.itemId,
    required this.unit,
    required this.quantity,
    required this.approvedQuantity,
    required this.convertQty,
    required this.vanId,
    required this.userId,
    required this.storeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.productId,
    required this.productName,
    required this.productCode,
  });

  factory StockDetail.fromJson(Map<String, dynamic> json) {
    return StockDetail(
      id: json['id'],
      stockTakeId: json['stock_take_id'],
      productType: json['product_type'],
      itemId: json['item_id'],
      unit: json['unit'],
      quantity: (json['quantity'] is int)
          ? json['quantity']
          : (json['quantity'] as double).toInt(),
      approvedQuantity: json['approved_quantity'],
      convertQty: json['convert_qty'],
      vanId: json['van_id'],
      userId: json['user_id'],
      storeId: json['store_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      productId: json['product_id'],
      productName: json['product_name'],
      productCode: json['product_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock_take_id': stockTakeId,
      'product_type': productType,
      'item_id': itemId,
      'unit': unit,
      'quantity': quantity,
      'approved_quantity': approvedQuantity,
      'convert_qty': convertQty,
      'van_id': vanId,
      'user_id': userId,
      'store_id': storeId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'product_id': productId,
      'product_name': productName,
      'product_code': productCode,
    };
  }
}