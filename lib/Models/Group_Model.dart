import 'TestMos.dart';

class SaleReturnCollection {
  final SaleReturn? returnData;
  final Sale? sales;  // Make sales nullable
  final Collection? collection; // Make collection nullable

  SaleReturnCollection({
    this.returnData,
    this.sales, // Nullable property
    this.collection, // Nullable property
  });

  factory SaleReturnCollection.fromJson(Map<String, dynamic> json) {
    // Check if 'sales' is present before parsing it
    Sale? parsedSales;
    if (json['sales'] != null) {
      parsedSales = Sale.fromJson(json['sales']);
    }

    // Check if 'collection' is present before parsing it
    Collection? parsedCollection;
    if (json['collection'] != null) {
      parsedCollection = Collection.fromJson(json['collection']);
    }

    return SaleReturnCollection(
      returnData: json['return'] != null ? SaleReturn.fromJson(json['return']) : null,
      sales: parsedSales, // Only assign if parsedSales is not null
      collection: parsedCollection, // Only assign if parsedCollection is not null
    );
  }
}



class SaleReturn {
  final int id;
  final int customerId;
  final String billMode;
  final String inDate;
  final String inTime;
  final String invoiceNo;
  final double total;
  final double grandTotal;
  final double discount;
  final double totalTax;
  final List<Detail> detail;
  final Customer? customer; // Nullable to handle null response
  final Store? store;       // Nullable to handle null response
  final Van? van;
  final User? user;

  SaleReturn({
    required this.id,
    required this.customerId,
    required this.billMode,
    required this.inDate,
    required this.inTime,
    required this.invoiceNo,
    required this.total,
    required this.grandTotal,
    required this.discount,
    required this.totalTax,
    required this.detail,
    this.customer, // Nullable field
    this.store,    // Nullable field
    this.van,
    this.user,
  });

