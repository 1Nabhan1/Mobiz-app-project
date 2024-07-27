import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../Models/sales_model.dart';
import '../Models/stockData.dart';
import '../Models/vanstockdata.dart';
import '../Models/vanstockquandity.dart' as Qty;
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import '../Components/commonwidgets.dart';

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
  List<Product> _products1 = [];
  List<Product> _filteredProducts1 = [];

  late TabController _tabController;
  Qty.VanStockQuandity qunatityData = Qty.VanStockQuandity();

  bool _search = false;

  final ScrollController _scrollControllerProducts = ScrollController();
  final ScrollController _scrollControllerReturns = ScrollController();

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

    _scrollControllerReturns.addListener(() {
      if (_scrollControllerReturns.position.pixels ==
              _scrollControllerReturns.position.maxScrollExtent &&
          _hasMoreReturns &&
          !_isLoadingReturns) {
        _fetchReturns();
      }
    });

    _tabController = TabController(length: 2, vsync: this);
    _searchData.addListener(() {
      _searchProducts(_searchData.text);
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    List<Product> allProducts = [];

    try {
      while (_hasMoreProducts) {
        final productData = await _getProducts(_currentPageProducts);

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
          _currentPageProducts++;
          _hasMoreProducts = _currentPageProducts <= productData.data.lastPage;
        });
      }
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
      final productData = await _getReturns(_currentPageReturns);
      setState(() {
        _products1.addAll(productData.data.products);
        _filteredProducts1 = List.from(_products1);
        _currentPageReturns++;
        _hasMoreReturns = _currentPageReturns <= productData.data.lastPage;
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
    _scrollControllerReturns.dispose();
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
                          _isLoadingProducts && _products.isEmpty
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
                                        controller: _scrollControllerProducts,
                                        itemCount: _filteredProducts.length +
                                            (_hasMoreProducts ? 1 : 0),
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
                          _isLoadingReturns && _products1.isEmpty
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
                              : _products1.isEmpty
                                  ? Center(
                                      child: Text('No products found'),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        controller: _scrollControllerReturns,
                                        itemCount: _filteredProducts1.length +
                                            (_hasMoreReturns ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          if (index ==
                                              _filteredProducts1.length) {
                                            return SizedBox.shrink();
                                          }
                                          final product =
                                              _filteredProducts1[index];
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
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildListItem(Product product) {
    // Implement the widget to build the list item for each product
    return ListTile(
      title: Text(product.name ?? ''),
      subtitle: Text('Code: ${product.code}'),
      trailing: Text(
          'Stock: ${product.units.isNotEmpty ? product.units[0].stock.toString() : '0'}'),
    );
  }

  Future<ProductDataModel> _getProducts(int page) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_van_stock?store_id=${AppState().storeId}&van_id=${AppState().vanId}&page=$page'));

    if (response.statusCode == 200) {
      return ProductDataModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ProductDataModel> _getReturns(int page) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_van_stock_return?store_id=${AppState().storeId}&van_id=${AppState().vanId}&page=$page'));

    if (response.statusCode == 200) {
      return ProductDataModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
