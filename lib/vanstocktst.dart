import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/saleinvoices.dart';
import 'package:mobizapp/Pages/salesselectproducts.dart';
import 'package:mobizapp/vanstockselactpro_tst.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../Models/sales_model.dart';
import '../Components/commonwidgets.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import 'package:http/http.dart' as http;

import 'Models/offload_Model.dart';
import 'Pages/homepage.dart';

class VanStocksoff extends StatefulWidget {
  static const routeName = "/NewVanStockRequestsoff";
  @override
  _VanStocksoffState createState() => _VanStocksoffState();
}

int? id;

class _VanStocksoffState extends State<VanStocksoff> {
  late Future<Offload> _Offload;
  bool _loaded = false;
  late Future<Offload> _Offloadchange;
  List<Map<String, dynamic>> savedProducts = [];
  final TextEditingController _remarksController = TextEditingController();
  bool _isPercentage = false;
  final TextEditingController _discountData = TextEditingController();
  final TextEditingController _roundoff = TextEditingController();
  double totalAmount = 0.0;
  double roundOffValue = 0.0;
  String _remarksText = "";
  List<ProductType> productTypes = [];
  List<ProductType?> selectedProductTypes = [];
  TextEditingController _searchData = TextEditingController();
  bool _search = false;
  int _ifVat = 1;
  String? name;

  String roundoff = '';
  @override
  void initState() {
    _Offloadchange = fetchDatachange();
    _Offload = fetchData();
    super.initState();
    _loadSavedProducts();
    fetchProductTypes();
  }

  Future<Offload> fetchData() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_sales_return_in_van?store_id=${AppState().storeId}&van_id=${AppState().vanId}'));

