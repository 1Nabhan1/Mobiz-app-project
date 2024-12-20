class RequestModel {
  List<Data>? data;
  bool? success;
  List<String>? messages;

  RequestModel({this.data, this.success, this.messages});

  RequestModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
    messages = json['messages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['messages'] = this.messages;
    return data;
  }
}

class Data {
  int? id;
  int? vanId;
  int? userId;
  String? inDate;
  String? inTime;
  String? invoiceNo;
  String? approvedDate;
  String? approvedTime;
  int? approvedUser;
  int? storeId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Detail>? detail;

  Data(
      {this.id,
      this.vanId,
      this.userId,
      this.inDate,
      this.inTime,
      this.invoiceNo,
      this.approvedDate,
      this.approvedTime,
      this.approvedUser,
      this.storeId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.detail});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vanId = json['van_id'];
    userId = json['user_id'];
    inDate = json['in_date'];
    inTime = json['in_time'];
    invoiceNo = json['invoice_no'];
    approvedDate = json['approved_date'];
    approvedTime = json['approved_time'];
    approvedUser = json['approved_user'];
    storeId = json['store_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(new Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['van_id'] = this.vanId;
    data['user_id'] = this.userId;
    data['in_date'] = this.inDate;
    data['in_time'] = this.inTime;
    data['invoice_no'] = this.invoiceNo;
    data['approved_date'] = this.approvedDate;
    data['approved_time'] = this.approvedTime;
    data['approved_user'] = this.approvedUser;
    data['store_id'] = this.storeId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  int? id;
  int? vanRequestId;
  int? itemId;
  String? unit;
  String? product_type;
  String? name;
  double? quantity;
  int? editedQuantity;
  String? approvedQuantity;
  int? convertQty;
  int? vanId;
  int? userId;
  int? storeId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? productId;
  String? productName;
  String? productCode;

  Detail(
      {this.id,
      this.vanRequestId,
      this.product_type,
      this.name,
      this.itemId,
      this.unit,
      this.quantity,
      this.editedQuantity,
      this.approvedQuantity,
      this.convertQty,
      this.vanId,
      this.userId,
      this.storeId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.productId,
      this.productCode,
      this.productName});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vanRequestId = json['van_request_id'];
    product_type = json['product_type'];
    name = json['name'];
    itemId = json['item_id'];
    unit = json['unit'];
    quantity = (json['quantity'] as num?)?.toDouble();
    approvedQuantity = json['approved_quantity'];
    convertQty = json['convert_qty'];
    vanId = json['van_id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    productId = json['product_id'];
    productName = json['product_name'];
    productCode = json['product_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['van_request_id'] = this.vanRequestId;
    data['item_id'] = this.itemId;
    data['unit'] = this.unit;
    data['quantity'] = this.quantity;
    data['approved_quantity'] = this.approvedQuantity;
    data['convert_qty'] = this.convertQty;
    data['van_id'] = this.vanId;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_code'] = this.productCode;
    return data;
  }
}
