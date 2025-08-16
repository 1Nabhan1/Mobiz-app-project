class Products {
  final int id;
  final String code;
  final String name;
  final String proImage;
  final double price;
  final int taxPercentage;
  final String lastdate; // New field
  final String lastUnit; // New field
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
    var unitList = json['units'] as List;
    List<Unit> unitsList = unitList.map((i) => Unit.fromJson(i)).toList();

    return Products(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      proImage: json['pro_image'],
      price: json['price'].toDouble(),
      taxPercentage: json['tax_percentage'],
      lastdate: json['lastdate'] ?? '', // New field
      lastUnit: json['lastunit'] ?? '', // New field
      lastPrice: json['lastprice']?.toDouble() ?? 0.0, // New field
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