    if (response.statusCode == 200) {
      return Offload.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sales return data');
    }
  }

  Future<Offload> fetchDatachange() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_sales_change_in_van?store_id=${AppState().storeId}&van_id=${AppState().vanId}'));

    if (response.statusCode == 200) {
      return Offload.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sales Change data');
    }
  }

  Future<void> _removeProduct(int index) async {
    setState(() {
      savedProducts.removeAt(index);
      // Recalculate total amount
      totalAmount = savedProducts.fold(0.0, (sum, product) {
        final quantity =
            double.tryParse(product['quantity']?.toString() ?? '0') ?? 0.0;
        final amount =
            double.tryParse(product['amount']?.toString() ?? '0') ?? 0.0;
        return sum + (quantity * amount);
      });
    });

    final prefs = await SharedPreferences.getInstance();
    final savedProductsStringList =
        savedProducts.map((product) => jsonEncode(product)).toList();
    await prefs.setStringList('selected_products', savedProductsStringList);
  }

  double calculateTax() {
    double tax = 0;
    for (int index = 0; index < savedProducts.length; index++) {
      String discountValue = _discountData.text.trim();
      double discountAmount = double.tryParse(discountValue) ?? 0;
      double amt = totalAmount - discountAmount;
      double discountfrtax = (totalAmount * discountAmount) / 100;
      double netTotal = totalAmount - discountfrtax;
      num taxPercentage = 5;
      double Tax = _isPercentage
          ? ((netTotal * taxPercentage) / 100)
          : (amt * taxPercentage) / 100;
      tax = Tax;
    }
    return tax;
  }

  Map<String, dynamic> CalculatedValue() {
    double taxamt = calculateTax();
    roundoff = _roundoff.text;
    double rundff = double.tryParse(roundoff) ?? 0;
    String discountValue = _discountData.text.trim();
    double discountAmount = double.tryParse(discountValue) ?? 0;
    double totalTax = 5;
    double discountinpercent = (totalAmount * discountAmount) / 100;
    double nettotal = totalAmount - discountinpercent;
    double taxamtperc = (nettotal * totalTax) / 100;
    double grandTotal = _ifVat == 1
        ? _isPercentage
            ? totalAmount - ((totalAmount * discountAmount) / 100) + taxamtperc
            : (totalAmount - discountAmount) + taxamt
        : _isPercentage
            ? totalAmount - (totalAmount * discountAmount) / 100
            : totalAmount - discountAmount;
    num roundedGrandTotal1 =
        roundoff == '' ? customRound(grandTotal) : grandTotal + rundff;
    double roundOffValue = roundedGrandTotal1 - grandTotal;
    return {
      'rounded': roundedGrandTotal1,
      'roundOffValue': roundOffValue,
    };
  }

  Future<void> _loadSavedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedProductsStringList =
        prefs.getStringList('selected_products');

    if (savedProductsStringList != null) {
      setState(() {
        savedProducts = savedProductsStringList
            .map((productString) =>
                jsonDecode(productString) as Map<String, dynamic>)
            .toList();

        // Calculate total amount
        totalAmount = savedProducts.fold(0.0, (sum, product) {
          final quantity =
              double.tryParse(product['quantity']?.toString() ?? '0') ?? 0.0;
          final amount =
              double.tryParse(product['amount']?.toString() ?? '0') ?? 0.0;
          return sum + (quantity * amount);
        });
      });
    }
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_products');
    setState(() {
      savedProducts.clear();
    });
  }

  Future<void> fetchProductTypes() async {
    try {
      final response = await http
          .get(Uri.parse('${RestDatasource().BASE_URL}/api/get_product_type'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<ProductType> loadedProductTypes = [];

        for (var item in data['data']) {
          loadedProductTypes.add(ProductType.fromJson(item));
        }

        setState(() {
          productTypes = loadedProductTypes;
        });
      } else {
        throw Exception('Failed to load product types');
      }
    } catch (e) {
      print('Error fetching product types: $e');
    }
  }

  int customRound(double value) {
    double fractionalPart = value - value.toInt();

    if (fractionalPart >= 0.5) {
      return value.ceil();
    } else {
      return value.floor();
    }
  }

  Future<void> _onBackPressed() async {
    clearCart();
    // Your custom function logic here
    print('Back button pressed');
    // You can also show a dialog, navigate to another page, etc.
  }

  void _updateCalculations() {
    setState(() {
      totalAmount = savedProducts.fold(0.0, (sum, product) {
        final quantity =
            double.tryParse(product['quantity']?.toString() ?? '0') ?? 0.0;
        final amount =
            double.tryParse(product['amount']?.toString() ?? '0') ?? 0.0;
        return sum + (quantity * amount);
      });
      // Update other relevant state variables or perform additional actions
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> grandTotalMap = CalculatedValue();

    double tax = _ifVat == 1 ? calculateTax() : 0;
    var roundedGrandTotal = grandTotalMap['rounded'];
    double roundOffValue = grandTotalMap['roundOffValue'];
    double total;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['customerId'];
      name = params['name'];
    }
    Future<void> saveData() async {
      List<int> productIds = savedProducts.map<int>((product) {
        return product['id'];
      }).toList();
      List<double> quantity = savedProducts.map<double>((product) {
        return double.parse(product['quantity'].toString());
      }).toList();
      List<int> unitIds = savedProducts.map<int>((product) {
        // Assuming product['unit_id'] already contains the selected unit ID
        return int.parse(product['unit_id']);
      }).toList();
      final url =
          Uri.parse('${RestDatasource().BASE_URL}/api/vanoffloadrequest.store');
      final headers = {"Content-Type": "application/json"};

      final body = jsonEncode({
        "van_id": AppState().vanId,
        "store_id": AppState().storeId,
        "user_id": AppState().userId,
        "item_id": productIds,
        "quantity": quantity,
        "unit": unitIds,
        "goods_return_id": savedProducts.map((item) => 1).toList(),
        "return_type": savedProducts.map((item) => 1).toList(),
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print(response.body);
        // print('ggggggggggggggggggggggggggggggggg');
        if (mounted) {
          CommonWidgets.showDialogueBox(
              context: context, title: "Alert", msg: "Added Successfully");
          // StockHistory.clearAllStockHistory().then(
          //         (value) =>
          Navigator.of(context).pushNamed(HomeScreen.routeName);
          clearCart();
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save data')));
      }
    }

    return WillPopScope(
      onWillPop: () async {
        // Call your custom function here
        await _onBackPressed();
        // Return true to allow the page to be popped
        // Return false to prevent the page from being popped
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // clearSharedPreferences();
                clearCart();
              },
              child: Icon(Icons.arrow_back_rounded)),
          iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
          title: const Text(
            'Off Load Request',
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
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: AppConfig.backgroundColor),
                        border: InputBorder.none,
                      ),
                    ),
                  )
                : Container(),
            CommonWidgets.horizontalSpace(1),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, SelectProductsScreenoff.routeName,
                    arguments: {'customerId': id, 'name': name}).then((value) {
                  // _initDone = false;
                  // _getTypes();
                });
              },
              child: Icon(
                _search ? Icons.close : Icons.search,
                size: 30,
                color: AppConfig.backgroundColor,
              ),
            ),
            CommonWidgets.horizontalSpace(3),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: 100.w,
          height: 30.h,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              backgroundColor: (savedProducts.isNotEmpty)
                  ? const WidgetStatePropertyAll(AppConfig.colorPrimary)
                  : const WidgetStatePropertyAll(AppConfig.buttonDeactiveColor),
            ),
            onPressed: (savedProducts.isNotEmpty)
                ? () async {
                    setState(() {
                      _loaded == false ? null : saveData();
                    });
                    // print(roundOffValue);
                  }
                : null,
            child: Text(
              'SAVE',
              style: TextStyle(
                  fontSize: AppConfig.textCaption3Size,
                  color: AppConfig.backgroundColor,
                  fontWeight: AppConfig.headLineWeight),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              savedProducts.isEmpty
                  ? Center(child: Text('No saved products'))
                  : Column(
                      children: [
                        // AppState().vatState != 'Disable'
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         (name ?? '').toUpperCase(),
                        //         style: TextStyle(
                        //           fontSize: AppConfig.textCaption3Size,
                        //           color: AppConfig.buttonDeactiveColor,
                        //         ),
                        //       ),
                        //       const Spacer(),
                        //       AppState().vatState != 'Disable'
                        //           ? Row(
                        //               children: [
                        //                 InkWell(
                        //                   onTap: () {
                        //                     setState(() {
                        //                       _ifVat = 1;
                        //                     });
                        //                     total = 0;
                        //                     tax = 0;
                        //                     // _calculateTotal();
                        //                   },
                        //                   child: Container(
                        //                     decoration: BoxDecoration(
                        //                         border:
                        //                             Border.all(color: Colors.black),
                        //                         color: (_ifVat == 1)
                        //                             ? AppConfig.colorPrimary
                        //                             : AppConfig.backButtonColor,
                        //                         borderRadius: const BorderRadius.only(
                        //                             topLeft: Radius.circular(3),
                        //                             bottomLeft: Radius.circular(3))),
                        //                     width:
                        //                         SizeConfig.blockSizeHorizontal * 13,
                        //                     height: SizeConfig.blockSizeVertical * 3,
                        //                     child: Center(
                        //                       child: Text(
                        //                         'VAT',
                        //                         style: TextStyle(
                        //                           fontSize:
                        //                               AppConfig.textCaption3Size,
                        //                           color: (_ifVat == 1)
                        //                               ? AppConfig.backButtonColor
                        //                               : AppConfig.textBlack,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 InkWell(
                        //                   onTap: () {
                        //                     setState(() {
                        //                       _ifVat = 0;
                        //                     });
                        //                     total = 0;
                        //                     tax = 0;
                        //                     // _calculateTotal();
                        //                   },
                        //                   child: Container(
                        //                     decoration: BoxDecoration(
                        //                         border:
                        //                             Border.all(color: Colors.black),
                        //                         color: (_ifVat == 0)
                        //                             ? AppConfig.colorPrimary
                        //                             : AppConfig.backButtonColor,
                        //                         borderRadius: const BorderRadius.only(
                        //                             topRight: Radius.circular(3),
                        //                             bottomRight: Radius.circular(3))),
                        //                     width:
                        //                         SizeConfig.blockSizeHorizontal * 13,
                        //                     height: SizeConfig.blockSizeVertical * 3,
                        //                     child: Center(
                        //                       child: Text(
                        //                         'NO VAT',
                        //                         style: TextStyle(
                        //                           fontSize:
                        //                               AppConfig.textCaption3Size,
                        //                           color: (_ifVat == 0)
                        //                               ? AppConfig.backButtonColor
                        //                               : AppConfig.textBlack,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             )
                        //           : SizedBox.shrink()
                        //     ],
                        //   ),
                        // ),
                        ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: savedProducts.length,
                          itemBuilder: (context, index) {
                            _loaded = true;
                            final product = savedProducts[index];
                            final quantity = double.tryParse(
                                    product['quantity']?.toString() ?? '0') ??
                                0.0;
                            final amount = double.tryParse(
                                    product['amount']?.toString() ?? '0') ??
                                0.0;

                            final total = quantity * amount;
                            return InkWell(
                              onTap: () =>
                                  showProductDetailsDialog(context, product),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0.w, vertical: 2.h),
                                child: Card(
                                  elevation: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    width: SizeConfig.blockSizeHorizontal * 90,
                                    // height: 50.h,
                                    decoration: BoxDecoration(
                                      color: AppConfig.backgroundColor,
                                      border: Border.all(
                                        color: AppConfig.buttonDeactiveColor
                                            .withOpacity(0.5),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // SizedBox(
                                              //   width: 50,
                                              //   height: 60,
                                              //   child: ClipRRect(
                                              //     borderRadius: BorderRadius.circular(10),
                                              //     child: FadeInImage(
                                              //       image: NetworkImage(
                                              //         '${RestDatasource().Product_URL}/uploads/product/${product['proImage']}',
                                              //       ),
                                              //       placeholder: const AssetImage(
                                              //           'Assets/Images/no_image.jpg'),
                                              //       imageErrorBuilder:
                                              //           (context, error, stackTrace) {
                                              //         return Image.asset(
                                              //           'Assets/Images/no_image.jpg',
                                              //           fit: BoxFit.fitWidth,
                                              //         );
                                              //       },
                                              //       fit: BoxFit.fitWidth,
                                              //     ),
                                              //   ),
                                              // ),
                                              // CommonWidgets.horizontalSpace(1),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${product['code']} | ${product['name'].toString().toUpperCase()}',
                                                      style: TextStyle(
                                                          fontSize: AppConfig
                                                              .textCaption3Size,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircleAvatar(
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.2),
                                                radius: 10,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _removeProduct(index),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 15,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              Text(product['type_name']),
                                              Text(' | '),
                                              Text(product['unit_name']),
                                              Text(' | '),
                                              Text(
                                                  'Qty: ${product['quantity']}'),
                                              // Text(' | '),
                                              // Text('Rate: ${product['amount']}'),
                                              // Text(' | '),
                                              // Text(
                                              //     'Amt: ${total.toStringAsFixed(2)}')
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
              FutureBuilder<Offload>(
                future: _Offload,
                builder: (context, AsyncSnapshot<Offload> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Loading state
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
                    // Error state
                    return Center(
                      child: Text('Error occurred: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    // No data state
                    return Center(
                      child: Text(''),
                    );
                  } else {
                    _loaded = true;
                    // Data loaded successfully
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'Return',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.data.length,
                            itemBuilder: (context, index) {
                              final salesReturnItem =
                                  snapshot.data!.data[index];
                              // Add your logic here to build each item in the list
                              return Container(
                                width: SizeConfig.blockSizeHorizontal * 90,
                                child: Card(
                                  color: AppConfig.backgroundColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 60,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: FadeInImage(
                                                  image: NetworkImage(
                                                    '${RestDatasource().Product_URL}/uploads/product/${salesReturnItem.product.first.proImage}',
                                                  ),
                                                  placeholder: AssetImage(
                                                    'Assets/Images/no_image.jpg',
                                                  ),
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                      'Assets/Images/no_image.jpg',
                                                      fit: BoxFit.fitWidth,
                                                    );
                                                  },
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            CommonWidgets.horizontalSpace(1),
                                            Flexible(
                                              child: Text(
                                                '${salesReturnItem.product.first.code} | ${salesReturnItem.product.first.name}',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Text(
                                              '${salesReturnItem.returntype[0].name} | ${salesReturnItem.units[0].name} | Qty: ${salesReturnItem.quantity} ',
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
                    );
                  }
                },
              ),
              FutureBuilder<Offload>(
                future: _Offloadchange,
                builder: (context, AsyncSnapshot<Offload> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Loading state
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
                    // Error state
                    return Center(
                      child: Text('Error occurred: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    // No data state
                    return Center(
                      child: Text(''),
                    );
                  } else {
                    _loaded = true;
                    // Data loaded successfully
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Text(
                                'Change',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.data.length,
                            itemBuilder: (context, index) {
                              final salesReturnItem =
                                  snapshot.data!.data[index];
                              // Add your logic here to build each item in the list
                              return Container(
                                width: SizeConfig.blockSizeHorizontal * 90,
                                child: Card(
                                  color: AppConfig.backgroundColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 60,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: FadeInImage(
                                                  image: NetworkImage(
                                                    '${RestDatasource().Product_URL}/uploads/product/${salesReturnItem.product.first.proImage}',
                                                  ),
                                                  placeholder: AssetImage(
                                                    'Assets/Images/no_image.jpg',
                                                  ),
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                      'Assets/Images/no_image.jpg',
                                                      fit: BoxFit.fitWidth,
                                                    );
                                                  },
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            CommonWidgets.horizontalSpace(1),
                                            Flexible(
                                              child: Text(
                                                '${salesReturnItem.product.first.code} | ${salesReturnItem.product.first.name}',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Text(
                                              '${salesReturnItem.returntype[0].name} | ${salesReturnItem.units[0].name} | Qty: ${salesReturnItem.quantity} ',
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
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showProductDetailsDialog(
      BuildContext context, Map<String, dynamic> product) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_product_with_units_by_products?store_id=${AppState().storeId}&van_id=${AppState().vanId}&id=${product['id']}'));
    final typeResponse = await http
        .get(Uri.parse('${RestDatasource().BASE_URL}/api/get_product_type'));

    if (response.statusCode == 200 && typeResponse.statusCode == 200) {
      final data = jsonDecode(response.body);
      final units = data['data'] as List?;
      final lastsale = data['lastsale'];
      final typeData = jsonDecode(typeResponse.body);
      final productTypes = typeData['data'] as List;
      final amountController = TextEditingController();
      final existingProduct = savedProducts
          .firstWhere((p) => p['serial_number'] == product['serial_number']);
      String? amount = existingProduct['amount'];
      if (amount != null && amount.isNotEmpty) {
        amountController.text = amount;
      }
      double? availableStock;
      String? selectedUnitId = existingProduct['unit_id'];
      String? selectedProductTypeId = existingProduct['type_id'];
      String? quantity = existingProduct['quantity'];
      bool isQuantityValid(String? value) {
        final quantityValue = double.tryParse(value ?? '') ?? 0;
        return value != null &&
            value.isNotEmpty &&
            quantityValue > 0 &&
            quantityValue <= (availableStock ?? 0);
      }

      Map<String, dynamic>? selectedUnit;

      if (selectedUnitId != null && units != null) {
        selectedUnit = units.firstWhere(
            (unit) => unit['id'].toString() == selectedUnitId,
            orElse: () => null);
        availableStock =
            double.tryParse(selectedUnit?['stock']?.toString() ?? '0');
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text('${product['code']} | ${product['name']}'),
                content: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(
                              '${RestDatasource().Product_URL}/uploads/product/${product['proImage']}',
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('Assets/Images/no_image.jpg',
                                    height: 100);
                              },
                            ),
                            // lastsale == null || lastsale.isEmpty
                            //     ? Text('No last records found')
                            //     : Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             'Last Sale:',
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //           Text('Date: ${lastsale['date']}'),
                            //           Text('Unit: ${lastsale['unit']}'),
                            //           Text('Price: ${lastsale['price']}'),
                            //         ],
                            //       ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        if (selectedUnit != null) ...[
                          Text(
                            'Available Qty: ${selectedUnit!['stock']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                        if (units != null &&
                            units.any((unit) => unit != null)) ...[
                          // SizedBox(height: 10.h),
                          // DropdownButtonFormField<String>(
                          //   decoration: InputDecoration(
                          //     labelText: 'Product Type',
                          //     labelStyle:
                          //         TextStyle(fontWeight: FontWeight.bold),
                          //     contentPadding: EdgeInsets.symmetric(
                          //         vertical: 2.h, horizontal: 10.w),
                          //     border: OutlineInputBorder(
                          //         borderSide: BorderSide.none),
                          //     filled: true,
                          //     fillColor: Colors.grey.shade300,
                          //   ),
                          //   items: productTypes.map((type) {
                          //     return DropdownMenuItem<String>(
                          //       value: type['id'].toString(),
                          //       child: Text(type['name']),
                          //     );
                          //   }).toList(),
                          //   onChanged: (value) {
                          //     setDialogState(() {
                          //       selectedProductTypeId = value;
                          //
                          //       // Check if the selected product type is not "Normal"
                          //       final selectedType = productTypes.firstWhere(
                          //         (type) => type['id'].toString() == value,
                          //         orElse: () => null,
                          //       );
                          //
                          //       if (selectedType != null &&
                          //           selectedType['name'] != 'Normal') {
                          //         // Set amount to 0 if type is not "Normal"
                          //         amountController.text = '0';
                          //       } else if (selectedUnit != null) {
                          //         // Set amount to the selected unit's price if type is "Normal"
                          //         amountController.text =
                          //             selectedUnit?['price']?.toString() ?? '';
                          //       }
                          //     });
                          //   },
                          //   value: selectedProductTypeId,
                          //   hint: Text('Select Product Type'),
                          // ),
                          SizedBox(height: 10.h),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Unit',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 10.w),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.shade300,
                            ),
                            items:
                                units.where((unit) => unit != null).map((unit) {
                              return DropdownMenuItem<String>(
                                value: unit['id'].toString(),
                                child: Text(unit['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedUnitId = value;
                                selectedUnit = units.firstWhere(
                                    (unit) => unit['id'].toString() == value,
                                    orElse: () => null);
                                amountController.text =
                                    selectedUnit?['price']?.toString() ?? '';
                                availableStock = double.tryParse(
                                    selectedUnit?['stock']?.toString() ?? '0');
                              });
                            },
                            value: selectedUnitId,
                            hint: Text('Select Unit'),
                          ),
                          // SizedBox(height: 10.h),
                          // TextFormField(
                          //   keyboardType: TextInputType.number,
                          //   // initialValue: amount,
                          //   controller: amountController,
                          //   // onChanged: (value) {
                          //   //   amount = amount;
                          //   // },
                          //   decoration: InputDecoration(
                          //       labelText: 'Amount',
                          //       labelStyle:
                          //           TextStyle(fontWeight: FontWeight.bold),
                          //       contentPadding: EdgeInsets.symmetric(
                          //           vertical: 2.h, horizontal: 10.w),
                          //       hintText: 'Amt',
                          //       border: OutlineInputBorder(
                          //           borderSide: BorderSide.none),
                          //       filled: true,
                          //       fillColor: Colors.grey.shade300),
                          // ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: quantity,
                            onChanged: (value) {
                              quantity = value;
                              setDialogState(() {});
                            },
                            decoration: InputDecoration(
                                labelText: 'Quantity',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 10.w),
                                hintText: 'Qty',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey.shade300),
                          ),
                          SizedBox(height: 10),
                        ] else ...[
                          Text('No units available for this product.'),
                        ],
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppConfig.colorPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r))),
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  if (units != null && units.any((unit) => unit != null)) ...[
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: isQuantityValid(quantity)
                              ? AppConfig.colorPrimary
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r))),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: isQuantityValid(quantity)
                          ? () async {
                              if (selectedUnitId != null &&
                                  selectedProductTypeId != null &&
                                  quantity != null &&
                                  amountController.text != null) {
                                final productIndex = savedProducts.indexWhere(
                                    (p) =>
                                        p['serial_number'] ==
                                        product['serial_number']);
                                if (productIndex != -1) {
                                  setState(() {
                                    savedProducts[productIndex]['unit_id'] =
                                        selectedUnitId;
                                    savedProducts[productIndex]['type_id'] =
                                        selectedProductTypeId;
                                    savedProducts[productIndex]['quantity'] =
                                        quantity;
                                    savedProducts[productIndex]['amount'] =
                                        amountController.text;
                                    savedProducts[productIndex]['type_name'] =
                                        productTypes.firstWhere((type) =>
                                            type['id'].toString() ==
                                            selectedProductTypeId)['name'];
                                    savedProducts[productIndex]['unit_name'] =
                                        selectedUnit?['name'];
                                    _updateCalculations();
                                  });

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final savedProductsStringList = savedProducts
                                      .map((product) => jsonEncode(product))
                                      .toList();
                                  await prefs.setStringList('selected_products',
                                      savedProductsStringList);

                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          : null,
                    ),
                  ],
                ],
              );
            },
          );
        },
      );
    }
  }
}
