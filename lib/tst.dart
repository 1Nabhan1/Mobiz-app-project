class ProductDataModel {
  final List<Product> products; // Adjusted to be a list of products directly
  final bool success;
  final List<dynamic> messages;

  ProductDataModel({
    required this.products,
    required this.success,
    required this.messages,
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      products: List<Product>.from(
        json['data'].map((product) => Product.fromJson(product)),
      ),
      success: json['success'] ?? false,
      messages: List<dynamic>.from(json['messages'] ?? []),
    );
  }
}

class Product {
  final int id;
  final String code;
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
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      proImage: json['pro_image'] ?? 'default.jpg', // Default image path
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'pro_image': proImage,
    };
  }
}
