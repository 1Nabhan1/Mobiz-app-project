import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/sales_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../Components/commonwidgets.dart';
import '../Models/sales_model.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import 'newvanstockrequests.dart';

class SelectProductsScreen extends StatefulWidget {
  static const routeName = "/SelectProductScreen";

  @override
  _SelectProductsScreenState createState() => _SelectProductsScreenState();
}

class _SelectProductsScreenState extends State<SelectProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _search = true;
  final TextEditingController _searchData = TextEditingController();
  int? id;
  String? name;
  String? code;
  String? payment;

  void addToCart(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItemsvanstock') ?? [];

    // Check if the product is already in cartItems based on product ID or any unique identifier
    bool alreadyExists = cartItems.any((item) {
      Map<String, dynamic> itemMap = jsonDecode(item);
      return itemMap['id'] ==
          product.id; // Adjust 'id' to your product identifier
    });

    if (!alreadyExists) {
      cartItems.add(jsonEncode(product.toJson()));
      await prefs.setStringList('cartItemsvanstock', cartItems);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} added')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} already in cart')),
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

    try {
      final productData = await fetchProducts(_currentPage);
      setState(() {
        _products.addAll(productData.data.products);
        _filteredProducts = List.from(_products);
        _currentPage++;
        _hasMore = _currentPage <= productData.data.lastPage;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = List.from(_products);
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_product_with_van_stock_for_search?store_id=${AppState().storeId}&value=${Uri.encodeComponent(query)}',
      ));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<Product> products = (jsonResponse['data'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        setState(() {
          _filteredProducts = products;
          _hasMore = false; // Assuming the search is not paginated
        });
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      name = params!['name'];
      code = params!['code'];
      payment = params!['paymentTerms'];
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
          : _products.isEmpty
              ? Center(
                  child: Text(
                      'No products found'), // Show message when no data after loading
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        addToCart(product);
                        Navigator.pushReplacementNamed(
                          context,
                          VanStocks.routeName,
                        );
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
                                      )
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
        '${RestDatasource().BASE_URL}/api/get_product_with_van_stock?store_id=${AppState().storeId}&van_id=${AppState().vanId}&page=$page'));

    if (response.statusCode == 200) {
      return ProductDataModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
