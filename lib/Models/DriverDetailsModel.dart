import 'dart:convert';

// Main response model class
class ApiResponse {
  final List<Data> data;
  final bool success;
  final List<String> messages;

  ApiResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: List<Data>.from(json['data'].map((x) => Data.fromJson(x))),
      success: json['success'],
      messages: List<String>.from(json['messages'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'success': success,
      'messages': List<dynamic>.from(messages.map((x) => x)),
    };
  }
}

// Data class to hold each data item
class Data {
  final int id;
  final int customerId;
  final String billMode;
  final String inDate;
  final String inTime;
  final String invoiceNo;
  final String deliveryNo;
  final int otherCharge;
  final dynamic discountType;
  final int discount;
  final String roundOff;
  final int total;
  final int totalTax;
  final int grandTotal;
  final int receipt;
  final int balance;
  final int orderType;
  final int ifVat;
  final dynamic remarks;
  final int vanId;
  final int userId;
  final int storeId;
  final int dayClose;
  final int soToSale;
  final List<String> soReference;
  final int driverId;
  final String scheduleDate;
  final int pickList;
  final int delivered;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final List<Detail> detail;
  final List<Customer> customer;

  Data({
    required this.id,
    required this.customerId,
    required this.billMode,
    required this.inDate,
    required this.inTime,
    required this.invoiceNo,
    required this.deliveryNo,
    required this.otherCharge,
    this.discountType,
    required this.discount,
    required this.roundOff,
    required this.total,
    required this.totalTax,
    required this.grandTotal,
    required this.receipt,
    required this.balance,
    required this.orderType,
    required this.ifVat,
    this.remarks,
    required this.vanId,
    required this.userId,
    required this.storeId,
    required this.dayClose,
    required this.soToSale,
    required this.soReference,
    required this.driverId,
    required this.scheduleDate,
    required this.pickList,
    required this.delivered,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.detail,
    required this.customer,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      customerId: json['customer_id'],
      billMode: json['bill_mode'],
      inDate: json['in_date'],
      inTime: json['in_time'],
      invoiceNo: json['invoice_no'],
      deliveryNo: json['delivery_no'],
      otherCharge: json['other_charge'],
      discountType: json['discount_type'],
      discount: json['discount'],
      roundOff: json['round_off'],
      total: json['total'],
      totalTax: json['total_tax'],
      grandTotal: json['grand_total'],
      receipt: json['receipt'],
      balance: json['balance'],
      orderType: json['order_type'],
      ifVat: json['if_vat'],
      remarks: json['remarks'],
      vanId: json['van_id'],
      userId: json['user_id'],
      storeId: json['store_id'],
      dayClose: json['day_close'],
      soToSale: json['so_to_sale'],
      soReference: List<String>.from(jsonDecode(json['so_reference'])),
      driverId: json['driver_id'],
      scheduleDate: json['schedule_date'],
      pickList: json['pick_list'],
      delivered: json['deliverd'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'],
      detail: List<Detail>.from(json['detail'].map((x) => Detail.fromJson(x))),
      customer: List<Customer>.from(json['customer'].map((x) => Customer.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'bill_mode': billMode,
      'in_date': inDate,
      'in_time': inTime,
      'invoice_no': invoiceNo,
      'delivery_no': deliveryNo,
      'other_charge': otherCharge,
      'discount_type': discountType,
      'discount': discount,
      'round_off': roundOff,
      'total': total,
      'total_tax': totalTax,
      'grand_total': grandTotal,
      'receipt': receipt,
      'balance': balance,
      'order_type': orderType,
      'if_vat': ifVat,
      'remarks': remarks,
      'van_id': vanId,
      'user_id': userId,
      'store_id': storeId,
      'day_close': dayClose,
      'so_to_sale': soToSale,
      'so_reference': jsonEncode(soReference),
      'driver_id': driverId,
      'schedule_date': scheduleDate,
      'pick_list': pickList,
      'deliverd': delivered,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt,
      'detail': List<dynamic>.from(detail.map((x) => x.toJson())),
      'customer': List<dynamic>.from(customer.map((x) => x.toJson())),
    };
  }
}


// Detail class to hold detail data
class Detail {
  final int id;
  final int goodsOutId;
  final int itemId;
  final String productType;
  final String unit;
  final int convertQty;
  final int quantity;
  final int rate;
  final int prodiscount;
  final int taxable;
  final int taxAmt;
  final int mrp;
  final int amount;
  final int vanId;
  final int userId;
  final int storeId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final String code;
  final String name;
  final String proImage;
  final int categoryId;
  final int subCategoryId;
  final int brandId;
  final int supplierId;
  final int taxId;
  final int taxPercentage;
  final int taxInclusive;
  final int price;
  final int baseUnitId;
  final int baseUnitQty;
  final String baseUnitDiscount;
  final dynamic baseUnitBarcode;
  final int baseUnitOpStock;
  final String secondUnitPrice;
  final int secondUnitId;
  final int secondUnitQty;
  final String secondUnitDiscount;
  final dynamic secondUnitBarcode;
  final String secondUnitOpStock;
  final String thirdUnitPrice;
  final int thirdUnitId;
  final int thirdUnitQty;
  final String thirdUnitDiscount;
  final dynamic thirdUnitBarcode;
  final String thirdUnitOpStock;
  final String fourthUnitPrice;
  final int fourthUnitId;
  final int fourthUnitQty;
  final String fourthUnitDiscount;
  final int isMultipleUnit;
  final String fourthUnitOpStock;
  final dynamic description;
  final int productQty;
  final int percentage;

  Detail({
    required this.id,
    required this.goodsOutId,
    required this.itemId,
    required this.productType,
    required this.unit,
    required this.convertQty,
    required this.quantity,
    required this.rate,
    required this.prodiscount,
    required this.taxable,
    required this.taxAmt,
    required this.mrp,
    required this.amount,
    required this.vanId,
    required this.userId,
    required this.storeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.code,
    required this.name,
    required this.proImage,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.supplierId,
    required this.taxId,
    required this.taxPercentage,
    required this.taxInclusive,
    required this.price,
    required this.baseUnitId,
    required this.baseUnitQty,
    required this.baseUnitDiscount,
    this.baseUnitBarcode,
    required this.baseUnitOpStock,
    required this.secondUnitPrice,
    required this.secondUnitId,
    required this.secondUnitQty,
    required this.secondUnitDiscount,
    this.secondUnitBarcode,
    required this.secondUnitOpStock,
    required this.thirdUnitPrice,
    required this.thirdUnitId,
    required this.thirdUnitQty,
    required this.thirdUnitDiscount,
    this.thirdUnitBarcode,
    required this.thirdUnitOpStock,
    required this.fourthUnitPrice,
    required this.fourthUnitId,
    required this.fourthUnitQty,
    required this.fourthUnitDiscount,
    required this.isMultipleUnit,
    required this.fourthUnitOpStock,
    this.description,
    required this.productQty,
    required this.percentage,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      id: json['id'],
      goodsOutId: json['goods_out_id'],
      itemId: json['item_id'],
      productType: json['product_type'],
      unit: json['unit'],
      convertQty: json['convert_qty'],
      quantity: json['quantity'],
      rate: json['rate'],
      prodiscount: json['prodiscount'],
      taxable: json['taxable'],
      taxAmt: json['tax_amt'],
      mrp: json['mrp'],
      amount: json['amount'],
      vanId: json['van_id'],
      userId: json['user_id'],
      storeId: json['store_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'],
      code: json['code'],
      name: json['name'],
      proImage: json['pro_image'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      brandId: json['brand_id'],
      supplierId: json['supplier_id'],
      taxId: json['tax_id'],
      taxPercentage: json['tax_percentage'],
      taxInclusive: json['tax_inclusive'],
      price: json['price'],
      baseUnitId: json['base_unit_id'],
      baseUnitQty: json['base_unit_qty'],
      baseUnitDiscount: json['base_unit_discount'],
      baseUnitBarcode: json['base_unit_barcode'],
      baseUnitOpStock: json['base_unit_op_stock'],
      secondUnitPrice: json['second_unit_price'],
      secondUnitId: json['second_unit_id'],
      secondUnitQty: json['second_unit_qty'],
      secondUnitDiscount: json['second_unit_discount'],
      secondUnitBarcode: json['second_unit_barcode'],
      secondUnitOpStock: json['second_unit_op_stock'],
      thirdUnitPrice: json['third_unit_price'],
      thirdUnitId: json['third_unit_id'],
      thirdUnitQty: json['third_unit_qty'],
      thirdUnitDiscount: json['third_unit_discount'],
      thirdUnitBarcode: json['third_unit_barcode'],
      thirdUnitOpStock: json['third_unit_op_stock'],
      fourthUnitPrice: json['fourth_unit_price'],
      fourthUnitId: json['fourth_unit_id'],
      fourthUnitQty: json['fourth_unit_qty'],
      fourthUnitDiscount: json['fourth_unit_discount'],
      isMultipleUnit: json['is_multiple_unit'],
      fourthUnitOpStock: json['fourth_unit_op_stock'],
      description: json['description'],
      productQty: json['product_qty'],
      percentage: json['percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goods_out_id': goodsOutId,
      'item_id': itemId,
      'product_type': productType,
      'unit': unit,
      'convert_qty': convertQty,
      'quantity': quantity,
      'rate': rate,
      'prodiscount': prodiscount,
      'taxable': taxable,
      'tax_amt': taxAmt,
      'mrp': mrp,
      'amount': amount,
      'van_id': vanId,
      'user_id': userId,
      'store_id': storeId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt,
      'code': code,
      'name': name,
      'pro_image': proImage,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'brand_id': brandId,
      'supplier_id': supplierId,
      'tax_id': taxId,
      'tax_percentage': taxPercentage,
      'tax_inclusive': taxInclusive,
      'price': price,
      'base_unit_id': baseUnitId,
      'base_unit_qty': baseUnitQty,
      'base_unit_discount': baseUnitDiscount,
      'base_unit_barcode': baseUnitBarcode,
      'base_unit_op_stock': baseUnitOpStock,
      'second_unit_price': secondUnitPrice,
      'second_unit_id': secondUnitId,
      'second_unit_qty': secondUnitQty,
      'second_unit_discount': secondUnitDiscount,
      'second_unit_barcode': secondUnitBarcode,
      'second_unit_op_stock': secondUnitOpStock,
      'third_unit_price': thirdUnitPrice,
      'third_unit_id': thirdUnitId,
      'third_unit_qty': thirdUnitQty,
      'third_unit_discount': thirdUnitDiscount,
      'third_unit_barcode': thirdUnitBarcode,
      'third_unit_op_stock': thirdUnitOpStock,
      'fourth_unit_price': fourthUnitPrice,
      'fourth_unit_id': fourthUnitId,
      'fourth_unit_qty': fourthUnitQty,
      'fourth_unit_discount': fourthUnitDiscount,
      'is_multiple_unit': isMultipleUnit,
      'fourth_unit_op_stock': fourthUnitOpStock,
      'description': description,
      'product_qty': productQty,
      'percentage': percentage,
    };
  }
}

// Customer class to hold customer data
class Customer {
  final int id;
  final String name;
  final String code;
  final String address;
  final String contactNumber;
  final dynamic whatsappNumber;
  final dynamic email;
  final String trn;
  final String custImage;
  final String paymentTerms;
  final int creditLimit;
  final int creditDays;
  final String location;
  final int routeId;
  final int provinceId;
  final int storeId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final dynamic erpCustomerCode;

  Customer({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.contactNumber,
    this.whatsappNumber,
    this.email,
    required this.trn,
    required this.custImage,
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'],
      erpCustomerCode: json['erp_customer_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'contact_number': contactNumber,
      'whatsapp_number': whatsappNumber,
      'email': email,
      'trn': trn,
      'cust_image': custImage,
      'payment_terms': paymentTerms,
      'credit_limit': creditLimit,
      'credit_days': creditDays,
      'location': location,
      'route_id': routeId,
      'province_id': provinceId,
      'store_id': storeId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt,
      'erp_customer_code': erpCustomerCode,
    };
  }
}
