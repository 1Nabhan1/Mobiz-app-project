// Define your model classes
class Offload {
  final List<SalesReturnItem> data;
  final bool success;
  final List<String> messages;

  Offload({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory Offload.fromJson(Map<String, dynamic> json) {
    return Offload(
      data: (json['data'] as List).map((item) => SalesReturnItem.fromJson(item)).toList(),
      success: json['success'],
      messages: List<String>.from(json['messages']),
    );
  }
}

class SalesReturnItem {
  final int id;
  final int goodsOutId;
  final int itemId;
  final int productType;
  final int unit;
  final int convertQty;
  final int quantity;
  final int rate;
  final int prodiscount;
  final double taxable;
  final double taxAmt;
  final double mrp;
  final double amount;
  final int vanId;
  final int userId;
  final int storeId;
  final int status;
  final int inVan;
  final String createdAt;
  final String updatedAt;
  final dynamic deletedAt;
  final List<Product> product;
  final List<Unit> units;
  final List<ReturnType> returnType;

  SalesReturnItem({
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
    required this.inVan,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.product,
    required this.units,
    required this.returnType,
  });

  factory SalesReturnItem.fromJson(Map<String, dynamic> json) {
    return SalesReturnItem(
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
      inVan: json['in_van'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      product: (json['product'] as List).map((item) => Product.fromJson(item)).toList(),
      units: (json['units'] as List).map((item) => Unit.fromJson(item)).toList(),
      returnType: (json['returntype'] as List).map((item) => ReturnType.fromJson(item)).toList(),
    );
  }
}

class Product {
  final int id;
  final dynamic code;
  final String name;
  final String proImage;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.proImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      proImage: json['pro_image'],
    );
  }
}

class Unit {
  final int id;
  final String name;
  final String description;
  final int status;
  final int storeId;
  final String createdAt;
  final String updatedAt;
  final dynamic deletedAt;

  Unit({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      storeId: json['store_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

class ReturnType {
  final int id;
  final String name;
  final int storeId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final dynamic deletedAt;

  ReturnType({
    required this.id,
    required this.name,
    required this.storeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory ReturnType.fromJson(Map<String, dynamic> json) {
    return ReturnType(
      id: json['id'],
      name: json['name'],
      storeId: json['store_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}