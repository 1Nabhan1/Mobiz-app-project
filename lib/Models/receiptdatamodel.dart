class ReceiptsData {
  List<Data>? data;
  bool? success;

  ReceiptsData({this.data, this.success});

  ReceiptsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  int? id;
  int? masterId;
  int? customerId;
  int? goodsOutId;
  String? amount;
  String? inDate;
  String? inTime;
  String? collectionType;
  String? bank;
  String? chequeDate;
  String? chequeNo;
  String? voucherNo;
  int? userId;
  int? vanId;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Customer>? customer;

  Data(
      {this.id,
      this.masterId,
      this.customerId,
      this.goodsOutId,
      this.amount,
      this.inDate,
      this.inTime,
      this.collectionType,
      this.bank,
      this.chequeDate,
      this.chequeNo,
      this.voucherNo,
      this.userId,
      this.vanId,
      this.storeId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    masterId = json['master_id'];
    customerId = json['customer_id'];
    goodsOutId = json['goods_out_id'];
    amount = json['total_amount'];
    inDate = json['in_date'];
    inTime = json['in_time'];
    collectionType = json['collection_type'];
    bank = json['bank'];
    chequeDate = json['cheque_date'];
    chequeNo = json['cheque_no'];
    voucherNo = json['voucher_no'];
    userId = json['user_id'];
    vanId = json['van_id'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['customer'] != null) {
      customer = <Customer>[];
      json['customer'].forEach((v) {
        customer!.add(new Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['master_id'] = this.masterId;
    data['customer_id'] = this.customerId;
    data['goods_out_id'] = this.goodsOutId;
    data['amount'] = this.amount;
    data['in_date'] = this.inDate;
    data['in_time'] = this.inTime;
    data['collection_type'] = this.collectionType;
    data['bank'] = this.bank;
    data['cheque_date'] = this.chequeDate;
    data['cheque_no'] = this.chequeNo;
    data['voucher_no'] = this.voucherNo;
    data['user_id'] = this.userId;
    data['van_id'] = this.vanId;
    data['store_id'] = this.storeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.customer != null) {
      data['customer'] = this.customer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  String? code;
  String? address;
  String? contactNumber;
  String? whatsappNumber;
  String? email;
  String? trn;
  String? custImage;
  String? paymentTerms;
  int? creditLimit;
  int? creditDays;
  int? routeId;
  int? provinceId;
  int? storeId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? erpCustomerCode;

  Customer(
      {this.id,
      this.name,
      this.code,
      this.address,
      this.contactNumber,
      this.whatsappNumber,
      this.email,
      this.trn,
      this.custImage,
      this.paymentTerms,
      this.creditLimit,
      this.creditDays,
      this.routeId,
      this.provinceId,
      this.storeId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.erpCustomerCode});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    address = json['address'];
    contactNumber = json['contact_number'];
    whatsappNumber = json['whatsapp_number'];
    email = json['email'];
    trn = json['trn'];
    custImage = json['cust_image'];
    paymentTerms = json['payment_terms'];
    creditLimit = json['credit_limit'];
    creditDays = json['credit_days'];
    routeId = json['route_id'];
    provinceId = json['province_id'];
    storeId = json['store_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    erpCustomerCode = json['erp_customer_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['address'] = this.address;
    data['contact_number'] = this.contactNumber;
    data['whatsapp_number'] = this.whatsappNumber;
    data['email'] = this.email;
    data['trn'] = this.trn;
    data['cust_image'] = this.custImage;
    data['payment_terms'] = this.paymentTerms;
    data['credit_limit'] = this.creditLimit;
    data['credit_days'] = this.creditDays;
    data['route_id'] = this.routeId;
    data['province_id'] = this.provinceId;
    data['store_id'] = this.storeId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['erp_customer_code'] = this.erpCustomerCode;
    return data;
  }
}