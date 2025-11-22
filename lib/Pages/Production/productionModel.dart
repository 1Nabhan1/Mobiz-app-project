class ProductionOrder {
  final int id;
  final String invoiceNo;
  final String inDate;
  final String quantity;
  final String producedQty;
  final Product product;
  final Warehouse? warehouse;
  final List<ProductionDetail> details;

  ProductionOrder({
    required this.id,
    required this.invoiceNo,
    required this.inDate,
    required this.quantity,
    required this.producedQty,
    required this.product,
    required this.details,
    this.warehouse,
  });

  factory ProductionOrder.fromJson(Map<String, dynamic> json) {
    return ProductionOrder(
      id: json['id'],
      invoiceNo: json['invoice_no'] ?? '',
      inDate: json['in_date'] ?? '',
      quantity: json['quandity'] ?? '0',
      producedQty: json['produced_qty'] ?? '0',
      product: Product.fromJson(json['product']),
      warehouse: json['warehouse'] != null
          ? Warehouse.fromJson(json['warehouse'])
          : null,
      details: (json['detail'] as List<dynamic>)
          .map((e) => ProductionDetail.fromJson(e))
          .toList(),
    );
  }
}

class Product {
  final int id;
  final String name;

  Product({required this.id, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(id: json['id'], name: json['name']);
  }
}

class ProductionDetail {
  final int id;
  final String unit;
  final String producName;
  final String bomQuantity;

  ProductionDetail({
    required this.id,
    required this.unit,
    required this.producName,
    required this.bomQuantity,
  });

  factory ProductionDetail.fromJson(Map<String, dynamic> json) {
    return ProductionDetail(
      id: json['id'],
      unit: json['unit'] ?? '',
      producName: json['producName'] ?? '',
      bomQuantity: json['bom_quantity'] ?? '0',
    );
  }
}

class Warehouse {
  final int id;
  final String name;

  Warehouse({required this.id, required this.name});

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(id: json['id'], name: json['name']);
  }
}
