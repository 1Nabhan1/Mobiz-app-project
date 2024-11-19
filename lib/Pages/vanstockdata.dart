import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../Models/appstate.dart';
// import '../Models/sales_model.dart';
import '../Models/stockData.dart';
import '../Models/vanstockdata.dart';
import '../Models/vanstockquandity.dart' as Qty;
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import '../Components/commonwidgets.dart';
import '../Models/VanStockDataModel.dart';


class VanStockScreen extends StatefulWidget {
  static const routeName = "/VanStockScreen";
  const VanStockScreen({super.key});

  @override
  State<VanStockScreen> createState() => _VanStockScreenState();
}

class _VanStockScreenState extends State<VanStockScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchData = TextEditingController();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Product12> _products1 = [];
  List<Product12> _filteredProducts1 = [];

  late TabController _tabController;
  Qty.VanStockQuandity qunatityData = Qty.VanStockQuandity();

  bool _search = false;

  final ScrollController _scrollControllerProducts = ScrollController();
  // final ScrollController _scrollControllerReturns = ScrollController();

  int _currentPageProducts = 1;
  bool _isLoadingProducts = false;
  bool _hasMoreProducts = true;

  int _currentPageReturns = 1;
  bool _isLoadingReturns = false;
  bool _hasMoreReturns = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchReturns();

    _scrollControllerProducts.addListener(() {
      if (_scrollControllerProducts.position.pixels ==
              _scrollControllerProducts.position.maxScrollExtent &&
          _hasMoreProducts &&
          !_isLoadingProducts) {
        _fetchProducts();
      }
    });

    // _scrollControllerReturns.addListener(() {
    //   if (_scrollControllerReturns.position.pixels ==
    //           _scrollControllerReturns.position.maxScrollExtent &&
    //       _hasMoreReturns &&
    //       !_isLoadingReturns) {
    //     _fetchReturns();
    //   }
    // });

    _tabController = TabController(length: 2, vsync: this);
    _searchData.addListener(() {
      _searchProducts(_searchData.text);
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      // Fetch all products in one call
      final productData = await _getProducts();

      // Filter products with non-zero stock
      final filteredProducts = productData.data
          .where((product) =>
      product.units.isNotEmpty && product.units[0].stock > 0)
          .toList();

      // Set the products once
      setState(() {
        _products = filteredProducts;
        _filteredProducts = List.from(_products); // Update filtered products list
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }


  Future<void> _fetchReturns() async {
    setState(() {
      _isLoadingReturns = true;
    });

    try {
       final productData = await _getReturns();
      final filteredProducts1 = productData.products
          .where((product) =>
      product.units.isNotEmpty && product.units[0].stock > 0)
          .toList();
      setState(() {
        _products1=filteredProducts1;
        _filteredProducts1= List.from(_products1);
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoadingReturns = false;
      });
    }
  }



  Future<void> _searchProducts(String query) async {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products
            .where((product) =>
                product.units.isNotEmpty && product.units[0].stock > 0)
            .toList();
      } else {
        _filteredProducts = _products
            .where((product) =>
                (product.name!.toLowerCase().contains(query.toLowerCase()) ||
                    product.code!
                        .toLowerCase()
                        .contains(query.toLowerCase())) &&
                product.units.isNotEmpty &&
                product.units[0].stock > 0)
            .toList();
      }
      if (query.isEmpty) {
        _filteredProducts1 = List.from(_products1);
      } else {
        _filteredProducts1 = _products1
            .where((product) =>
                product.name!.toLowerCase().contains(query.toLowerCase()) ||
                product.code!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollControllerProducts.dispose();
    // _scrollControllerReturns.dispose();
    _searchData.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
          title: const Text(
            'Van Stocks',
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
                          hintStyle:
                              TextStyle(color: AppConfig.backgroundColor),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              TabBar(
                labelStyle: TextStyle(
                    color: AppConfig.backgroundColor,
                    fontWeight: FontWeight.bold),
                padding: EdgeInsets.all(8),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                splashBorderRadius: BorderRadius.circular(10),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppConfig.colorPrimary,
                ),
                controller: _tabController,
                tabs: [
                  Tab(text: 'Stock'),
                  Tab(text: 'Return'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          _isLoadingProducts
                              // && _products.isEmpty
                              ? Shimmer.fromColors(
                                  baseColor: AppConfig.buttonDeactiveColor
                                      .withOpacity(0.1),
                                  highlightColor: AppConfig.backButtonColor,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        CommonWidgets.loadingContainers(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    10,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    90),
                                        CommonWidgets.loadingContainers(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    10,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    90),
                                        CommonWidgets.loadingContainers(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    10,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    90),
                                      ],
                                    ),
                                  ),
                                )
                              : _products.isEmpty
                                  ? Center(
                                      child: Text('No products found'),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        // controller: _scrollControllerProducts,
                                        itemCount: _filteredProducts.length,
                                        itemBuilder: (context, index) {
                                          if (index ==
                                              _filteredProducts.length) {
                                            return SizedBox.shrink();
                                          }
                                          final product =
                                              _filteredProducts[index];
                                          return Card(
                                            elevation: 3,
                                            child: Container(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        // selectedItems.contains(index)
                                                        //     ? AppConfig.colorPrimary
                                                        //     :
                                                        Colors.transparent),
                                                color:
                                                    AppConfig.backgroundColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        child: FadeInImage(
                                                          image: NetworkImage(
                                                              '${RestDatasource().Product_URL}/uploads/product/${product.proImage}'),
                                                          placeholder:
                                                              const AssetImage(
                                                                  'Assets/Images/no_image.jpg'),
                                                          imageErrorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                                'Assets/Images/no_image.jpg',
                                                                fit: BoxFit
                                                                    .fitWidth);
                                                          },
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ),
                                                    ),
                                                    CommonWidgets
                                                        .horizontalSpace(3),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Tooltip(
                                                          message: product.name!
                                                              .toUpperCase(),
                                                          child: SizedBox(
                                                            width: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                70,
                                                            child: Text(
                                                              '${product.code} | ${product.name!.toUpperCase()}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      AppConfig
                                                                          .textCaption2Size),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            // for (int i = data.productDetail!.length - 1;
                                                            //     i >= 0;
                                                            //     i--)
                                                            Text(
                                                              product.units !=
                                                                          null &&
                                                                      product.units
                                                                              .length >
                                                                          0
                                                                  ? '${product.units[0].name}:${product.units[0].stock}'
                                                                  : '',
                                                              style: TextStyle(
                                                                fontSize: AppConfig
                                                                    .textCaption3Size,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              product.units !=
                                                                          null &&
                                                                      product.units
                                                                              .length >
                                                                          1
                                                                  ? '${product.units[1].name}:${product.units[1].stock}'
                                                                  : '',
                                                              style: TextStyle(
                                                                fontSize: AppConfig
                                                                    .textCaption3Size,
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
                                          );
                                        },
                                      ),
                                    ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          _isLoadingReturns
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
                                ],
                              ),
                            ),
                          )
                              : _filteredProducts1.isEmpty
                              ? Center(
                            child: Text(
                                _products1.isEmpty ? 'No products found' : 'No stock found'),
                          )
                              : Expanded(
                            child: ListView.builder(
                              // controller: _scrollControllerReturns,
                              scrollDirection: Axis.vertical,
                              itemCount: _filteredProducts1.length,
                              itemBuilder: (context, index) {
                                if (index ==
                                    _filteredProducts1.length) {
                                  return SizedBox.shrink();
                                }
                                final product = _filteredProducts1[index];
                                return Card(
                                  elevation: 3,
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal * 90,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Tooltip(
                                                message: product.name.toUpperCase(),
                                                child: SizedBox(
                                                  width: SizeConfig.blockSizeHorizontal * 70,
                                                  child: Text(
                                                    '${product.code} | ${product.name.toUpperCase()}',
                                                    style: TextStyle(
                                                        fontSize:
                                                        AppConfig.textCaption2Size),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    product.units.isNotEmpty
                                                        ? '${product.units[0].name}:${product.units[0].stock}'
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize:
                                                      AppConfig.textCaption3Size,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    product.units.length > 1
                                                        ? '${product.units[1].name}:${product.units[1].stock}'
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize:
                                                      AppConfig.textCaption3Size,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        ));
  }

  // Widget _buildListItem(Product product) {
  //   // Implement the widget to build the list item for each product
  //   return ListTile(
  //     title: Text(product.name ?? ''),
  //     subtitle: Text('Code: ${product.code}'),
  //     trailing: Text(
  //         'Stock: ${product.units.isNotEmpty ? product.units[0].stock.toString() : '0'}'),
  //   );
  // }

  Future<ApiResponse> _getProducts() async {
    final response = await http.get(Uri.parse('${RestDatasource().BASE_URL}/api/get_van_stock?store_id=${AppState().storeId}&van_id=${AppState().vanId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ApiResponse apiResponse = ApiResponse.fromJson(data);
      apiResponse.data = apiResponse.data.where((product) {
        return product.units.any((unit) => unit.stock > 0);
      }).toList();

      return apiResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<VanStockReturnResponse> _getReturns() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_van_stock_return?store_id=${AppState().storeId}&van_id=${AppState().vanId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      VanStockReturnResponse apiResponse = VanStockReturnResponse.fromJson(data);
      // Return products without filtering (filtering is handled in _fetchReturns)
      return apiResponse;
    } else {
      throw Exception('Failed to load products');
    }
  }

}

class ApiResponse {
  List<Product> data;
  bool success;
  List<String> messages;

  ApiResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      // Correctly mapping the data to a List<Product>
      data: List<Product>.from(json['data'].map((x) => Product.fromJson(x)).toList()),
      success: json['success'],
      messages: List<String>.from(json['messages']),
    );
  }
}


class Product {
  int id;
  String code;
  String name;
  String proImage;
  double taxPercentage;
  double price;
  int storeId;
  int status;
  List<Unit> units;

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
      taxPercentage: json['tax_percentage'].toDouble(),
      price: json['price'].toDouble(),
      storeId: json['store_id'],
      status: json['status'],
      units: List<Unit>.from(json['units'].map((x) => Unit.fromJson(x))),
    );
  }
}

class Unit {
  int unit;
  int id;
  String name;
  double price;
  double minPrice;
  int stock;

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
}


