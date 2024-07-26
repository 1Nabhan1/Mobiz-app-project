//
//
// import 'dart:convert';
//
// /// id : 3
// /// customer_id : 10
// /// bill_mode : null
// /// in_date : "2024-06-18"
// /// in_time : "07:31:38"
// /// invoice_no : "SO0002"
// /// delivery_no : null
// /// other_charge : 0
// /// discount : 0
// /// round_off : "0.000"
// /// total : 0
// /// total_tax : 0
// /// grand_total : 0
// /// receipt : 0
// /// balance : 0
// /// order_type : 1
// /// if_vat : 1
// /// van_id : 1
// /// user_id : 7
// /// store_id : 5
// /// status : 1
// /// created_at : "2024-06-17T20:00:00.000000Z"
// /// updated_at : "2024-06-17T20:00:00.000000Z"
// /// deleted_at : null
// /// store : [{"id":5,"code":"CO0001","name":"Al Raidhan","comapny_id":1,"logo":"defalut.jpg","address":null,"emirate":"1","country":"UAE","contact_number":"7894561236","whatsapp_number":null,"email":"al@gmail.com","username":"al@gmail.com","password":"12345678","no_of_users":5,"suscription_end_date":"2024-05-25","buffer_days":null,"description":null,"currency":null,"vat_percentage":null,"trn":null,"status":1,"created_at":"2024-05-22T00:08:05.000000Z","updated_at":"2024-05-22T00:08:05.000000Z","deleted_at":null}]
// /// detail : [{"id":1,"goods_out_id":3,"item_id":1,"product_type":"Normal","unit":"unit no 1","convert_qty":0,"quantity":100,"rate":0,"prodiscount":0,"taxable":12000,"tax_amt":240,"mrp":120,"amount":12240,"van_id":1,"user_id":7,"store_id":0,"status":1,"created_at":"2024-05-14T07:43:32.000000Z","updated_at":"2024-05-14T07:43:32.000000Z","deleted_at":null,"code":null,"name":"isra Bootile","pro_image":"defalut.jpg","category_id":2,"sub_category_id":5,"brand_id":0,"supplier_id":0,"tax_id":1,"tax_percentage":2,"tax_inclusive":1,"price":100,"base_unit_id":1,"base_unit_qty":1,"base_unit_discount":"75.00","base_unit_barcode":null,"base_unit_op_stock":0,"second_unit_price":"500.00","second_unit_id":2,"second_unit_qty":10,"second_unit_discount":"400.00","second_unit_barcode":null,"second_unit_op_stock":"0.00","third_unit_price":"0.00","third_unit_id":0,"third_unit_qty":0,"third_unit_discount":"0.00","third_unit_barcode":null,"third_unit_op_stock":"0.00","fourth_unit_price":"0.00","fourth_unit_id":0,"fourth_unit_qty":1,"fourth_unit_discount":"0.00","is_multiple_unit":1,"fourth_unit_op_stock":"0.00","description":null,"product_qty":0,"percentage":2}]
// /// customer : [{"id":10,"name":"City Cialkot Gocery","code":"AR0003","address":"P.O Box . 23433","contact_number":"0523677776","whatsapp_number":null,"email":"citycialkot@gmail.com","trn":"10221989700999","cust_image":null,"payment_terms":"CASH","credit_limit":0,"credit_days":0,"route_id":7,"province_id":3,"store_id":7,"status":1,"created_at":"2024-05-22T22:23:42.000000Z","updated_at":"2024-05-22T22:23:42.000000Z","deleted_at":null,"erp_customer_code":null}]
// /// van : [{"id":1,"code":"a","name":"aa","description":null,"status":1,"store_id":2,"created_at":null,"updated_at":null,"deleted_at":null}]
// /// user : [{"id":7,"name":"Spanixo","email":"nixo@gmail.com","email_verified_at":null,"is_super_admin":null,"is_shop_admin":"1","is_staff":null,"department_id":0,"designation_id":0,"store_id":2,"rol_id":0,"created_at":"2024-05-15T00:27:35.000000Z","updated_at":"2024-05-15T00:27:35.000000Z"}]
//
// homeorder dataFromJson(String str) => homeorder.fromJson(json.decode(str));
// String dataToJson(homeorder data) => json.encode(data.toJson());
// class homeorder {
//   homeorder({
//       num? id,
//       num? customerId,
//       dynamic billMode,
//       String? inDate,
//       String? inTime,
//       String? invoiceNo,
//       dynamic deliveryNo,
//       num? otherCharge,
//       num? discount,
//       String? roundOff,
//       num? total,
//       num? totalTax,
//       num? grandTotal,
//       num? receipt,
//       num? balance,
//       num? orderType,
//       num? ifVat,
//       num? vanId,
//       num? userId,
//       num? storeId,
//       num? status,
//       String? createdAt,
//       String? updatedAt,
//       dynamic deletedAt,
//       List<Store>? store,
//       List<Detail>? detail,
//       List<Customer>? customer,
//       List<Van>? van,
//       List<User>? user,}){
//     _id = id;
//     _customerId = customerId;
//     _billMode = billMode;
//     _inDate = inDate;
//     _inTime = inTime;
//     _invoiceNo = invoiceNo;
//     _deliveryNo = deliveryNo;
//     _otherCharge = otherCharge;
//     _discount = discount;
//     _roundOff = roundOff;
//     _total = total;
//     _totalTax = totalTax;
//     _grandTotal = grandTotal;
//     _receipt = receipt;
//     _balance = balance;
//     _orderType = orderType;
//     _ifVat = ifVat;
//     _vanId = vanId;
//     _userId = userId;
//     _storeId = storeId;
//     _status = status;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _deletedAt = deletedAt;
//     _store = store;
//     _detail = detail;
//     _customer = customer;
//     _van = van;
//     _user = user;
// }
//
//   homeorder.fromJson(dynamic json) {
//     _id = json['id'];
//     _customerId = json['customer_id'];
//     _billMode = json['bill_mode'];
//     _inDate = json['in_date'];
//     _inTime = json['in_time'];
//     _invoiceNo = json['invoice_no'];
//     _deliveryNo = json['delivery_no'];
//     _otherCharge = json['other_charge'];
//     _discount = json['discount'];
//     _roundOff = json['round_off'];
//     _total = json['total'];
//     _totalTax = json['total_tax'];
//     _grandTotal = json['grand_total'];
//     _receipt = json['receipt'];
//     _balance = json['balance'];
//     _orderType = json['order_type'];
//     _ifVat = json['if_vat'];
//     _vanId = json['van_id'];
//     _userId = json['user_id'];
//     _storeId = json['store_id'];
//     _status = json['status'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//     if (json['store'] != null) {
//       _store = [];
//       json['store'].forEach((v) {
//         _store?.add(Store.fromJson(v));
//       });
//     }
//     if (json['detail'] != null) {
//       _detail = [];
//       json['detail'].forEach((v) {
//         _detail?.add(Detail.fromJson(v));
//       });
//     }
//     if (json['customer'] != null) {
//       _customer = [];
//       json['customer'].forEach((v) {
//         _customer?.add(Customer.fromJson(v));
//       });
//     }
//     if (json['van'] != null) {
//       _van = [];
//       json['van'].forEach((v) {
//         _van?.add(Van.fromJson(v));
//       });
//     }
//     if (json['user'] != null) {
//       _user = [];
//       json['user'].forEach((v) {
//         _user?.add(User.fromJson(v));
//       });
//     }
//   }
//   num? _id;
//   num? _customerId;
//   dynamic _billMode;
//   String? _inDate;
//   String? _inTime;
//   String? _invoiceNo;
//   dynamic _deliveryNo;
//   num? _otherCharge;
//   num? _discount;
//   String? _roundOff;
//   num? _total;
//   num? _totalTax;
//   num? _grandTotal;
//   num? _receipt;
//   num? _balance;
//   num? _orderType;
//   num? _ifVat;
//   num? _vanId;
//   num? _userId;
//   num? _storeId;
//   num? _status;
//   String? _createdAt;
//   String? _updatedAt;
//   dynamic _deletedAt;
//   List<Store>? _store;
//   List<Detail>? _detail;
//   List<Customer>? _customer;
//   List<Van>? _van;
//   List<User>? _user;
// homeorder copyWith({  num? id,
//   num? customerId,
//   dynamic billMode,
//   String? inDate,
//   String? inTime,
//   String? invoiceNo,
//   dynamic deliveryNo,
//   num? otherCharge,
//   num? discount,
//   String? roundOff,
//   num? total,
//   num? totalTax,
//   num? grandTotal,
//   num? receipt,
//   num? balance,
//   num? orderType,
//   num? ifVat,
//   num? vanId,
//   num? userId,
//   num? storeId,
//   num? status,
//   String? createdAt,
//   String? updatedAt,
//   dynamic deletedAt,
//   List<Store>? store,
//   List<Detail>? detail,
//   List<Customer>? customer,
//   List<Van>? van,
//   List<User>? user,
// }) => homeorder(  id: id ?? _id,
//   customerId: customerId ?? _customerId,
//   billMode: billMode ?? _billMode,
//   inDate: inDate ?? _inDate,
//   inTime: inTime ?? _inTime,
//   invoiceNo: invoiceNo ?? _invoiceNo,
//   deliveryNo: deliveryNo ?? _deliveryNo,
//   otherCharge: otherCharge ?? _otherCharge,
//   discount: discount ?? _discount,
//   roundOff: roundOff ?? _roundOff,
//   total: total ?? _total,
//   totalTax: totalTax ?? _totalTax,
//   grandTotal: grandTotal ?? _grandTotal,
//   receipt: receipt ?? _receipt,
//   balance: balance ?? _balance,
//   orderType: orderType ?? _orderType,
//   ifVat: ifVat ?? _ifVat,
//   vanId: vanId ?? _vanId,
//   userId: userId ?? _userId,
//   storeId: storeId ?? _storeId,
//   status: status ?? _status,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   deletedAt: deletedAt ?? _deletedAt,
//   store: store ?? _store,
//   detail: detail ?? _detail,
//   customer: customer ?? _customer,
//   van: van ?? _van,
//   user: user ?? _user,
// );
//   num? get id => _id;
//   num? get customerId => _customerId;
//   dynamic get billMode => _billMode;
//   String? get inDate => _inDate;
//   String? get inTime => _inTime;
//   String? get invoiceNo => _invoiceNo;
//   dynamic get deliveryNo => _deliveryNo;
//   num? get otherCharge => _otherCharge;
//   num? get discount => _discount;
//   String? get roundOff => _roundOff;
//   num? get total => _total;
//   num? get totalTax => _totalTax;
//   num? get grandTotal => _grandTotal;
//   num? get receipt => _receipt;
//   num? get balance => _balance;
//   num? get orderType => _orderType;
//   num? get ifVat => _ifVat;
//   num? get vanId => _vanId;
//   num? get userId => _userId;
//   num? get storeId => _storeId;
//   num? get status => _status;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   dynamic get deletedAt => _deletedAt;
//   List<Store>? get store => _store;
//   List<Detail>? get detail => _detail;
//   List<Customer>? get customer => _customer;
//   List<Van>? get van => _van;
//   List<User>? get user => _user;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['customer_id'] = _customerId;
//     map['bill_mode'] = _billMode;
//     map['in_date'] = _inDate;
//     map['in_time'] = _inTime;
//     map['invoice_no'] = _invoiceNo;
//     map['delivery_no'] = _deliveryNo;
//     map['other_charge'] = _otherCharge;
//     map['discount'] = _discount;
//     map['round_off'] = _roundOff;
//     map['total'] = _total;
//     map['total_tax'] = _totalTax;
//     map['grand_total'] = _grandTotal;
//     map['receipt'] = _receipt;
//     map['balance'] = _balance;
//     map['order_type'] = _orderType;
//     map['if_vat'] = _ifVat;
//     map['van_id'] = _vanId;
//     map['user_id'] = _userId;
//     map['store_id'] = _storeId;
//     map['status'] = _status;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['deleted_at'] = _deletedAt;
//     if (_store != null) {
//       map['store'] = _store?.map((v) => v.toJson()).toList();
//     }
//     if (_detail != null) {
//       map['detail'] = _detail?.map((v) => v.toJson()).toList();
//     }
//     if (_customer != null) {
//       map['customer'] = _customer?.map((v) => v.toJson()).toList();
//     }
//     if (_van != null) {
//       map['van'] = _van?.map((v) => v.toJson()).toList();
//     }
//     if (_user != null) {
//       map['user'] = _user?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// /// id : 7
// /// name : "Spanixo"
// /// email : "nixo@gmail.com"
// /// email_verified_at : null
// /// is_super_admin : null
// /// is_shop_admin : "1"
// /// is_staff : null
// /// department_id : 0
// /// designation_id : 0
// /// store_id : 2
// /// rol_id : 0
// /// created_at : "2024-05-15T00:27:35.000000Z"
// /// updated_at : "2024-05-15T00:27:35.000000Z"
//
// User userFromJson(String str) => User.fromJson(json.decode(str));
// String userToJson(User data) => json.encode(data.toJson());
// class User {
//   User({
//       num? id,
//       String? name,
//       String? email,
//       dynamic emailVerifiedAt,
//       dynamic isSuperAdmin,
//       String? isShopAdmin,
//       dynamic isStaff,
//       num? departmentId,
//       num? designationId,
//       num? storeId,
//       num? rolId,
//       String? createdAt,
//       String? updatedAt,}){
//     _id = id;
//     _name = name;
//     _email = email;
//     _emailVerifiedAt = emailVerifiedAt;
//     _isSuperAdmin = isSuperAdmin;
//     _isShopAdmin = isShopAdmin;
//     _isStaff = isStaff;
//     _departmentId = departmentId;
//     _designationId = designationId;
//     _storeId = storeId;
//     _rolId = rolId;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
// }
//
//   User.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _email = json['email'];
//     _emailVerifiedAt = json['email_verified_at'];
//     _isSuperAdmin = json['is_super_admin'];
//     _isShopAdmin = json['is_shop_admin'];
//     _isStaff = json['is_staff'];
//     _departmentId = json['department_id'];
//     _designationId = json['designation_id'];
//     _storeId = json['store_id'];
//     _rolId = json['rol_id'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   num? _id;
//   String? _name;
//   String? _email;
//   dynamic _emailVerifiedAt;
//   dynamic _isSuperAdmin;
//   String? _isShopAdmin;
//   dynamic _isStaff;
//   num? _departmentId;
//   num? _designationId;
//   num? _storeId;
//   num? _rolId;
//   String? _createdAt;
//   String? _updatedAt;
// User copyWith({  num? id,
//   String? name,
//   String? email,
//   dynamic emailVerifiedAt,
//   dynamic isSuperAdmin,
//   String? isShopAdmin,
//   dynamic isStaff,
//   num? departmentId,
//   num? designationId,
//   num? storeId,
//   num? rolId,
//   String? createdAt,
//   String? updatedAt,
// }) => User(  id: id ?? _id,
//   name: name ?? _name,
//   email: email ?? _email,
//   emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
//   isSuperAdmin: isSuperAdmin ?? _isSuperAdmin,
//   isShopAdmin: isShopAdmin ?? _isShopAdmin,
//   isStaff: isStaff ?? _isStaff,
//   departmentId: departmentId ?? _departmentId,
//   designationId: designationId ?? _designationId,
//   storeId: storeId ?? _storeId,
//   rolId: rolId ?? _rolId,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
// );
//   num? get id => _id;
//   String? get name => _name;
//   String? get email => _email;
//   dynamic get emailVerifiedAt => _emailVerifiedAt;
//   dynamic get isSuperAdmin => _isSuperAdmin;
//   String? get isShopAdmin => _isShopAdmin;
//   dynamic get isStaff => _isStaff;
//   num? get departmentId => _departmentId;
//   num? get designationId => _designationId;
//   num? get storeId => _storeId;
//   num? get rolId => _rolId;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['email'] = _email;
//     map['email_verified_at'] = _emailVerifiedAt;
//     map['is_super_admin'] = _isSuperAdmin;
//     map['is_shop_admin'] = _isShopAdmin;
//     map['is_staff'] = _isStaff;
//     map['department_id'] = _departmentId;
//     map['designation_id'] = _designationId;
//     map['store_id'] = _storeId;
//     map['rol_id'] = _rolId;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
//
// }
//
// /// id : 1
// /// code : "a"
// /// name : "aa"
// /// description : null
// /// status : 1
// /// store_id : 2
// /// created_at : null
// /// updated_at : null
// /// deleted_at : null
//
// Van vanFromJson(String str) => Van.fromJson(json.decode(str));
// String vanToJson(Van data) => json.encode(data.toJson());
// class Van {
//   Van({
//       num? id,
//       String? code,
//       String? name,
//       dynamic description,
//       num? status,
//       num? storeId,
//       dynamic createdAt,
//       dynamic updatedAt,
//       dynamic deletedAt,}){
//     _id = id;
//     _code = code;
//     _name = name;
//     _description = description;
//     _status = status;
//     _storeId = storeId;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _deletedAt = deletedAt;
// }
//
//   Van.fromJson(dynamic json) {
//     _id = json['id'];
//     _code = json['code'];
//     _name = json['name'];
//     _description = json['description'];
//     _status = json['status'];
//     _storeId = json['store_id'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//   }
//   num? _id;
//   String? _code;
//   String? _name;
//   dynamic _description;
//   num? _status;
//   num? _storeId;
//   dynamic _createdAt;
//   dynamic _updatedAt;
//   dynamic _deletedAt;
// Van copyWith({  num? id,
//   String? code,
//   String? name,
//   dynamic description,
//   num? status,
//   num? storeId,
//   dynamic createdAt,
//   dynamic updatedAt,
//   dynamic deletedAt,
// }) => Van(  id: id ?? _id,
//   code: code ?? _code,
//   name: name ?? _name,
//   description: description ?? _description,
//   status: status ?? _status,
//   storeId: storeId ?? _storeId,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   deletedAt: deletedAt ?? _deletedAt,
// );
//   num? get id => _id;
//   String? get code => _code;
//   String? get name => _name;
//   dynamic get description => _description;
//   num? get status => _status;
//   num? get storeId => _storeId;
//   dynamic get createdAt => _createdAt;
//   dynamic get updatedAt => _updatedAt;
//   dynamic get deletedAt => _deletedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['code'] = _code;
//     map['name'] = _name;
//     map['description'] = _description;
//     map['status'] = _status;
//     map['store_id'] = _storeId;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['deleted_at'] = _deletedAt;
//     return map;
//   }
//
// }
//
// /// id : 10
// /// name : "City Cialkot Gocery"
// /// code : "AR0003"
// /// address : "P.O Box . 23433"
// /// contact_number : "0523677776"
// /// whatsapp_number : null
// /// email : "citycialkot@gmail.com"
// /// trn : "10221989700999"
// /// cust_image : null
// /// payment_terms : "CASH"
// /// credit_limit : 0
// /// credit_days : 0
// /// route_id : 7
// /// province_id : 3
// /// store_id : 7
// /// status : 1
// /// created_at : "2024-05-22T22:23:42.000000Z"
// /// updated_at : "2024-05-22T22:23:42.000000Z"
// /// deleted_at : null
// /// erp_customer_code : null
//
// Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));
// String customerToJson(Customer data) => json.encode(data.toJson());
// class Customer {
//   Customer({
//       num? id,
//       String? name,
//       String? code,
//       String? address,
//       String? contactNumber,
//       dynamic whatsappNumber,
//       String? email,
//       String? trn,
//       dynamic custImage,
//       String? paymentTerms,
//       num? creditLimit,
//       num? creditDays,
//       num? routeId,
//       num? provinceId,
//       num? storeId,
//       num? status,
//       String? createdAt,
//       String? updatedAt,
//       dynamic deletedAt,
//       dynamic erpCustomerCode,}){
//     _id = id;
//     _name = name;
//     _code = code;
//     _address = address;
//     _contactNumber = contactNumber;
//     _whatsappNumber = whatsappNumber;
//     _email = email;
//     _trn = trn;
//     _custImage = custImage;
//     _paymentTerms = paymentTerms;
//     _creditLimit = creditLimit;
//     _creditDays = creditDays;
//     _routeId = routeId;
//     _provinceId = provinceId;
//     _storeId = storeId;
//     _status = status;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _deletedAt = deletedAt;
//     _erpCustomerCode = erpCustomerCode;
// }
//
//   Customer.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _code = json['code'];
//     _address = json['address'];
//     _contactNumber = json['contact_number'];
//     _whatsappNumber = json['whatsapp_number'];
//     _email = json['email'];
//     _trn = json['trn'];
//     _custImage = json['cust_image'];
//     _paymentTerms = json['payment_terms'];
//     _creditLimit = json['credit_limit'];
//     _creditDays = json['credit_days'];
//     _routeId = json['route_id'];
//     _provinceId = json['province_id'];
//     _storeId = json['store_id'];
//     _status = json['status'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//     _erpCustomerCode = json['erp_customer_code'];
//   }
//   num? _id;
//   String? _name;
//   String? _code;
//   String? _address;
//   String? _contactNumber;
//   dynamic _whatsappNumber;
//   String? _email;
//   String? _trn;
//   dynamic _custImage;
//   String? _paymentTerms;
//   num? _creditLimit;
//   num? _creditDays;
//   num? _routeId;
//   num? _provinceId;
//   num? _storeId;
//   num? _status;
//   String? _createdAt;
//   String? _updatedAt;
//   dynamic _deletedAt;
//   dynamic _erpCustomerCode;
// Customer copyWith({  num? id,
//   String? name,
//   String? code,
//   String? address,
//   String? contactNumber,
//   dynamic whatsappNumber,
//   String? email,
//   String? trn,
//   dynamic custImage,
//   String? paymentTerms,
//   num? creditLimit,
//   num? creditDays,
//   num? routeId,
//   num? provinceId,
//   num? storeId,
//   num? status,
//   String? createdAt,
//   String? updatedAt,
//   dynamic deletedAt,
//   dynamic erpCustomerCode,
// }) => Customer(  id: id ?? _id,
//   name: name ?? _name,
//   code: code ?? _code,
//   address: address ?? _address,
//   contactNumber: contactNumber ?? _contactNumber,
//   whatsappNumber: whatsappNumber ?? _whatsappNumber,
//   email: email ?? _email,
//   trn: trn ?? _trn,
//   custImage: custImage ?? _custImage,
//   paymentTerms: paymentTerms ?? _paymentTerms,
//   creditLimit: creditLimit ?? _creditLimit,
//   creditDays: creditDays ?? _creditDays,
//   routeId: routeId ?? _routeId,
//   provinceId: provinceId ?? _provinceId,
//   storeId: storeId ?? _storeId,
//   status: status ?? _status,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   deletedAt: deletedAt ?? _deletedAt,
//   erpCustomerCode: erpCustomerCode ?? _erpCustomerCode,
// );
//   num? get id => _id;
//   String? get name => _name;
//   String? get code => _code;
//   String? get address => _address;
//   String? get contactNumber => _contactNumber;
//   dynamic get whatsappNumber => _whatsappNumber;
//   String? get email => _email;
//   String? get trn => _trn;
//   dynamic get custImage => _custImage;
//   String? get paymentTerms => _paymentTerms;
//   num? get creditLimit => _creditLimit;
//   num? get creditDays => _creditDays;
//   num? get routeId => _routeId;
//   num? get provinceId => _provinceId;
//   num? get storeId => _storeId;
//   num? get status => _status;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   dynamic get deletedAt => _deletedAt;
//   dynamic get erpCustomerCode => _erpCustomerCode;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['code'] = _code;
//     map['address'] = _address;
//     map['contact_number'] = _contactNumber;
//     map['whatsapp_number'] = _whatsappNumber;
//     map['email'] = _email;
//     map['trn'] = _trn;
//     map['cust_image'] = _custImage;
//     map['payment_terms'] = _paymentTerms;
//     map['credit_limit'] = _creditLimit;
//     map['credit_days'] = _creditDays;
//     map['route_id'] = _routeId;
//     map['province_id'] = _provinceId;
//     map['store_id'] = _storeId;
//     map['status'] = _status;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['deleted_at'] = _deletedAt;
//     map['erp_customer_code'] = _erpCustomerCode;
//     return map;
//   }
//
// }
//
// /// id : 1
// /// goods_out_id : 3
// /// item_id : 1
// /// product_type : "Normal"
// /// unit : "unit no 1"
// /// convert_qty : 0
// /// quantity : 100
// /// rate : 0
// /// prodiscount : 0
// /// taxable : 12000
// /// tax_amt : 240
// /// mrp : 120
// /// amount : 12240
// /// van_id : 1
// /// user_id : 7
// /// store_id : 0
// /// status : 1
// /// created_at : "2024-05-14T07:43:32.000000Z"
// /// updated_at : "2024-05-14T07:43:32.000000Z"
// /// deleted_at : null
// /// code : null
// /// name : "isra Bootile"
// /// pro_image : "defalut.jpg"
// /// category_id : 2
// /// sub_category_id : 5
// /// brand_id : 0
// /// supplier_id : 0
// /// tax_id : 1
// /// tax_percentage : 2
// /// tax_inclusive : 1
// /// price : 100
// /// base_unit_id : 1
// /// base_unit_qty : 1
// /// base_unit_discount : "75.00"
// /// base_unit_barcode : null
// /// base_unit_op_stock : 0
// /// second_unit_price : "500.00"
// /// second_unit_id : 2
// /// second_unit_qty : 10
// /// second_unit_discount : "400.00"
// /// second_unit_barcode : null
// /// second_unit_op_stock : "0.00"
// /// third_unit_price : "0.00"
// /// third_unit_id : 0
// /// third_unit_qty : 0
// /// third_unit_discount : "0.00"
// /// third_unit_barcode : null
// /// third_unit_op_stock : "0.00"
// /// fourth_unit_price : "0.00"
// /// fourth_unit_id : 0
// /// fourth_unit_qty : 1
// /// fourth_unit_discount : "0.00"
// /// is_multiple_unit : 1
// /// fourth_unit_op_stock : "0.00"
// /// description : null
// /// product_qty : 0
// /// percentage : 2
//
// Detail detailFromJson(String str) => Detail.fromJson(json.decode(str));
// String detailToJson(Detail data) => json.encode(data.toJson());
// class Detail {
//   Detail({
//       num? id,
//       num? goodsOutId,
//       num? itemId,
//       String? productType,
//       String? unit,
//       num? convertQty,
//       num? quantity,
//       num? rate,
//       num? prodiscount,
//       num? taxable,
//       num? taxAmt,
//       num? mrp,
//       num? amount,
//       num? vanId,
//       num? userId,
//       num? storeId,
//       num? status,
//       String? createdAt,
//       String? updatedAt,
//       dynamic deletedAt,
//       dynamic code,
//       String? name,
//       String? proImage,
//       num? categoryId,
//       num? subCategoryId,
//       num? brandId,
//       num? supplierId,
//       num? taxId,
//       num? taxPercentage,
//       num? taxInclusive,
//       num? price,
//       num? baseUnitId,
//       num? baseUnitQty,
//       String? baseUnitDiscount,
//       dynamic baseUnitBarcode,
//       num? baseUnitOpStock,
//       String? secondUnitPrice,
//       num? secondUnitId,
//       num? secondUnitQty,
//       String? secondUnitDiscount,
//       dynamic secondUnitBarcode,
//       String? secondUnitOpStock,
//       String? thirdUnitPrice,
//       num? thirdUnitId,
//       num? thirdUnitQty,
//       String? thirdUnitDiscount,
//       dynamic thirdUnitBarcode,
//       String? thirdUnitOpStock,
//       String? fourthUnitPrice,
//       num? fourthUnitId,
//       num? fourthUnitQty,
//       String? fourthUnitDiscount,
//       num? isMultipleUnit,
//       String? fourthUnitOpStock,
//       dynamic description,
//       num? productQty,
//       num? percentage,}){
//     _id = id;
//     _goodsOutId = goodsOutId;
//     _itemId = itemId;
//     _productType = productType;
//     _unit = unit;
//     _convertQty = convertQty;
//     _quantity = quantity;
//     _rate = rate;
//     _prodiscount = prodiscount;
//     _taxable = taxable;
//     _taxAmt = taxAmt;
//     _mrp = mrp;
//     _amount = amount;
//     _vanId = vanId;
//     _userId = userId;
//     _storeId = storeId;
//     _status = status;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _deletedAt = deletedAt;
//     _code = code;
//     _name = name;
//     _proImage = proImage;
//     _categoryId = categoryId;
//     _subCategoryId = subCategoryId;
//     _brandId = brandId;
//     _supplierId = supplierId;
//     _taxId = taxId;
//     _taxPercentage = taxPercentage;
//     _taxInclusive = taxInclusive;
//     _price = price;
//     _baseUnitId = baseUnitId;
//     _baseUnitQty = baseUnitQty;
//     _baseUnitDiscount = baseUnitDiscount;
//     _baseUnitBarcode = baseUnitBarcode;
//     _baseUnitOpStock = baseUnitOpStock;
//     _secondUnitPrice = secondUnitPrice;
//     _secondUnitId = secondUnitId;
//     _secondUnitQty = secondUnitQty;
//     _secondUnitDiscount = secondUnitDiscount;
//     _secondUnitBarcode = secondUnitBarcode;
//     _secondUnitOpStock = secondUnitOpStock;
//     _thirdUnitPrice = thirdUnitPrice;
//     _thirdUnitId = thirdUnitId;
//     _thirdUnitQty = thirdUnitQty;
//     _thirdUnitDiscount = thirdUnitDiscount;
//     _thirdUnitBarcode = thirdUnitBarcode;
//     _thirdUnitOpStock = thirdUnitOpStock;
//     _fourthUnitPrice = fourthUnitPrice;
//     _fourthUnitId = fourthUnitId;
//     _fourthUnitQty = fourthUnitQty;
//     _fourthUnitDiscount = fourthUnitDiscount;
//     _isMultipleUnit = isMultipleUnit;
//     _fourthUnitOpStock = fourthUnitOpStock;
//     _description = description;
//     _productQty = productQty;
//     _percentage = percentage;
// }
//
//   Detail.fromJson(dynamic json) {
//     _id = json['id'];
//     _goodsOutId = json['goods_out_id'];
//     _itemId = json['item_id'];
//     _productType = json['product_type'];
//     _unit = json['unit'];
//     _convertQty = json['convert_qty'];
//     _quantity = json['quantity'];
//     _rate = json['rate'];
//     _prodiscount = json['prodiscount'];
//     _taxable = json['taxable'];
//     _taxAmt = json['tax_amt'];
//     _mrp = json['mrp'];
//     _amount = json['amount'];
//     _vanId = json['van_id'];
//     _userId = json['user_id'];
//     _storeId = json['store_id'];
//     _status = json['status'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//     _code = json['code'];
//     _name = json['name'];
//     _proImage = json['pro_image'];
//     _categoryId = json['category_id'];
//     _subCategoryId = json['sub_category_id'];
//     _brandId = json['brand_id'];
//     _supplierId = json['supplier_id'];
//     _taxId = json['tax_id'];
//     _taxPercentage = json['tax_percentage'];
//     _taxInclusive = json['tax_inclusive'];
//     _price = json['price'];
//     _baseUnitId = json['base_unit_id'];
//     _baseUnitQty = json['base_unit_qty'];
//     _baseUnitDiscount = json['base_unit_discount'];
//     _baseUnitBarcode = json['base_unit_barcode'];
//     _baseUnitOpStock = json['base_unit_op_stock'];
//     _secondUnitPrice = json['second_unit_price'];
//     _secondUnitId = json['second_unit_id'];
//     _secondUnitQty = json['second_unit_qty'];
//     _secondUnitDiscount = json['second_unit_discount'];
//     _secondUnitBarcode = json['second_unit_barcode'];
//     _secondUnitOpStock = json['second_unit_op_stock'];
//     _thirdUnitPrice = json['third_unit_price'];
//     _thirdUnitId = json['third_unit_id'];
//     _thirdUnitQty = json['third_unit_qty'];
//     _thirdUnitDiscount = json['third_unit_discount'];
//     _thirdUnitBarcode = json['third_unit_barcode'];
//     _thirdUnitOpStock = json['third_unit_op_stock'];
//     _fourthUnitPrice = json['fourth_unit_price'];
//     _fourthUnitId = json['fourth_unit_id'];
//     _fourthUnitQty = json['fourth_unit_qty'];
//     _fourthUnitDiscount = json['fourth_unit_discount'];
//     _isMultipleUnit = json['is_multiple_unit'];
//     _fourthUnitOpStock = json['fourth_unit_op_stock'];
//     _description = json['description'];
//     _productQty = json['product_qty'];
//     _percentage = json['percentage'];
//   }
//   num? _id;
//   num? _goodsOutId;
//   num? _itemId;
//   String? _productType;
//   String? _unit;
//   num? _convertQty;
//   num? _quantity;
//   num? _rate;
//   num? _prodiscount;
//   num? _taxable;
//   num? _taxAmt;
//   num? _mrp;
//   num? _amount;
//   num? _vanId;
//   num? _userId;
//   num? _storeId;
//   num? _status;
//   String? _createdAt;
//   String? _updatedAt;
//   dynamic _deletedAt;
//   dynamic _code;
//   String? _name;
//   String? _proImage;
//   num? _categoryId;
//   num? _subCategoryId;
//   num? _brandId;
//   num? _supplierId;
//   num? _taxId;
//   num? _taxPercentage;
//   num? _taxInclusive;
//   num? _price;
//   num? _baseUnitId;
//   num? _baseUnitQty;
//   String? _baseUnitDiscount;
//   dynamic _baseUnitBarcode;
//   num? _baseUnitOpStock;
//   String? _secondUnitPrice;
//   num? _secondUnitId;
//   num? _secondUnitQty;
//   String? _secondUnitDiscount;
//   dynamic _secondUnitBarcode;
//   String? _secondUnitOpStock;
//   String? _thirdUnitPrice;
//   num? _thirdUnitId;
//   num? _thirdUnitQty;
//   String? _thirdUnitDiscount;
//   dynamic _thirdUnitBarcode;
//   String? _thirdUnitOpStock;
//   String? _fourthUnitPrice;
//   num? _fourthUnitId;
//   num? _fourthUnitQty;
//   String? _fourthUnitDiscount;
//   num? _isMultipleUnit;
//   String? _fourthUnitOpStock;
//   dynamic _description;
//   num? _productQty;
//   num? _percentage;
// Detail copyWith({  num? id,
//   num? goodsOutId,
//   num? itemId,
//   String? productType,
//   String? unit,
//   num? convertQty,
//   num? quantity,
//   num? rate,
//   num? prodiscount,
//   num? taxable,
//   num? taxAmt,
//   num? mrp,
//   num? amount,
//   num? vanId,
//   num? userId,
//   num? storeId,
//   num? status,
//   String? createdAt,
//   String? updatedAt,
//   dynamic deletedAt,
//   dynamic code,
//   String? name,
//   String? proImage,
//   num? categoryId,
//   num? subCategoryId,
//   num? brandId,
//   num? supplierId,
//   num? taxId,
//   num? taxPercentage,
//   num? taxInclusive,
//   num? price,
//   num? baseUnitId,
//   num? baseUnitQty,
//   String? baseUnitDiscount,
//   dynamic baseUnitBarcode,
//   num? baseUnitOpStock,
//   String? secondUnitPrice,
//   num? secondUnitId,
//   num? secondUnitQty,
//   String? secondUnitDiscount,
//   dynamic secondUnitBarcode,
//   String? secondUnitOpStock,
//   String? thirdUnitPrice,
//   num? thirdUnitId,
//   num? thirdUnitQty,
//   String? thirdUnitDiscount,
//   dynamic thirdUnitBarcode,
//   String? thirdUnitOpStock,
//   String? fourthUnitPrice,
//   num? fourthUnitId,
//   num? fourthUnitQty,
//   String? fourthUnitDiscount,
//   num? isMultipleUnit,
//   String? fourthUnitOpStock,
//   dynamic description,
//   num? productQty,
//   num? percentage,
// }) => Detail(  id: id ?? _id,
//   goodsOutId: goodsOutId ?? _goodsOutId,
//   itemId: itemId ?? _itemId,
//   productType: productType ?? _productType,
//   unit: unit ?? _unit,
//   convertQty: convertQty ?? _convertQty,
//   quantity: quantity ?? _quantity,
//   rate: rate ?? _rate,
//   prodiscount: prodiscount ?? _prodiscount,
//   taxable: taxable ?? _taxable,
//   taxAmt: taxAmt ?? _taxAmt,
//   mrp: mrp ?? _mrp,
//   amount: amount ?? _amount,
//   vanId: vanId ?? _vanId,
//   userId: userId ?? _userId,
//   storeId: storeId ?? _storeId,
//   status: status ?? _status,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   deletedAt: deletedAt ?? _deletedAt,
//   code: code ?? _code,
//   name: name ?? _name,
//   proImage: proImage ?? _proImage,
//   categoryId: categoryId ?? _categoryId,
//   subCategoryId: subCategoryId ?? _subCategoryId,
//   brandId: brandId ?? _brandId,
//   supplierId: supplierId ?? _supplierId,
//   taxId: taxId ?? _taxId,
//   taxPercentage: taxPercentage ?? _taxPercentage,
//   taxInclusive: taxInclusive ?? _taxInclusive,
//   price: price ?? _price,
//   baseUnitId: baseUnitId ?? _baseUnitId,
//   baseUnitQty: baseUnitQty ?? _baseUnitQty,
//   baseUnitDiscount: baseUnitDiscount ?? _baseUnitDiscount,
//   baseUnitBarcode: baseUnitBarcode ?? _baseUnitBarcode,
//   baseUnitOpStock: baseUnitOpStock ?? _baseUnitOpStock,
//   secondUnitPrice: secondUnitPrice ?? _secondUnitPrice,
//   secondUnitId: secondUnitId ?? _secondUnitId,
//   secondUnitQty: secondUnitQty ?? _secondUnitQty,
//   secondUnitDiscount: secondUnitDiscount ?? _secondUnitDiscount,
//   secondUnitBarcode: secondUnitBarcode ?? _secondUnitBarcode,
//   secondUnitOpStock: secondUnitOpStock ?? _secondUnitOpStock,
//   thirdUnitPrice: thirdUnitPrice ?? _thirdUnitPrice,
//   thirdUnitId: thirdUnitId ?? _thirdUnitId,
//   thirdUnitQty: thirdUnitQty ?? _thirdUnitQty,
//   thirdUnitDiscount: thirdUnitDiscount ?? _thirdUnitDiscount,
//   thirdUnitBarcode: thirdUnitBarcode ?? _thirdUnitBarcode,
//   thirdUnitOpStock: thirdUnitOpStock ?? _thirdUnitOpStock,
//   fourthUnitPrice: fourthUnitPrice ?? _fourthUnitPrice,
//   fourthUnitId: fourthUnitId ?? _fourthUnitId,
//   fourthUnitQty: fourthUnitQty ?? _fourthUnitQty,
//   fourthUnitDiscount: fourthUnitDiscount ?? _fourthUnitDiscount,
//   isMultipleUnit: isMultipleUnit ?? _isMultipleUnit,
//   fourthUnitOpStock: fourthUnitOpStock ?? _fourthUnitOpStock,
//   description: description ?? _description,
//   productQty: productQty ?? _productQty,
//   percentage: percentage ?? _percentage,
// );
//   num? get id => _id;
//   num? get goodsOutId => _goodsOutId;
//   num? get itemId => _itemId;
//   String? get productType => _productType;
//   String? get unit => _unit;
//   num? get convertQty => _convertQty;
//   num? get quantity => _quantity;
//   num? get rate => _rate;
//   num? get prodiscount => _prodiscount;
//   num? get taxable => _taxable;
//   num? get taxAmt => _taxAmt;
//   num? get mrp => _mrp;
//   num? get amount => _amount;
//   num? get vanId => _vanId;
//   num? get userId => _userId;
//   num? get storeId => _storeId;
//   num? get status => _status;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   dynamic get deletedAt => _deletedAt;
//   dynamic get code => _code;
//   String? get name => _name;
//   String? get proImage => _proImage;
//   num? get categoryId => _categoryId;
//   num? get subCategoryId => _subCategoryId;
//   num? get brandId => _brandId;
//   num? get supplierId => _supplierId;
//   num? get taxId => _taxId;
//   num? get taxPercentage => _taxPercentage;
//   num? get taxInclusive => _taxInclusive;
//   num? get price => _price;
//   num? get baseUnitId => _baseUnitId;
//   num? get baseUnitQty => _baseUnitQty;
//   String? get baseUnitDiscount => _baseUnitDiscount;
//   dynamic get baseUnitBarcode => _baseUnitBarcode;
//   num? get baseUnitOpStock => _baseUnitOpStock;
//   String? get secondUnitPrice => _secondUnitPrice;
//   num? get secondUnitId => _secondUnitId;
//   num? get secondUnitQty => _secondUnitQty;
//   String? get secondUnitDiscount => _secondUnitDiscount;
//   dynamic get secondUnitBarcode => _secondUnitBarcode;
//   String? get secondUnitOpStock => _secondUnitOpStock;
//   String? get thirdUnitPrice => _thirdUnitPrice;
//   num? get thirdUnitId => _thirdUnitId;
//   num? get thirdUnitQty => _thirdUnitQty;
//   String? get thirdUnitDiscount => _thirdUnitDiscount;
//   dynamic get thirdUnitBarcode => _thirdUnitBarcode;
//   String? get thirdUnitOpStock => _thirdUnitOpStock;
//   String? get fourthUnitPrice => _fourthUnitPrice;
//   num? get fourthUnitId => _fourthUnitId;
//   num? get fourthUnitQty => _fourthUnitQty;
//   String? get fourthUnitDiscount => _fourthUnitDiscount;
//   num? get isMultipleUnit => _isMultipleUnit;
//   String? get fourthUnitOpStock => _fourthUnitOpStock;
//   dynamic get description => _description;
//   num? get productQty => _productQty;
//   num? get percentage => _percentage;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['goods_out_id'] = _goodsOutId;
//     map['item_id'] = _itemId;
//     map['product_type'] = _productType;
//     map['unit'] = _unit;
//     map['convert_qty'] = _convertQty;
//     map['quantity'] = _quantity;
//     map['rate'] = _rate;
//     map['prodiscount'] = _prodiscount;
//     map['taxable'] = _taxable;
//     map['tax_amt'] = _taxAmt;
//     map['mrp'] = _mrp;
//     map['amount'] = _amount;
//     map['van_id'] = _vanId;
//     map['user_id'] = _userId;
//     map['store_id'] = _storeId;
//     map['status'] = _status;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['deleted_at'] = _deletedAt;
//     map['code'] = _code;
//     map['name'] = _name;
//     map['pro_image'] = _proImage;
//     map['category_id'] = _categoryId;
//     map['sub_category_id'] = _subCategoryId;
//     map['brand_id'] = _brandId;
//     map['supplier_id'] = _supplierId;
//     map['tax_id'] = _taxId;
//     map['tax_percentage'] = _taxPercentage;
//     map['tax_inclusive'] = _taxInclusive;
//     map['price'] = _price;
//     map['base_unit_id'] = _baseUnitId;
//     map['base_unit_qty'] = _baseUnitQty;
//     map['base_unit_discount'] = _baseUnitDiscount;
//     map['base_unit_barcode'] = _baseUnitBarcode;
//     map['base_unit_op_stock'] = _baseUnitOpStock;
//     map['second_unit_price'] = _secondUnitPrice;
//     map['second_unit_id'] = _secondUnitId;
//     map['second_unit_qty'] = _secondUnitQty;
//     map['second_unit_discount'] = _secondUnitDiscount;
//     map['second_unit_barcode'] = _secondUnitBarcode;
//     map['second_unit_op_stock'] = _secondUnitOpStock;
//     map['third_unit_price'] = _thirdUnitPrice;
//     map['third_unit_id'] = _thirdUnitId;
//     map['third_unit_qty'] = _thirdUnitQty;
//     map['third_unit_discount'] = _thirdUnitDiscount;
//     map['third_unit_barcode'] = _thirdUnitBarcode;
//     map['third_unit_op_stock'] = _thirdUnitOpStock;
//     map['fourth_unit_price'] = _fourthUnitPrice;
//     map['fourth_unit_id'] = _fourthUnitId;
//     map['fourth_unit_qty'] = _fourthUnitQty;
//     map['fourth_unit_discount'] = _fourthUnitDiscount;
//     map['is_multiple_unit'] = _isMultipleUnit;
//     map['fourth_unit_op_stock'] = _fourthUnitOpStock;
//     map['description'] = _description;
//     map['product_qty'] = _productQty;
//     map['percentage'] = _percentage;
//     return map;
//   }
//
// }
//
// /// id : 5
// /// code : "CO0001"
// /// name : "Al Raidhan"
// /// comapny_id : 1
// /// logo : "defalut.jpg"
// /// address : null
// /// emirate : "1"
// /// country : "UAE"
// /// contact_number : "7894561236"
// /// whatsapp_number : null
// /// email : "al@gmail.com"
// /// username : "al@gmail.com"
// /// password : "12345678"
// /// no_of_users : 5
// /// suscription_end_date : "2024-05-25"
// /// buffer_days : null
// /// description : null
// /// currency : null
// /// vat_percentage : null
// /// trn : null
// /// status : 1
// /// created_at : "2024-05-22T00:08:05.000000Z"
// /// updated_at : "2024-05-22T00:08:05.000000Z"
// /// deleted_at : null
//
// Store storeFromJson(String str) => Store.fromJson(json.decode(str));
// String storeToJson(Store data) => json.encode(data.toJson());
// class Store {
//   Store({
//       num? id,
//       String? code,
//       String? name,
//       num? comapnyId,
//       String? logo,
//       dynamic address,
//       String? emirate,
//       String? country,
//       String? contactNumber,
//       dynamic whatsappNumber,
//       String? email,
//       String? username,
//       String? password,
//       num? noOfUsers,
//       String? suscriptionEndDate,
//       dynamic bufferDays,
//       dynamic description,
//       dynamic currency,
//       dynamic vatPercentage,
//       dynamic trn,
//       num? status,
//       String? createdAt,
//       String? updatedAt,
//       dynamic deletedAt,}){
//     _id = id;
//     _code = code;
//     _name = name;
//     _comapnyId = comapnyId;
//     _logo = logo;
//     _address = address;
//     _emirate = emirate;
//     _country = country;
//     _contactNumber = contactNumber;
//     _whatsappNumber = whatsappNumber;
//     _email = email;
//     _username = username;
//     _password = password;
//     _noOfUsers = noOfUsers;
//     _suscriptionEndDate = suscriptionEndDate;
//     _bufferDays = bufferDays;
//     _description = description;
//     _currency = currency;
//     _vatPercentage = vatPercentage;
//     _trn = trn;
//     _status = status;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _deletedAt = deletedAt;
// }
//
//   Store.fromJson(dynamic json) {
//     _id = json['id'];
//     _code = json['code'];
//     _name = json['name'];
//     _comapnyId = json['comapny_id'];
//     _logo = json['logo'];
//     _address = json['address'];
//     _emirate = json['emirate'];
//     _country = json['country'];
//     _contactNumber = json['contact_number'];
//     _whatsappNumber = json['whatsapp_number'];
//     _email = json['email'];
//     _username = json['username'];
//     _password = json['password'];
//     _noOfUsers = json['no_of_users'];
//     _suscriptionEndDate = json['suscription_end_date'];
//     _bufferDays = json['buffer_days'];
//     _description = json['description'];
//     _currency = json['currency'];
//     _vatPercentage = json['vat_percentage'];
//     _trn = json['trn'];
//     _status = json['status'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//   }
//   num? _id;
//   String? _code;
//   String? _name;
//   num? _comapnyId;
//   String? _logo;
//   dynamic _address;
//   String? _emirate;
//   String? _country;
//   String? _contactNumber;
//   dynamic _whatsappNumber;
//   String? _email;
//   String? _username;
//   String? _password;
//   num? _noOfUsers;
//   String? _suscriptionEndDate;
//   dynamic _bufferDays;
//   dynamic _description;
//   dynamic _currency;
//   dynamic _vatPercentage;
//   dynamic _trn;
//   num? _status;
//   String? _createdAt;
//   String? _updatedAt;
//   dynamic _deletedAt;
// Store copyWith({  num? id,
//   String? code,
//   String? name,
//   num? comapnyId,
//   String? logo,
//   dynamic address,
//   String? emirate,
//   String? country,
//   String? contactNumber,
//   dynamic whatsappNumber,
//   String? email,
//   String? username,
//   String? password,
//   num? noOfUsers,
//   String? suscriptionEndDate,
//   dynamic bufferDays,
//   dynamic description,
//   dynamic currency,
//   dynamic vatPercentage,
//   dynamic trn,
//   num? status,
//   String? createdAt,
//   String? updatedAt,
//   dynamic deletedAt,
// }) => Store(  id: id ?? _id,
//   code: code ?? _code,
//   name: name ?? _name,
//   comapnyId: comapnyId ?? _comapnyId,
//   logo: logo ?? _logo,
//   address: address ?? _address,
//   emirate: emirate ?? _emirate,
//   country: country ?? _country,
//   contactNumber: contactNumber ?? _contactNumber,
//   whatsappNumber: whatsappNumber ?? _whatsappNumber,
//   email: email ?? _email,
//   username: username ?? _username,
//   password: password ?? _password,
//   noOfUsers: noOfUsers ?? _noOfUsers,
//   suscriptionEndDate: suscriptionEndDate ?? _suscriptionEndDate,
//   bufferDays: bufferDays ?? _bufferDays,
//   description: description ?? _description,
//   currency: currency ?? _currency,
//   vatPercentage: vatPercentage ?? _vatPercentage,
//   trn: trn ?? _trn,
//   status: status ?? _status,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   deletedAt: deletedAt ?? _deletedAt,
// );
//   num? get id => _id;
//   String? get code => _code;
//   String? get name => _name;
//   num? get comapnyId => _comapnyId;
//   String? get logo => _logo;
//   dynamic get address => _address;
//   String? get emirate => _emirate;
//   String? get country => _country;
//   String? get contactNumber => _contactNumber;
//   dynamic get whatsappNumber => _whatsappNumber;
//   String? get email => _email;
//   String? get username => _username;
//   String? get password => _password;
//   num? get noOfUsers => _noOfUsers;
//   String? get suscriptionEndDate => _suscriptionEndDate;
//   dynamic get bufferDays => _bufferDays;
//   dynamic get description => _description;
//   dynamic get currency => _currency;
//   dynamic get vatPercentage => _vatPercentage;
//   dynamic get trn => _trn;
//   num? get status => _status;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   dynamic get deletedAt => _deletedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['code'] = _code;
//     map['name'] = _name;
//     map['comapny_id'] = _comapnyId;
//     map['logo'] = _logo;
//     map['address'] = _address;
//     map['emirate'] = _emirate;
//     map['country'] = _country;
//     map['contact_number'] = _contactNumber;
//     map['whatsapp_number'] = _whatsappNumber;
//     map['email'] = _email;
//     map['username'] = _username;
//     map['password'] = _password;
//     map['no_of_users'] = _noOfUsers;
//     map['suscription_end_date'] = _suscriptionEndDate;
//     map['buffer_days'] = _bufferDays;
//     map['description'] = _description;
//     map['currency'] = _currency;
//     map['vat_percentage'] = _vatPercentage;
//     map['trn'] = _trn;
//     map['status'] = _status;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['deleted_at'] = _deletedAt;
//     return map;
//   }
//
// }