class CustomerVisit {
  final int id;
  final String inDate;
  final String inTime;
  final String visitType;
  final int reasonId;
  final String description;
  final int storeId;
  final int vanId;
  final int userId;
  final int customerId;
  final int dayClose;
  final int dayCloseId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final List<Reason> reason;
  final List<Customer> customer;

  CustomerVisit({
    required this.id,
    required this.inDate,
    required this.inTime,
    required this.visitType,
    required this.reasonId,
    required this.description,
    required this.storeId,
    required this.vanId,
    required this.userId,
    required this.customerId,
    required this.dayClose,
    required this.dayCloseId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.reason,
    required this.customer,
  });

  factory CustomerVisit.fromJson(Map<String, dynamic> json) {
    return CustomerVisit(
      id: json['id'],
      inDate: json['in_date'] ?? '', // Handle null with default value
      inTime: json['in_time'] ?? '', // Handle null with default value
      visitType: json['vistit_type'] ?? '', // Handle null with default value
      reasonId: json['reason_id'],
      description: json['description'] ?? '', // Default empty string for null values
      storeId: json['store_id'],
      vanId: json['van_id'],
      userId: json['user_id'],
      customerId: json['customer_id'],
      dayClose: json['day_close'],
      dayCloseId: json['day_close_id'],
      createdAt: json['created_at'] ?? '', // Handle null with default value
      updatedAt: json['updated_at'] ?? '', // Handle null with default value
      deletedAt: json['deleted_at'],
      reason: List<Reason>.from(json['reason'].map((x) => Reason.fromJson(x))),
      customer: List<Customer>.from(json['customer'].map((x) => Customer.fromJson(x))),
    );
  }
}
class Reason {
  final int id;
  final String visitType;
  final String reason;
  final String? description;
  final int storeId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

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
      visitType: json['vistit_type'] ?? '', // Handle null with default value
      reason: json['reasone'] ?? '', // Handle null with default value
      description: json['description'],
      storeId: json['store_id'],
      createdAt: json['created_at'] ?? '', // Handle null with default value
      updatedAt: json['updated_at'] ?? '', // Handle null with default value
      deletedAt: json['deleted_at'],
    );
  }
}
class Customer {
  final int id;
  final String name;
  final String? code;
  final String address;
  final String? building;
  final String? flatNo;
  final String contactNumber;
  final String whatsappNumber;
  final String email;
  final String trn;
  final String? custImage;
  final String paymentTerms;
  final int creditLimit;
  final int creditDays;
  final String location; // Still treated as String since it includes coordinates
  final int routeId;
  final int provinceId;
  final int storeId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String? erpCustomerCode;
  final int priceGroupId;

  Customer({
    required this.id,
    required this.name,
    this.code,
    required this.address,
    this.building,
    this.flatNo,
    required this.contactNumber,
    required this.whatsappNumber,
    required this.email,
    required this.trn,
    this.custImage,
    required this.paymentTerms,
    required this.creditLimit,
    required this.creditDays,
    required this.location,
    required this.routeId,
    required this.provinceId,
    required this.storeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.erpCustomerCode,
    required this.priceGroupId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'] ?? '', // Default empty string if null
      code: json['code'],
      address: json['address'] ?? '', // Default empty string if null
      building: json['Building'],
      flatNo: json['Flat_no'],
      contactNumber: json['contact_number'] ?? '', // Default empty string if null
      whatsappNumber: json['whatsapp_number'] ?? '', // Default empty string if null
      email: json['email'] ?? '', // Default empty string if null
      trn: json['trn'] ?? '', // Default empty string if null
      custImage: json['cust_image'],
      paymentTerms: json['payment_terms'] ?? '', // Default empty string if null
      creditLimit: json['credit_limit'],
      creditDays: json['credit_days'],
      location: json['location'] ?? '', // Default empty string if null
      routeId: json['route_id'],
      provinceId: json['province_id'],
      storeId: json['store_id'],
      status: json['status'],
      createdAt: json['created_at'] ?? '', // Default empty string if null
      updatedAt: json['updated_at'] ?? '', // Default empty string if null
      deletedAt: json['deleted_at'],
      erpCustomerCode: json['erp_customer_code'],
      priceGroupId: json['price_group_id'],
    );
  }
}
