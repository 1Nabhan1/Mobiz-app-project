class CustomerVisit {
  int id;
  String inDate;
  String inTime;
  String? visitType; // Nullable field
  int reasonId;
  String? description; // Nullable field
  int storeId;
  String createdAt;
  String updatedAt;
  String? deletedAt; // Nullable field
  List<Reason> reason;
  List<Customer> customer;

  CustomerVisit({
    required this.id,
    required this.inDate,
    required this.inTime,
    this.visitType,
    required this.reasonId,
    this.description,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.reason,
    required this.customer,
  });

  factory CustomerVisit.fromJson(Map<String, dynamic> json) {
    return CustomerVisit(
      id: json['id'],
      inDate: json['in_date'],
      inTime: json['in_time'],
      visitType: json['vistit_type'], // Corrected key here
      reasonId: json['reason_id'],
      description: json['description'],
      storeId: json['store_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      reason: List<Reason>.from(json['reason'].map((x) => Reason.fromJson(x))),
      customer: List<Customer>.from(json['customer'].map((x) => Customer.fromJson(x))),
    );
  }
}

class Reason {
  int id;
  String visitType;
  String reason;
  String? description;
  int storeId;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  Reason({
    required this.id,
    required this.visitType,
    required this.reason,
    this.description,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      id: json['id'],
      visitType: json['vistit_type'],
      reason: json['reasone'],
      description: json['description'],
      storeId: json['store_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

class Customer {
  int id;
  String name;
  String? code;
  String address;
  String contactNumber;
  String whatsappNumber;
  String email;
  String? trn;
  String? custImage;
  String paymentTerms;
  int creditLimit;
  int creditDays;
  String? location;
  int routeId;
  int provinceId;
  int storeId;
  int status;
  String createdAt;
  String updatedAt;
  String? deletedAt;
  String? erpCustomerCode;

  Customer({
    required this.id,
    required this.name,
    this.code,
    required this.address,
    required this.contactNumber,
    required this.whatsappNumber,
    required this.email,
    this.trn,
    this.custImage,
    required this.paymentTerms,
    required this.creditLimit,
    required this.creditDays,
    this.location,
    required this.routeId,
    required this.provinceId,
    required this.storeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.erpCustomerCode,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      address: json['address'],
      contactNumber: json['contact_number'],
      whatsappNumber: json['whatsapp_number'],
      email: json['email'],
      trn: json['trn'],
      custImage: json['cust_image'],
      paymentTerms: json['payment_terms'],
      creditLimit: json['credit_limit'],
      creditDays: json['credit_days'],
      location: json['location'],
      routeId: json['route_id'],
      provinceId: json['province_id'],
      storeId: json['store_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      erpCustomerCode: json['erp_customer_code'],
    );
  }
}