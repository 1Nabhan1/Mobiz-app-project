import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/salesscreen.dart';
import 'package:mobizapp/sales_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../Components/commonwidgets.dart';
import '../Models/sales_model.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class SalesSelectProductsScreen extends StatefulWidget {
  static const routeName = "/SalesSelectProductsScreen";

  @override
  _SalesSelectProductsScreenState createState() =>
      _SalesSelectProductsScreenState();
}

class _SalesSelectProductsScreenState extends State<SalesSelectProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _search = false;
  final TextEditingController _searchData = TextEditingController();
  int? id;
  String? name;
  String? code;
  String? payment;

  // void addToCart(Product product) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? cartItems = prefs.getStringList('cartItems') ?? [];
  //
  //   for (var unit in product.units) {
  //     bool alreadyExists = cartItems.any((item) {
  //       Map<String, dynamic> itemMap = jsonDecode(item);
  //       return itemMap['id'] == product.id && itemMap['unitId'] == unit.id;
  //     });
  //
  //     if (!alreadyExists) {
  //       var productUnitMap = product.toJson();
  //       productUnitMap['unitId'] = unit.id; // Add unit id to the product map
  //       cartItems.add(jsonEncode(productUnitMap));
  //       await prefs.setStringList('cartItems', cartItems);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('${product.name} (${unit.name}) added')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text(
  //                 '${product.name} (${unit.name}) is already in the cart')),
  //       );
  //     }
  //   }
  // }

  void addToCart(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItems') ?? [];

    // Count how many instances of the product are already in the cart
    int productCount = cartItems.fold(0, (count, item) {
      Map<String, dynamic> itemMap = jsonDecode(item);
      return itemMap['id'] == product.id ? count + 1 : count;
    });

    // Restriction logic based on the number of units
    if (product.units.length == 1) {
      // Product has only one unit: Allow only one instance in the cart
      if (productCount >= 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} is already in the cart')),
        );
      } else {
        cartItems.add(jsonEncode(product.toJson()));
        await prefs.setStringList('cartItems', cartItems);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} added')),
        );
      }
    } else if (product.units.length == 2) {
      // Product has exactly two units: Allow up to two instances in the cart
      if (productCount >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Only 2 ${product.name} can be added')),
        );
      } else {
        cartItems.add(jsonEncode(product.toJson()));
        await prefs.setStringList('cartItems', cartItems);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} added')),
        );
      }
    } else {
      // For products with more than two units, allow unlimited addition
      cartItems.add(jsonEncode(product.toJson()));
      await prefs.setStringList('cartItems', cartItems);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} added')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMore &&
          !_isLoading) {
        _fetchProducts();
      }
    });

    _searchData.addListener(() {
      _searchProducts(_searchData.text);
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    List<Product> allProducts = [];

    try {
      while (_hasMore) {
        final productData = await fetchProducts(_currentPage);

        // Filter products with non-zero stock
        final filteredProducts = productData.data.products
            .where((product) =>
                product.units.isNotEmpty && product.units[0].stock > 0)
            .toList();

        allProducts.addAll(filteredProducts);

        setState(() {
          _products = allProducts;
          _filteredProducts =
              List.from(_products); // Update filtered products list
          _currentPage++;
          _hasMore = _currentPage <= productData.data.lastPage;
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchProducts(String query) async {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products
            .where((product) =>
                product.units.isNotEmpty &&
                product.units[0].stock >
                    0) // Filter out products with zero stock
            .toList();
      } else {
        _filteredProducts = _products
            .where((product) =>
                (product.name!.toLowerCase().contains(query.toLowerCase()) ||
                    product.code!
                        .toLowerCase()
                        .contains(query.toLowerCase())) &&
                product.units.isNotEmpty &&
                product.units[0].stock >
                    0) // Filter out products with zero stock
            .toList();
      }
    });

    if (_filteredProducts.isEmpty && _hasMore) {
      await _fetchProducts();
      _searchProducts(query); // Re-run the search after fetching more products
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['customerId'];
      name = params['name'];
      code = params['code'];
      payment = params['paymentTerms'];
    }
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
              ? Container(
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
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
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
                if (!_search) {
                  _searchData.clear();
                }
              });
            },
            child: Icon(
              (!_search) ? Icons.search : Icons.close,
              size: 30,
              color: AppConfig.backgroundColor,
            ),
          ),
          CommonWidgets.horizontalSpace(3),
        ],
      ),
      body: _isLoading && _products.isEmpty
          ? Shimmer.fromColors(
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
                  ],
                ),
              ),
            )
          : _filteredProducts.isEmpty
              ? Center(
                  child: Text('No products found'),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredProducts.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _filteredProducts.length) {
                      return SizedBox.shrink();
                    }
                    final product = _filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        addToCart(product);
                        Navigator.pushReplacementNamed(
                            context, SalesScreen.routeName, arguments: {
                          'customerId': id,
                          'name': name,
                          'code': code,
                          'paymentTerms': payment
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 2),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              color: AppConfig.backgroundColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: FadeInImage(
                                        image: NetworkImage(
                                            '${RestDatasource().Product_URL}/uploads/product/${product.proImage}'),
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
                                  CommonWidgets.horizontalSpace(3),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Tooltip(
                                        message: product.name!.toUpperCase(),
                                        child: SizedBox(
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  70,
                                          child: Text(
                                            '${product.code} | ${product.name!.toUpperCase()}',
                                            style: TextStyle(
                                                fontSize:
                                                    AppConfig.textCaption2Size),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            product.units != null &&
                                                    product.units.length > 0
                                                ? '${product.units[0].name}:${product.units[0].stock}'
                                                : '',
                                            style: TextStyle(
                                              fontSize:
                                                  AppConfig.textCaption3Size,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            product.units != null &&
                                                    product.units.length > 1
                                                ? '${product.units[1].name}:${product.units[1].stock}'
                                                : '',
                                            style: TextStyle(
                                              fontSize:
                                                  AppConfig.textCaption3Size,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<ProductDataModel> fetchProducts(int page) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_product_with_van_stock_and_sales?store_id=${AppState().storeId}&van_id=${AppState().vanId}&page=$page'));

    if (response.statusCode == 200) {
      return ProductDataModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
