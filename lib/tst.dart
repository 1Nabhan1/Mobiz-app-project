import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'Components/commonwidgets.dart';
import 'confg/appconfig.dart';
import 'confg/sizeconfig.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> _products;
  List<int> selectedItems = [];
  bool _search = false;
  final TextEditingController _searchData = TextEditingController();


  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        title: const Text(
          'Select Products',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
        backgroundColor: AppConfig.colorPrimary,
        actions: [
          (_search)
              ?
          Container(
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 76,
            decoration: BoxDecoration(
              color: AppConfig.colorPrimary,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(color: AppConfig.colorPrimary),
            ),
            child: TextField(
              controller: _searchData,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: "Search...",
                  hintStyle: TextStyle(color: AppConfig.backgroundColor),
                  border: InputBorder.none),
            ),
          )
          : Container(),
          CommonWidgets.horizontalSpace(1),
          GestureDetector(
            onTap: () {
              setState(() {
                _search = !_search;
              });
            },
            child: Icon(
              (!_search) ?
              Icons.search
              : Icons.close,
              size: 30,
              color: AppConfig.backgroundColor,
            ),
          ),
          CommonWidgets.horizontalSpace(3),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: AppConfig.buttonDeactiveColor.withOpacity(0.1),
              highlightColor: AppConfig.backButtonColor,
              child: Center(
                child: Column(
                  children: [
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return FutureBuilder<int>(
                    future: fetchProductQuantity(product.id, 9, product.baseUnitId),
                    builder: (context, quantitySnapshot) {
                      if (quantitySnapshot.connectionState == ConnectionState.waiting) {
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text('Loading quantity...'),
                          ),
                        );
                      } else if (quantitySnapshot.hasError) {
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text('Error loading quantity'),
                          ),
                        );
                      } else if (!quantitySnapshot.hasData) {
                        // If no quantity data available, return an empty container or null
                        return Container();
                      } else {
                        final quantity = quantitySnapshot.data!;
                        return GestureDetector(
                          onTap: () {
                            // Handle onTap action if needed
                          },
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage(
                                    image: NetworkImage(
                                        'https://mobiz-shop.yes45.in/uploads/product/${product.image}'),
                                    placeholder: const AssetImage(
                                        'Assets/Images/no_image.jpg'),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'Assets/Images/no_image.jpg',
                                          fit: BoxFit.fitWidth);
                                    },
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              title: Text(product.name),
                              subtitle:
                              Text('Box: ${product.baseUnitqty} | PCS: $quantity'),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),

            );
          }
        },
      ),
    );
  }

  Future<int> fetchProductQuantity(int productId, int vanId, int unit) async {
    final response = await http.get(Uri.parse(
        'https://mobiz-api.yes45.in/api/get_van_stock_detail?product_id=$productId&van_id=$vanId&unit=$unit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load product quantity');
    }
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
        Uri.parse('https://mobiz-api.yes45.in/api/get_product?store_id=10'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class Product {
  final int id;
  final String code;
  final String name;
  final String image;
  final double price;
  final int baseUnitId;
  final int baseUnitqty;
  final int storeId;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
    required this.price,
    required this.baseUnitId,
    required this.baseUnitqty,
    required this.storeId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      code: json['code'],
      baseUnitqty: json['base_unit_qty'],
      name: json['name'],
      image: json['pro_image'],
      price: (json['price'] as num).toDouble(),
      baseUnitId: json['base_unit_id'],
      storeId: json['store_id'],
    );
  }
}