  factory SaleReturn.fromJson(Map<String, dynamic> json) {
    // Safely handle the 'detail' field
    var detailList = (json['detail'] as List?)?.map((item) => Detail.fromJson(item)).toList() ?? [];

    return SaleReturn(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      billMode: json['bill_mode'] ?? '',
      inDate: json['in_date'] ?? '',
      inTime: json['in_time'] ?? '',
      invoiceNo: json['invoice_no'] ?? '',
      total: (json['total'] ?? 0.0).toDouble(),
      grandTotal: (json['grand_total'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      totalTax: (json['total_tax'] ?? 0.0).toDouble(),
      detail: detailList,
      customer: json['customer'] != null && json['customer'].isNotEmpty
          ? Customer.fromJson(json['customer'][0])
          : null,
      store: json['store'] != null && json['store'].isNotEmpty
          ? Store.fromJson(json['store'][0])
          : null,
      van: json['van'] != null && json['van'].isNotEmpty
          ? Van.fromJson(json['van'][0])
          : null,
      user: json['user'] != null && json['user'].isNotEmpty
          ? User.fromJson(json['user'][0])
          : null,
    );
  }
}


class Detail {
  final int id;
  final int goodsOutId;
  final int itemId;
  final String productType;
  final String unit;
  final double quantity;
  final double taxable; // Added field
  final double taxAmt;
  final double mrp; // Added field
  final double amount;
  final String name;
  final String proImage;

  Detail({
    required this.id,
    required this.goodsOutId,
    required this.itemId,
    required this.productType,
    required this.unit,
    required this.quantity,
    required this.taxable, // Added field
    required this.taxAmt,
    required this.mrp, // Added field
    required this.amount,
    required this.name,
    required this.proImage,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      id: json['id'],
      goodsOutId: json['goods_out_id'],
      itemId: json['item_id'],
      productType: json['product_type'],
      unit: json['unit'],
      quantity: json['quantity'].toDouble(),
      taxable: json['taxable'].toDouble(), // Map taxable
      taxAmt: json['tax_amt'].toDouble(),
      mrp: json['mrp'].toDouble(), // Map mrp
      amount: json['amount'].toDouble(),
      name: json['name'],
      proImage: json['pro_image'],
    );
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

class Store {
  int? id;
  String? code;
  String? name;
  int? comapnyId;
  String? logo;
  String? address;
  String? emirate;
  String? country;
  String? contactNumber;
  String? whatsappNumber;
  String? email;
  String? username;
  String? password;
  int? noOfUsers;
  String? suscriptionEndDate;
  dynamic bufferDays;
  String? description;
  String? currency;
  num? vatPercentage;
  String? trn;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Store(
      {this.id,
      this.code,
      this.name,
      this.comapnyId,
      this.logo,
      this.address,
      this.emirate,
      this.country,
      this.contactNumber,
      this.whatsappNumber,
      this.email,
      this.username,
      this.password,
      this.noOfUsers,
      this.suscriptionEndDate,
      this.bufferDays,
      this.description,
      this.currency,
      this.vatPercentage,
      this.trn,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    comapnyId = json['comapny_id'];
    logo = json['logo'];
    address = json['address'];
    emirate = json['emirate'];
    country = json['country'];
    contactNumber = json['contact_number'];
    whatsappNumber = json['whatsapp_number'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    noOfUsers = json['no_of_users'];
    suscriptionEndDate = json['suscription_end_date'];
    bufferDays = json['buffer_days'];
    description = json['description'];
    currency = json['currency'];
    vatPercentage = json['vat_percentage'];
    trn = json['trn'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['comapny_id'] = this.comapnyId;
    data['logo'] = this.logo;
    data['address'] = this.address;
    data['emirate'] = this.emirate;
    data['country'] = this.country;
    data['contact_number'] = this.contactNumber;
    data['whatsapp_number'] = this.whatsappNumber;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['no_of_users'] = this.noOfUsers;
    data['suscription_end_date'] = this.suscriptionEndDate;
    data['buffer_days'] = this.bufferDays;
    data['description'] = this.description;
    data['currency'] = this.currency;
    data['vat_percentage'] = this.vatPercentage;
    data['trn'] = this.trn;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Van {
  final int id;
  final String name;

  Van({
    required this.id,
    required this.name,
  });

  factory Van.fromJson(Map<String, dynamic> json) {
    return Van(
      id: json['id'],
      name: json['name'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class Sale {
  final int id;
  final int customerId;
  final String billMode;
  final String inDate;
  final String inTime;
  final double totalTax;
  final String invoiceNo;
  final double total;
  final double grandTotal;
  final List<Detail> detail;
  final Store? store;
  final Customer? customer;
  final Van? van;
  final User? user;

  Sale({
    required this.id,
    required this.customerId,
    required this.billMode,
    required this.inDate,
    required this.inTime,
    required this.totalTax,
    required this.invoiceNo,
    required this.total,
    required this.grandTotal,
    required this.detail,
    this.store,
    this.customer,
    this.van,
    this.user,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    var detailList =
    (json['detail'] as List).map((item) => Detail.fromJson(item)).toList();
    return Sale(
      id: json['id'],
      customerId: json['customer_id'],
      billMode: json['bill_mode'],
      inDate: json['in_date'],
      inTime: json['in_time'],
      totalTax: json['total_tax'].toDouble(),
      invoiceNo: json['invoice_no'],
      total: json['total'].toDouble(),
      grandTotal: json['grand_total'].toDouble(),
      detail: detailList,
      store: json['store'] != null && json['store'].isNotEmpty
          ? Store.fromJson(json['store'][0])
          : null,
      customer: json['customer'] != null && json['customer'].isNotEmpty
          ? Customer.fromJson(json['customer'][0])
          : null,
      van: json['van'] != null && json['van'].isNotEmpty
          ? Van.fromJson(json['van'][0])
          : null,
      user: json['user'] != null && json['user'].isNotEmpty
          ? User.fromJson(json['user'][0])
          : null,
    );
  }
}


class Collection {
  Collection({
    int? id,
    int? customerId,
    String? inDate,
    String? inTime,
    String? collectionType,
    String? bank,
    String? chequeDate,
    String? chequeNo,
    String? voucherNo,
    String? totalAmount,
    int? vanId,
    int? userId,
    int? storeId,
    int? dayClose,
    int? dayCloseId,
    String? roundOff,
    int? status,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    List<Sales>? sales,
    List<Customer>? customer,
    List<Van>? van,
    List<User>? user,}){
    _id = id;
    _customerId = customerId;
    _inDate = inDate;
    _inTime = inTime;
    _collectionType = collectionType;
    _bank = bank;
    _chequeDate = chequeDate;
    _chequeNo = chequeNo;
    _voucherNo = voucherNo;
    _totalAmount = totalAmount;
    _vanId = vanId;
    _userId = userId;
    _storeId = storeId;
    _dayClose = dayClose;
    _dayCloseId = dayCloseId;
    _roundOff = roundOff;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _sales = sales;
    _customer = customer;
    _van = van;
    _user = user;
  }

  Collection.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _inDate = json['in_date'];
    _inTime = json['in_time'];
    _collectionType = json['collection_type'];
    _bank = json['bank'];
    _chequeDate = json['cheque_date'];
    _chequeNo = json['cheque_no'];
    _voucherNo = json['voucher_no'];
    _totalAmount = json['total_amount'];
    _vanId = json['van_id'];
    _userId = json['user_id'];
    _storeId = json['store_id'];
    _dayClose = json['day_close'];
    _dayCloseId = json['day_close_id'];
    _roundOff = json['round_off'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    if (json['sales'] != null) {
      _sales = [];
      json['sales'].forEach((v) {
        _sales?.add(Sales.fromJson(v));
      });
    }
    if (json['customer'] != null) {
      _customer = [];
      json['customer'].forEach((v) {
        _customer?.add(Customer.fromJson(v));
      });
    }
    if (json['van'] != null) {
      _van = [];
      json['van'].forEach((v) {
        _van?.add(Van.fromJson(v));
      });
    }
    if (json['user'] != null) {
      _user = [];
      json['user'].forEach((v) {
        _user?.add(User.fromJson(v));
      });
    }
  }
  int? _id;
  int? _customerId;
  String? _inDate;
  String? _inTime;
  String? _collectionType;
  String? _bank;
  String? _chequeDate;
  String? _chequeNo;
  String? _voucherNo;
  String? _totalAmount;
  int? _vanId;
  int? _userId;
  int? _storeId;
  int? _dayClose;
  int? _dayCloseId;
  String? _roundOff;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  List<Sales>? _sales;
  List<Customer>? _customer;
  List<Van>? _van;
  List<User>? _user;
  Collection copyWith({  int? id,
    int? customerId,
    String? inDate,
    String? inTime,
    String? collectionType,
    String? bank,
    String? chequeDate,
    String? chequeNo,
    String? voucherNo,
    String? totalAmount,
    int? vanId,
    int? userId,
    int? storeId,
    int? dayClose,
    int? dayCloseId,
    String? roundOff,
    int? status,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    List<Sales>? sales,
    List<Customer>? customer,
    List<Van>? van,
    List<User>? user,
  }) => Collection(  id: id ?? _id,
    customerId: customerId ?? _customerId,
    inDate: inDate ?? _inDate,
    inTime: inTime ?? _inTime,
    collectionType: collectionType ?? _collectionType,
    bank: bank ?? _bank,
    chequeDate: chequeDate ?? _chequeDate,
    chequeNo: chequeNo ?? _chequeNo,
    voucherNo: voucherNo ?? _voucherNo,
    totalAmount: totalAmount ?? _totalAmount,
    vanId: vanId ?? _vanId,
    userId: userId ?? _userId,
    storeId: storeId ?? _storeId,
    dayClose: dayClose ?? _dayClose,
    dayCloseId: dayCloseId ?? _dayCloseId,
    roundOff: roundOff ?? _roundOff,
    status: status ?? _status,
    createdAt: createdAt ?? _createdAt,
    updatedAt: updatedAt ?? _updatedAt,
    deletedAt: deletedAt ?? _deletedAt,
    sales: sales ?? _sales,
    customer: customer ?? _customer,
    van: van ?? _van,
    user: user ?? _user,
  );
  int? get id => _id;
  int? get customerId => _customerId;
  String? get inDate => _inDate;
  String? get inTime => _inTime;
  String? get collectionType => _collectionType;
  String? get bank => _bank;
  String? get chequeDate => _chequeDate;
  String? get chequeNo => _chequeNo;
  String? get voucherNo => _voucherNo;
  String? get totalAmount => _totalAmount;
  int? get vanId => _vanId;
  int? get userId => _userId;
  int? get storeId => _storeId;
  int? get dayClose => _dayClose;
  int? get dayCloseId => _dayCloseId;
  String? get roundOff => _roundOff;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  List<Sales>? get sales => _sales;
  List<Customer>? get customer => _customer;
  List<Van>? get van => _van;
  List<User>? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['in_date'] = _inDate;
    map['in_time'] = _inTime;
    map['collection_type'] = _collectionType;
    map['bank'] = _bank;
    map['cheque_date'] = _chequeDate;
    map['cheque_no'] = _chequeNo;
    map['voucher_no'] = _voucherNo;
    map['total_amount'] = _totalAmount;
    map['van_id'] = _vanId;
    map['user_id'] = _userId;
    map['store_id'] = _storeId;
    map['day_close'] = _dayClose;
    map['day_close_id'] = _dayCloseId;
    map['round_off'] = _roundOff;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    if (_sales != null) {
      map['sales'] = _sales?.map((v) => v?.toJson()).toList();
    }
    if (_customer != null) {
      map['customer'] = _customer?.map((v) => v.toJson()).toList();
    }
    // if (_van != null) {
    //   map['van'] = _van?.map((v) => v.toJson()).toList();
    // }
    // if (_user != null) {
    //   map['user'] = _user?.map((v) => v.toJson()).toList();
    // }
    return map;
  }
}


