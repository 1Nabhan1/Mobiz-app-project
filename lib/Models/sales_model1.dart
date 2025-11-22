class Products {
  final int id;
  final String code;
  final String name;
  final String proImage;
  final double price;
  final int taxPercentage;
  final String? lastdate;
  final String? lastUnit;
  final double lastPrice; // New field
  final List<Unit> units;

  Products({
    required this.id,
    required this.code,
    required this.name,
    required this.proImage,
    required this.price,
    required this.taxPercentage,
    required this.lastdate,
    required this.lastUnit,
    required this.lastPrice,
    required this.units,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    var unitList = json['units'] as List? ?? [];
    List<Unit> unitsList = unitList.map((i) => Unit.fromJson(i)).toList();

    return Products(
      id: json['id'] ?? 0,
      code: (json['code'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      proImage: (json['pro_image'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      taxPercentage: json['tax_percentage'] ?? 0,
      lastdate: (json['lastdate'] as String?) ?? '',
      lastUnit: (json['lastunit'] as String?) ?? '',
      lastPrice: (json['lastprice'] as num?)?.toDouble() ?? 0.0,
      units: unitsList,
    );
  }

}

class Unit {
  final int id;
  final String name;
  final String price;
  final String minPrice;
  final num stock;

  Unit({
    required this.id,
    required this.name,
    required this.price,
    required this.minPrice,
    required this.stock,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      minPrice: json['min_price']??'',
      stock: num.tryParse(json['stock'].toString()) ?? 0, // Handles both int and double
    );
  }
}

class ProductType {
  final int id;
  final String name;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductType({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? '1970-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(json['updated_at'] ?? '1970-01-01T00:00:00Z'),
    );
  }
}
