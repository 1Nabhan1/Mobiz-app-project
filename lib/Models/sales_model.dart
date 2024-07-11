
class ProductDataModel {
  final Data data;
  final bool success;
  final List<dynamic> messages;

  ProductDataModel({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      data: Data.fromJson(json['data']),
      success: json['success'],
      messages: List<dynamic>.from(json['messages']),
    );
  }
}

class Data {
  final int currentPage;
  final List<Product> products;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final String nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  Data({
    required this.currentPage,
    required this.products,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      currentPage: json['current_page'],
      products: List<Product>.from(
        json['data'].map((product) => Product.fromJson(product)),
      ),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<Link>.from(json['links'].map((link) => Link.fromJson(link))),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class Product {
  final int id;
  final String code;
  final String name;
  final String proImage;
  final int taxPercentage;
  final double price;
  final int storeId;
  final int status;
  final List<Unit> units;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.proImage,
    required this.taxPercentage,
    required this.price,
    required this.storeId,
    required this.status,
    required this.units,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      proImage: json['pro_image'],
      taxPercentage: json['tax_percentage'],
      price: double.parse(json['price'].toString()),
      storeId: json['store_id'],
      status: json['status'],
      units: List<Unit>.from(
        json['units'].map((unit) => Unit.fromJson(unit)),
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'pro_image': proImage,
      'tax_percentage': taxPercentage,
      'price': price,
      'store_id': storeId,
      'status': status,
      'units': units.map((unit) => unit.toJson()).toList(),
    };
  }
}

class Unit {
  final int unit;
  final int id;
  final String name;
  final double price;
  final double minPrice;
  final int stock;

  Unit({
    required this.unit,
    required this.id,
    required this.name,
    required this.price,
    required this.minPrice,
    required this.stock,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unit: json['unit'],
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
      minPrice: double.parse(json['min_price']),
      stock: json['stock'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'unit': unit,
      'id': id,
      'name': name,
      'price': price.toString(),
      'min_price': minPrice.toString(),
      'stock': stock,
    };
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
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
      id: json['id'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}