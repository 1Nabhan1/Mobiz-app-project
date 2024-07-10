import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../Models/offload_Model.dart';
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
  VanStockData products = VanStockData();
  VanStockData products1 = VanStockData();
  late TabController _tabController;
  VanStockData _filteredProducts = VanStockData();
  VanStockData _filteredProducts1 = VanStockData();
  Qty.VanStockQuandity qunatityData = Qty.VanStockQuandity();
  bool _initDone = false;
  bool _noData = false;
  List<int> selectedItems = [];
  List<Map<String, dynamic>> items = [];
  bool _search = false;
  @override
  void initState() {
    super.initState();
    _getProducts();
    _getreturn();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = products;
        _filteredProducts1 = products1;
      } else {
        _filteredProducts.result!.data = products.result!.data!.where((item) {
          return item.name!.toLowerCase().contains(query.toLowerCase()) ||
              item.code!.toLowerCase().contains(query.toLowerCase());
        }).toList();
        _filteredProducts1.result!.data = products1.result!.data!.where((item) {
          return item.name!.toLowerCase().contains(query.toLowerCase()) ||
              item.code!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
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
                      controller: _searchData,
                      onChanged: _filterProducts,
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
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: SizedBox(
        //   width: SizeConfig.blockSizeHorizontal * 25,
        //   height: SizeConfig.blockSizeVertical * 5,
        //   child: ElevatedButton(
        //     style: ButtonStyle(
        //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //         RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(20.0),
        //         ),
        //       ),
        //       backgroundColor:
        //           const MaterialStatePropertyAll(AppConfig.colorPrimary),
        //     ),
        //     onPressed: () async {
        //       for (var item in items) {
        //         await StockHistory.addToStockHistory(item);
        //       }
        //       if (mounted) {
        //         Navigator.of(context).pop();
        //       }
        //     },
        //     child: Text(
        //       'ADD',
        //       style: TextStyle(
        //           fontSize: AppConfig.textCaption3Size,
        //           color: AppConfig.backgroundColor,
        //           fontWeight: AppConfig.headLineWeight),
        //     ),
        //   ),
        // ),
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
                        CommonWidgets.verticalSpace(1),
                        (_initDone && !_noData)
                            ? SizedBox(
                                height: SizeConfig.blockSizeVertical * 78,
                                child: ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          CommonWidgets.verticalSpace(1),
                                  itemCount: products.result!.data!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      _productsCard(
                                          products.result!.data![index], index),
                                ),
                              )
                            : (_noData && _initDone)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        CommonWidgets.verticalSpace(3),
                                        const Center(
                                          child: Text('No Data'),
                                        ),
                                      ])
                                : Shimmer.fromColors(
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
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                        ],
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        CommonWidgets.verticalSpace(1),
                        (_initDone && !_noData)
                            ? SizedBox(
                                height: SizeConfig.blockSizeVertical * 78,
                                child: ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          CommonWidgets.verticalSpace(1),
                                  itemCount: products1.result!.data!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      _productsCard(
                                          products1.result!.data![index],
                                          index),
                                ),
                              )
                            : (_noData && _initDone)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        CommonWidgets.verticalSpace(3),
                                        const Center(
                                          child: Text('No Data'),
                                        ),
                                      ])
                                : Shimmer.fromColors(
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
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                          CommonWidgets.loadingContainers(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      10,
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  90),
                                        ],
                                      ),
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

  Widget _productsCard(Data data, int index) {
    return Card(
      elevation: 3,
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 90,
        decoration: BoxDecoration(
          border: Border.all(
              color: selectedItems.contains(index)
                  ? AppConfig.colorPrimary
                  : Colors.transparent),
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
                        'https://mobiz-shop.yes45.in/uploads/product/${data.proImage}'),
                    placeholder: const AssetImage('Assets/Images/no_image.jpg'),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('Assets/Images/no_image.jpg',
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
                    message: (data.name ?? '').toUpperCase(),
                    child: SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 70,
                      child: Text(
                        '${data.code} | ${(data.name ?? '').toUpperCase()}',
                        style: TextStyle(
                          fontSize: AppConfig.textCaption2Size,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = data.productDetail!.length - 1; i >= 0; i--)
                        Text(
                          '${data.productDetail![i].name}:${data.productDetail![i].stock} ', //${formatDivisionResult(products.result!.data![0].quandity!, qunatityData.result!.data![i].qty!, '')} ',
                          style: TextStyle(
                            fontSize: AppConfig.textCaption3Size,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getProducts() async {
    RestDatasource api = RestDatasource();
    dynamic resJson = await api.getDetails(
        '/api/get_van_stock?store_id=${AppState().storeId}&van_id=${AppState().vanId}',
        AppState().token); //${AppState().storeId}

    if (resJson['result']['data'] != null &&
        resJson['result']['data'].isNotEmpty) {
      products = VanStockData.fromJson(resJson);
      _getQuantity();
    } else {
      setState(() {
        _initDone = true;
        _noData = true;
      });
    }
  }

  Future<void> _getreturn() async {
    RestDatasource api = RestDatasource();
    dynamic resJson = await api.getDetails(
        '/api/get_van_stock_return?store_id=${AppState().storeId}&van_id=${AppState().vanId}',
        AppState().token); //${AppState().storeId}

    if (resJson['result']['data'] != null &&
        resJson['result']['data'].isNotEmpty) {
      products1 = VanStockData.fromJson(resJson);
      _getQuantityreturn();
    } else {
      setState(() {
        _initDone = true;
        _noData = true;
      });
    }
  }

  Future<void> _getQuantity() async {
    RestDatasource api = RestDatasource();
    for (var i in products.result!.data!) {
      for (var j in i.productDetail!) {
        dynamic resJson = await api.getDetails(
            '/api/get_van_stock_detail?product_id=${j.productId}&van_id=${AppState().vanId}&unit=${j.unit}',
            AppState().token); //${AppState().storeId}
        print('Quan $resJson');
        if (resJson['status'] == 'success') {
          qunatityData = Qty.VanStockQuandity.fromJson(resJson);
          j.stock = (qunatityData.result!.data is List)
              ? 0
              : qunatityData.result!.data ?? 0;
        } else {
          if (mounted) {
            CommonWidgets.showDialogueBox(
                context: context, title: 'Error', msg: 'Something went wrong');
          }
        }
      }
    }
    setState(() {
      _initDone = true;
    });
  }

  Future<void> _getQuantityreturn() async {
    RestDatasource api = RestDatasource();
    for (var i in products1.result!.data!) {
      for (var j in i.productDetail!) {
        dynamic resJson = await api.getDetails(
            '/api/get_van_stock_return_detail?product_id=${j.productId}&van_id=${AppState().vanId}&unit=${j.unit}',
            AppState().token); //${AppState().storeId}
        print('Quan $resJson');
        if (resJson['status'] == 'success') {
          qunatityData = Qty.VanStockQuandity.fromJson(resJson);
          j.stock = (qunatityData.result!.data is List)
              ? 0
              : qunatityData.result!.data ?? 0;
        } else {
          if (mounted) {
            CommonWidgets.showDialogueBox(
                context: context, title: 'Error', msg: 'Something went wrong');
          }
        }
      }
    }
    setState(() {
      _initDone = true;
    });
  }

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
