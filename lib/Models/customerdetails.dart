class CustomerData {
  List<Data>? data;
  bool? success;
  List<String>? messages;

  CustomerData({this.data, this.success, this.messages});

  CustomerData.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? code;
  String? address;
  String? contactNumber;
  String? whatsappNumber;
  String? email;
  String? trn;
  String? img;
  String? location;
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
  int? pricegroupId;
  String? visit;
  String? building;
  String? flatNo;
  int? defaultValue; // Non-nullable field

  // Constructor with required initializer for defaultValue
  Data({
    this.id,
    this.name,
    this.code,
    this.address,
    this.contactNumber,
    this.whatsappNumber,
    this.email,
    this.trn,
    this.img,
    this.location,
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
    this.erpCustomerCode,
    this.pricegroupId,
    this.visit,
    this.building,
    this.flatNo,
    this.defaultValue = 0, // Default value assigned
  });

  // Factory method to create an instance from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      address: json['address'],
      contactNumber: json['contact_number'],
      whatsappNumber: json['whatsapp_number'],
      email: json['email'],
      location: json['location'],
      trn: json['trn'],
      img: json['cust_image'],
      paymentTerms: json['payment_terms'],
      creditLimit: json['credit_limit'],
      creditDays: json['credit_days'],
      routeId: json['route_id'],
      provinceId: json['province_id'],
      storeId: json['store_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      erpCustomerCode: json['erp_customer_code'],
      pricegroupId: json['price_group_id'],
      visit: json['visit'],
      building: json['Building'],
      flatNo: json['Flat_no'],
        defaultValue : json['default_value'] != null ? json['default_value'] : 0,
      // Default value fallback
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['address'] = address;
    data['contact_number'] = contactNumber;
    data['whatsapp_number'] = whatsappNumber;
    data['email'] = email;
    data['location'] = location;
    data['trn'] = trn;
    data['cust_image'] = img;
    data['payment_terms'] = paymentTerms;
    data['credit_limit'] = creditLimit;
    data['credit_days'] = creditDays;
    data['route_id'] = routeId;
    data['province_id'] = provinceId;
    data['store_id'] = storeId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['erp_customer_code'] = erpCustomerCode;
    data['price_group_id'] = pricegroupId;
    data['visit'] = visit;
    data['Building'] = building;
    data['Flat_no'] = flatNo;
    data['default_value'] = defaultValue;
    return data;
  }
}

