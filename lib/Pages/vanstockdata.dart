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
  List<Product> _products1 = [];
  List<Product> _filteredProducts = [];
  List<Product> _filteredProducts1 = [];

  late TabController _tabController;
  // VanStockData _filteredProducts = VanStockData();
  // VanStockData _filteredProducts1 = VanStockData();
  Qty.VanStockQuandity qunatityData = Qty.VanStockQuandity();
  bool _initDone = false;
  bool _noData = false;
  List<int> selectedItems = [];
  List<Map<String, dynamic>> items = [];
  bool _search = false;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  @override
  void initState() {
    super.initState();
    // _getreturn();
    _fetchProducts();
    _fetchreturn();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          _hasMore &&
          !_isLoading) {}
    });
    _tabController = TabController(length: 2, vsync: this);
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
        final productData = await _getProducts(_currentPage);

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

  Future<void> _fetchreturn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final productData = await _getreturn(_currentPage);
      setState(() {
        _products1.addAll(productData.data.products);
        _filteredProducts1 = List.from(_products1);
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

    if (_filteredProducts.isEmpty && _hasMore) {
      await _fetchProducts();
      _searchProducts(query); // Re-run the search after fetching more products
    }
  }
  // void _searchProducts(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       _filteredProducts = List.from(_products);
  //     } else {
  //       _filteredProducts = _products
  //           .where((product) =>
  //               product.name!.toLowerCase().contains(query.toLowerCase()) ||
  //               product.code!.toLowerCase().contains(query.toLowerCase()))
  //           .toList();
  //     }
  //     if (query.isEmpty) {
  //       _filteredProducts1 = List.from(_products1);
  //     } else {
  //       _filteredProducts1 = _products1
  //           .where((product) =>
  //               product.name!.toLowerCase().contains(query.toLowerCase()) ||
  //               product.code!.toLowerCase().contains(query.toLowerCase()))
  //           .toList();
  //     }
  //   });
  // }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchData.dispose();

    super.dispose();
  }

  // void _filterProducts(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       _filteredProducts = products;
  //       _filteredProducts1 = products1;
  //     } else {
  //       _filteredProducts.result!.data = products.result!.data!.where((item) {
  //         return item.name!.toLowerCase().contains(query.toLowerCase()) ||
  //             item.code!.toLowerCase().contains(query.toLowerCase());
  //       }).toList();
  //       _filteredProducts1.result!.data = products1.result!.data!.where((item) {
  //         return item.name!.toLowerCase().contains(query.toLowerCase()) ||
  //             item.code!.toLowerCase().contains(query.toLowerCase());
  //       }).toList();
  //     }
  //   });
  // }

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
                // onChanged: _filterProducts,
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
                            _isLoading && _products.isEmpty
                                ? Shimmer.fromColors(
                              baseColor: AppConfig.buttonDeactiveColor
                                  .withOpacity(0.1),
                              highlightColor: AppConfig.backButtonColor,
                              child: Center(
                                child: Column(
                                  children: [
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                  ],
                                ),
                              ),
                            )
                                : _filteredProducts.isEmpty
                                ? Center(
                              child: Text(
                                  'No products found'), // Show message when no data after loading
                            )
                                : Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _filteredProducts.length +
                                    (_hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _filteredProducts.length) {
                                    return SizedBox.shrink();
                                  }
                                  final product =
                                  _filteredProducts[index];
                                  return Card(
                                    elevation: 3,
                                    child: Container(
                                      width:
                                      SizeConfig.blockSizeHorizontal *
                                          90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                            // selectedItems.contains(index)
                                            //     ? AppConfig.colorPrimary
                                            //     :
                                            Colors.transparent),
                                        color: AppConfig.backgroundColor,
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
                                                BorderRadius.circular(
                                                    15.0),
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
                                            CommonWidgets.horizontalSpace(
                                                3),
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
                                                          fontSize: AppConfig
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
                            _isLoading && _filteredProducts1.isEmpty
                                ? Shimmer.fromColors(
                              baseColor: AppConfig.buttonDeactiveColor
                                  .withOpacity(0.1),
                              highlightColor: AppConfig.backButtonColor,
                              child: Center(
                                child: Column(
                                  children: [
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                    CommonWidgets.loadingContainers(
                                        height:
                                        SizeConfig.blockSizeVertical * 10,
                                        width:
                                        SizeConfig.blockSizeHorizontal *
                                            90),
                                  ],
                                ),
                              ),
                            )
                                : _filteredProducts1.isEmpty
                                ? Center(
                              child: Text(
                                  'No products found'), // Show message when no data after loading
                            )
                                : Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _filteredProducts1.length +
                                    (_hasMore ? 1 : 0),
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
                                      width:
                                      SizeConfig.blockSizeHorizontal *
                                          90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                            // selectedItems.contains(index)
                                            //     ? AppConfig.colorPrimary
                                            //     :
                                            Colors.transparent),
                                        color: AppConfig.backgroundColor,
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
                                                BorderRadius.circular(
                                                    15.0),
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
                                            CommonWidgets.horizontalSpace(
                                                3),
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
                                                          fontSize: AppConfig
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
                  ))
            ],
          ),
        ));
  }

  // Widget _productsCard(Data data, int index) {
  //   return Card(
  //     elevation: 3,
  //     child: Container(
  //       width: SizeConfig.blockSizeHorizontal * 90,
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //             color: selectedItems.contains(index)
  //                 ? AppConfig.colorPrimary
  //                 : Colors.transparent),
  //         color: AppConfig.backgroundColor,
  //         borderRadius: const BorderRadius.all(
  //           Radius.circular(10),
  //         ),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(5.0),
  //         child: Row(
  //           children: [
  //             SizedBox(
  //               width: 50,
  //               height: 50,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(15.0),
  //                 child: FadeInImage(
  //                   image: NetworkImage(
  //                       'https://mobiz-shop.yes45.in/uploads/product/${data.proImage}'),
  //                   placeholder: const AssetImage('Assets/Images/no_image.jpg'),
  //                   imageErrorBuilder: (context, error, stackTrace) {
  //                     return Image.asset('Assets/Images/no_image.jpg',
  //                         fit: BoxFit.fitWidth);
  //                   },
  //                   fit: BoxFit.fitWidth,
  //                 ),
  //               ),
  //             ),
  //             CommonWidgets.horizontalSpace(3),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Tooltip(
  //                   message: (data.name ?? '').toUpperCase(),
  //                   child: SizedBox(
  //                     width: SizeConfig.blockSizeHorizontal * 70,
  //                     child: Text(
  //                       '${data.code} | ${(data.name ?? '').toUpperCase()}',
  //                       style: TextStyle(
  //                         fontSize: AppConfig.textCaption2Size,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     for (int i = data.productDetail!.length - 1; i >= 0; i--)
  //                       Text(
  //                         '${data.productDetail![i].name}:${data.productDetail![i].stock} ', //${formatDivisionResult(products.result!.data![0].quandity!, qunatityData.result!.data![i].qty!, '')} ',
  //                         style: TextStyle(
  //                           fontSize: AppConfig.textCaption3Size,
  //                         ),
  //                       ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _getProducts() async {
  //   RestDatasource api = RestDatasource();
  //   dynamic resJson = await api.getDetails(
  //       '/api/get_van_stock?store_id=${AppState().storeId}&van_id=${AppState().vanId}',
  //       AppState().token); //${AppState().storeId}
  //
  //   if (resJson['result']['data'] != null &&
  //       resJson['result']['data'].isNotEmpty) {
  //     products = VanStockData.fromJson(resJson);
  //     _getQuantity();
  //   } else {
  //     setState(() {
  //       _initDone = true;
  //       _noData = true;
  //     });
  //   }
  // }
  Future<ProductDataModel> _getProducts(int page) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_van_stock?store_id=${AppState().storeId}&van_id=${AppState().vanId}&page=$page'));

    if (response.statusCode == 200) {
      return ProductDataModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ProductDataModel> _getreturn(int page) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_van_stock_return?store_id=${AppState().storeId}&van_id=${AppState().vanId}&page=$page'));

    if (response.statusCode == 200) {
      return ProductDataModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
  //
  // Future<void> _getreturn() async {
  //   RestDatasource api = RestDatasource();
  //   dynamic resJson = await api.getDetails(
  //       '/api/get_van_stock_return?store_id=${AppState().storeId}&van_id=${AppState().vanId}',
  //       AppState().token); //${AppState().storeId}
  //
  //   if (resJson['result']['data'] != null &&
  //       resJson['result']['data'].isNotEmpty) {
  //     products1 = VanStockData.fromJson(resJson);
  //     _getQuantityreturn();
  //   } else {
  //     setState(() {
  //       _initDone = true;
  //       _noData = true;
  //     });
  //   }
  // }

  // Future<void> _getQuantity() async {
  //   RestDatasource api = RestDatasource();
  //   for (var i in products.result!.data!) {
  //     for (var j in i.productDetail!) {
  //       dynamic resJson = await api.getDetails(
  //           '/api/get_van_stock_detail?product_id=${j.productId}&van_id=${AppState().vanId}&unit=${j.unit}',
  //           AppState().token); //${AppState().storeId}
  //       print('Quan $resJson');
  //       if (resJson['status'] == 'success') {
  //         qunatityData = Qty.VanStockQuandity.fromJson(resJson);
  //         j.stock = (qunatityData.result!.data is List)
  //             ? 0
  //             : qunatityData.result!.data ?? 0;
  //       } else {
  //         if (mounted) {
  //           CommonWidgets.showDialogueBox(
  //               context: context, title: 'Error', msg: 'Something went wrong');
  //         }
  //       }
  //     }
  //   }
  //   setState(() {
  //     _initDone = true;
  //   });
  // }

  // Future<void> _getQuantityreturn() async {
  //   RestDatasource api = RestDatasource();
  //   for (var i in products1.result!.data!) {
  //     for (var j in i.productDetail!) {
  //       dynamic resJson = await api.getDetails(
  //           '/api/get_van_stock_return_detail?product_id=${j.productId}&van_id=${AppState().vanId}&unit=${j.unit}',
  //           AppState().token); //${AppState().storeId}
  //       print('Quan $resJson');
  //       if (resJson['status'] == 'success') {
  //         qunatityData = Qty.VanStockQuandity.fromJson(resJson);
  //         j.stock = (qunatityData.result!.data is List)
  //             ? 0
  //             : qunatityData.result!.data ?? 0;
  //       } else {
  //         if (mounted) {
  //           CommonWidgets.showDialogueBox(
  //               context: context, title: 'Error', msg: 'Something went wrong');
  //         }
  //       }
  //     }
  //   }
  //   setState(() {
  //     _initDone = true;
  //   });
  // }

  void addItem(String name, String code, int id, int quantity) async {
    Map<String, dynamic> newItem = {
      "name": name,
      "code": code,
      "id": id,
      "quantity": quantity
    };

    // Check for duplicates before adding
    bool containsDuplicate = items.any((item) => item['id'] == id);
    if (!containsDuplicate) {
      items.add(newItem);
      await StockHistory.addToStockHistory(newItem);
    }
  }

  // Function to remove an item from the list by id
  void removeItem(int id) {
    items.removeWhere((item) => item['id'] == id);
  }

  String formatDivisionResult(int numerator, int denominator, String name) {
    if (denominator == 0) {
      throw ArgumentError("Denominator cannot be zero.");
    }

    double result = numerator / denominator;

    result = double.parse(result.toStringAsFixed(1));

    int integerPart = result.floor();
    double fractionalPart = result - integerPart;

    int fractionalPartInPieces = (fractionalPart * 10).round();

    if (fractionalPartInPieces != 0) {
      return (integerPart != 0)
          ? "$integerPart $name $fractionalPartInPieces Piece"
          : "$fractionalPartInPieces Piece";
    } else {
      return "$integerPart";
    }
  }
}