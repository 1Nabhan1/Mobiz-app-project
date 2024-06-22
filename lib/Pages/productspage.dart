import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Models/appstate.dart';
import '../Models/ProductDataModelClass.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import '../Components/commonwidgets.dart';
import '../Models/quantitymodel.dart' as Qty;

class ProductsScreen extends StatefulWidget {
  static const routeName = "/ProductScreen";
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchData = TextEditingController();
  ProductDataModel products = ProductDataModel();
  Qty.QuantityModel qunatityData = Qty.QuantityModel();
  List<Qty.QuantityModel> quantity = [];
  bool _initDone = false;
  bool _nodata = false;
  bool _search = false;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        title: const Text(
          'Products',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonWidgets.verticalSpace(1),
              (_initDone && !_nodata)
                  ? SizedBox(
                      height: SizeConfig.blockSizeVertical * 78,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            CommonWidgets.verticalSpace(1),
                        itemCount: products.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            _productsCard(products.data![index], index),
                      ),
                    )
                  : (_nodata && _initDone)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              CommonWidgets.verticalSpace(3),
                              const Center(
                                child: Text('No Data'),
                              ),
                            ])
                      : Shimmer.fromColors(
                          baseColor:
                              AppConfig.buttonDeactiveColor.withOpacity(0.1),
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
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productsCard(Data data, int index) {
    return Card(
      elevation: 3,
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 90,
        decoration: const BoxDecoration(
          color: AppConfig.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    message: data.name!.toUpperCase(),
                    child: SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 70,
                      child: Text(
                        '${data.code} | ${data.name!}',
                        style: TextStyle(fontSize: AppConfig.textCaption2Size),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = 0;
                          i < quantity[index].result!.data!.length;
                          i++)
                        Text(
                          (i == 0)
                              ? '${quantity[index].result!.data![i].units![0].name!}: ${formatDivisionResult(products.data![index].baseUnitQty!, quantity[index].result!.data![i].qty!, quantity[index].result!.data![i].units![0].name!)}'
                              : (i == 1)
                                  ? '| ${quantity[index].result!.data![i].units![0].name!}: ${formatDivisionResult(products.data![index].secondUnitQty!, quantity[index].result!.data![i].qty!, quantity[index].result!.data![i].units![0].name!)} '
                                  : (i == 2)
                                      ? '| ${quantity[index].result!.data![i].units![0].name!}: ${formatDivisionResult(products.data![index].thirdUnitQty!, quantity[index].result!.data![i].qty!, quantity[index].result!.data![i].units![0].name!)}'
                                      : '| ${quantity[index].result!.data![i].units![0].name!}: ${formatDivisionResult(products.data![index].fourthUnitQty!, quantity[index].result!.data![i].qty!, quantity[index].result!.data![i].units![0].name!)}',
                          style: TextStyle(
                              fontSize: AppConfig.textCaption3Size,
                              fontWeight: AppConfig.headLineWeight),
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
        '/api/get_product?store_id=${AppState().storeId}', AppState().token);

    if (resJson['data'] != null) {
      products = ProductDataModel.fromJson(resJson);

      for (int i = 0; i < products.data!.length; i++) {
        _getQuantity(i, products.data![i].id!);
      }
    } else {
      setState(() {
        _initDone = true;
        _nodata = true;
      });
    }
  }

  Future<void> _getQuantity(int i, int id) async {
    RestDatasource api = RestDatasource();
    dynamic resJson = await api.getDetails(
        '/api/get_van_stock_detail?product_id=$id&van_id=${AppState().vanId}',
        AppState().token); //${AppState().storeId}

    if (resJson['status'] == "success") {
      qunatityData = Qty.QuantityModel.fromJson(resJson);
      quantity.add(qunatityData);
      if (i == products.data!.length - 1) {
        Future.delayed(
          const Duration(seconds: 3),
          () {
            setState(
              () {
                _initDone = true;
              },
            );
          },
        );
      }
    }
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
