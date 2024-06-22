import 'homorderModel.dart';

class Customer {
  final int id;
  final String name;
  final String code;
  final String address;
  final String contactNumber;
  final String email;
  final String payment_terms;

  Customer({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.payment_terms,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        address: json['address'],
        contactNumber: json['contact_number'],
        email: json['email'],
        payment_terms: json['payment_terms']);
  }
}

class Detail {
  final int id;
  final int goodsOutId;
  final int itemId;
  final String productType;
  final String name;
  final String unit;
  final int quantity;
  final double rate;
  final double proDiscount;
  final double taxable;
  final double taxAmt;
  final double mrp;
  final double amount;
  final String createdAt;
  final String updatedAt;

  Detail({
    required this.id,
    required this.name,
    required this.goodsOutId,
    required this.itemId,
    required this.productType,
    required this.unit,
    required this.quantity,
    required this.rate,
    required this.proDiscount,
    required this.taxable,
    required this.taxAmt,
    required this.mrp,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      name: json['name'],
      id: json['id'],
      goodsOutId: json['goods_out_id'],
      itemId: json['item_id'],
      productType: json['product_type'],
      unit: json['unit'],
      quantity: json['quantity'],
      rate: json['rate'].toDouble(),
      proDiscount: json['prodiscount'].toDouble(),
      taxable: json['taxable'].toDouble(),
      taxAmt: json['tax_amt'].toDouble(),
      mrp: json['mrp'].toDouble(),
      amount: json['amount'].toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

// invoice_model.dart
class Invoice {
  final int id;
  final int if_vat;
  final String invoiceNo;
  final String inDate;
  final String inTime;
  final String round_off;
  final double total;
  final int grand_total;

  final List<Detail> details;
  final List<Customer> customers;

  Invoice({
    required this.id,
    required this.grand_total,
    required this.if_vat,
    required this.invoiceNo,
    required this.round_off,
    required this.inDate,
    required this.inTime,
    required this.total,
    required this.customers,
    required this.details,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    var customerList = json['customer'] as List;
    List<Customer> customers =
        customerList.map((customer) => Customer.fromJson(customer)).toList();
    var detailList = json['detail'] as List;
    List<Detail> details =
        detailList.map((detail) => Detail.fromJson(detail)).toList();

    return Invoice(
      id: json['id'],
      grand_total: json['grand_total'],
      if_vat: json['if_vat'],
      round_off: json['round_off'],
      invoiceNo: json['invoice_no'],
      inDate: json['in_date'],
      inTime: json['in_time'],
      total: json['total'].toDouble(),
      customers: customers,
      details: details,
    );
  }
}
