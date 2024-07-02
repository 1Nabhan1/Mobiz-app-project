import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchDataScreen extends StatefulWidget {
  @override
  _FetchDataScreenState createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://mobiz-api.yes45.in/api/get_product?store_id=9'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        var productList = responseData['data'] as List;
        products = productList.map((json) => Product.fromJson(json)).toList();

        for (var product in products) {
          await fetchProductQuantity(product);
        }

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchProductQuantity(Product product) async {
    final response = await http.get(Uri.parse('https://mobiz-api.yes45.in/api/get_van_stock_detail?product_id=${product.id}&van_id=9&unit=${product.id}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        setState(() {
          product.quantity = responseData['data'];
        });
      } else {
        throw Exception('Failed to load product quantity');
      }
    } else {
      throw Exception('Failed to load product quantity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              child: ListTile(
                title: Text(product.name),
                subtitle: Text('Price: ${product.price}\nQuantity: ${product.quantity}'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String code;
  final String name;
  final String proImage;
  final int categoryId;
  final int subCategoryId;
  final int brandId;
  final int supplierId;
  final int taxId;
  final double taxPercentage;
  final int taxInclusive;
  final double price;
  final int baseUnitId;
  final int baseUnitQty;
  final String baseUnitDiscount;
  final String? baseUnitBarcode;
  final int baseUnitOpStock;
  final String secondUnitPrice;
  final int secondUnitId;
  final int secondUnitQty;
  final String secondUnitDiscount;
  final String? secondUnitBarcode;
  final String secondUnitOpStock;
  final String thirdUnitPrice;
  final int thirdUnitId;
  final int thirdUnitQty;
  final String thirdUnitDiscount;
  final String? thirdUnitBarcode;
  final String thirdUnitOpStock;
  final String fourthUnitPrice;
  final int fourthUnitId;
  final int fourthUnitQty;
  final String fourthUnitDiscount;
  final int isMultipleUnit;
  final String fourthUnitOpStock;
  final String? description;
  final int productQty;
  final int storeId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final List<ProductDetail> productDetail;
  int quantity = 0; // Added quantity field

  Product({
    required this.id,
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
    required this.baseUnitBarcode,
    required this.baseUnitOpStock,
    required this.secondUnitPrice,
    required this.secondUnitId,
    required this.secondUnitQty,
    required this.secondUnitDiscount,
    required this.secondUnitBarcode,
    required this.secondUnitOpStock,
    required this.thirdUnitPrice,
    required this.thirdUnitId,
    required this.thirdUnitQty,
    required this.thirdUnitDiscount,
    required this.thirdUnitBarcode,
    required this.thirdUnitOpStock,
    required this.fourthUnitPrice,
    required this.fourthUnitId,
    required this.fourthUnitQty,
    required this.fourthUnitDiscount,
    required this.isMultipleUnit,
    required this.fourthUnitOpStock,
    required this.description,
    required this.productQty,
    required this.storeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.productDetail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse product detail list
    var productDetailList = json['product_detail'] as List?;
    List<ProductDetail> details = productDetailList?.map((detail) => ProductDetail.fromJson(detail)).toList() ?? [];

    return Product(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      proImage: json['pro_image'] ?? '',
      categoryId: json['category_id'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? 0,
      brandId: json['brand_id'] ?? 0,
      supplierId: json['supplier_id'] ?? 0,
      taxId: json['tax_id'] ?? 0,
      taxPercentage: json['tax_percentage']?.toDouble() ?? 0.0,
      taxInclusive: json['tax_inclusive'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0,
      baseUnitId: json['base_unit_id'] ?? 0,
      baseUnitQty: json['base_unit_qty'] ?? 0,
      baseUnitDiscount: json['base_unit_discount'] ?? '',
      baseUnitBarcode: json['base_unit_barcode'],
      baseUnitOpStock: json['base_unit_op_stock'] ?? 0,
      secondUnitPrice: json['second_unit_price'] ?? '',
      secondUnitId: json['second_unit_id'] ?? 0,
      secondUnitQty: json['second_unit_qty'] ?? 0,
      secondUnitDiscount: json['second_unit_discount'] ?? '',
      secondUnitBarcode: json['second_unit_barcode'],
      secondUnitOpStock: json['second_unit_op_stock'] ?? '',
      thirdUnitPrice: json['third_unit_price'] ?? '',
      thirdUnitId: json['third_unit_id'] ?? 0,
      thirdUnitQty: json['third_unit_qty'] ?? 0,
      thirdUnitDiscount: json['third_unit_discount'] ?? '',
      thirdUnitBarcode: json['third_unit_barcode'],
      thirdUnitOpStock: json['third_unit_op_stock'] ?? '',
      fourthUnitPrice: json['fourth_unit_price'] ?? '',
      fourthUnitId: json['fourth_unit_id'] ?? 0,
      fourthUnitQty: json['fourth_unit_qty'] ?? 0,
      fourthUnitDiscount: json['fourth_unit_discount'] ?? '',
      isMultipleUnit: json['is_multiple_unit'] ?? 0,
      fourthUnitOpStock: json['fourth_unit_op_stock'] ?? '',
      description: json['description'],
      productQty: json['product_qty'] ?? 0,
      storeId: json['store_id'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      productDetail: details,
    );
  }
}

class ProductDetail {
  final int productId;
  final int unit;
  final int id;
  final String name;
  final String price;
  final String minPrice;

  ProductDetail({
    required this.productId,
    required this.unit,
    required this.id,
    required this.name,
    required this.price,
    required this.minPrice,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productId: json['product_id'] ?? 0,
      unit: json['unit'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      minPrice: json['min_price'] ?? '',
    );
  }
}
