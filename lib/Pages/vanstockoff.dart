import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobizapp/Pages/homepage.dart';
import 'package:mobizapp/Pages/selectProductScreenOFF.dart';
import 'package:mobizapp/Pages/selectProducts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../Components/commonwidgets.dart';
import '../Models/appstate.dart';
import '../Models/offload_Model.dart';
import '../Models/sales_model.dart';
import '../Models/stockdata.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class VanStocksoff extends StatefulWidget {
  static const routeName = "/NewVanStockRequestsoff";
  const VanStocksoff({super.key});

  @override
  State<VanStocksoff> createState() => _VanStocksoffState();
}

class _VanStocksoffState extends State<VanStocksoff> {
  final TextEditingController _searchData = TextEditingController();
  bool _initDone = false;
  List<Map<String, dynamic>> stocks = [];
  bool _search = false;
  List<String?> selectedValue = [" ", " "];
  List<List<DropdownMenuItem<String>>> menuItems = [[]];
  List<Map<String, dynamic>?> selectedId = [];
  bool created = false;
  bool _loaded = false;
  late Future<Offload> _Offload;
  late Future<Offload> _Offloadchange;
  final TextEditingController _qty = TextEditingController();
  List<int> itemIds = [];
  List<int> quantities = [];
  List<int> units = [];
  List<int> goodsReturnIds = [];
  List<int> returnTypes = [];
  List<Product> cartItems = [];
  List<ProductType?> selectedProductTypes = [];
  List<ProductType> productTypes = [];
  Map<int, String> amounts = {};
  Map<int, String> qtys = {};
  String amount = '';
  String quantity = '';
  final TextEditingController amountctrl = TextEditingController();

  final TextEditingController qtysctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
    _Offload = fetchData();
    initializeValues();
    _Offloadchange = fetchDatachange();
  }

  Future<void> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItemsoffload');

    if (cartItemsJson != null) {
      List<Product> products = cartItemsJson
          .map((json) => Product.fromJson(jsonDecode(json)))
          .toList();

      setState(() {
        cartItems = products;
        selectedProductTypes = List.generate(
          cartItems.length,
          (index) => null,
        );
      });
    }
  }

  Future<void> removeFromCart(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItemsoffload');

    if (cartItemsJson != null) {
      List<Product> products = cartItemsJson
          .map((json) => Product.fromJson(jsonDecode(json)))
          .toList();

      products.removeAt(index); // Remove the item at the specific index

      List<String> updatedCartItemsJson =
          products.map((product) => jsonEncode(product.toJson())).toList();

      await prefs.setStringList('cartItemsoffload', updatedCartItemsJson);

      fetchCartItems(); // Refresh UI after deletion
    }
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItemsoffload');
    setState(() {
      cartItems.clear();
    });
  }

  Future<void> saveToSharedPreferences(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  Future<void> initializeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Wait until productTypes and cartItems are populated
    setState(() {
      for (int i = 0; i < cartItems.length; i++) {
        qtys[i] = prefs.getString('qtyoff$i') ?? '1';
        amounts[i] =
            prefs.getString('amountoff$i') ?? cartItems[i].price.toString();

        if (cartItems[i].units.isNotEmpty) {
          cartItems[i].selectedUnitName =
              prefs.getString('unitNameoff$i') ?? cartItems[i].units.first.name;
        }

        // for (int i = 0; i < cartItems.length; i++) {
        //   selectedProductTypes[i] = productTypes.firstWhere(
        //     (type) => type.name == prefs.getString('productTypeoff$i'),
        //     orElse: () => productTypes.first,
        //   );
        // }
      }
    });
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        StockHistory.clearAllStockHistory();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                clearSharedPreferences();
              },
              child: Icon(Icons.arrow_back_rounded)),
          iconTheme: const IconThemeData(color: AppConfig.backButtonColor),
          title: const Text('Off Load Request',
              style: TextStyle(color: AppConfig.backButtonColor)),
          backgroundColor: AppConfig.colorPrimary,
          actions: [
            CommonWidgets.horizontalSpace(1),
            GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pushReplacementNamed(
                      context, SelectProductsScreenoff.routeName);
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              cartItems.isEmpty
                  ? Center(
                      child: Text('No items.'),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        _loaded = true;
                        List<String> unitNames = cartItems[index]
                            .units
                            .where((unit) => unit.name != null)
                            .map((unit) => unit.name!)
                            .toList();

                        if (unitNames.isEmpty) {
                          return SizedBox.shrink();
                        }

                        // Ensure each item has its own selected unit name state
                        String? selectedUnitName =
                            cartItems[index].selectedUnitName ??
                                unitNames.first;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 2),
                          child: Card(
                            elevation: 1,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: SizeConfig.blockSizeHorizontal * 90,
                              decoration: BoxDecoration(
                                color: AppConfig.backgroundColor,
                                border: Border.all(
                                  color: AppConfig.buttonDeactiveColor
                                      .withOpacity(0.5),
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 60,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FadeInImage(
                                            image: NetworkImage(
                                              '${RestDatasource().Product_URL}/uploads/product/${cartItems[index].proImage}',
                                            ),
                                            placeholder: const AssetImage(
                                              'Assets/Images/no_image.jpg',
                                            ),
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
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
                                      Column(
                                        children: [
                                          CommonWidgets.verticalSpace(1),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonWidgets.horizontalSpace(1),
                                              SizedBox(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    70,
                                                child: Text(
                                                  '${cartItems[index].code} | ${cartItems[index].name.toString().toUpperCase()}',
                                                  style: TextStyle(
                                                    overflow: TextOverflow.fade,
                                                    fontSize: AppConfig
                                                        .textCaption3Size,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.2),
                                        radius: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            removeFromCart(index);
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            size: 15,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            alignment: Alignment.center,
                                            isExpanded: false,
                                            value: selectedUnitName,
                                            items: unitNames
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Center(
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppConfig
                                                          .colorPrimary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                cartItems[index]
                                                        .selectedUnitName =
                                                    newValue;
                                                saveToSharedPreferences(
                                                    'unitNameoff$index',
                                                    newValue);
                                              });
                                            },
                                            icon: SizedBox.shrink(),
                                          ),
                                        ),
                                      ),
                                      Text(' | '),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Quantity'),
                                                content: TextField(
                                                  controller:
                                                      TextEditingController(
                                                          text: qtys[index]),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      qtys[index] = value;
                                                      saveToSharedPreferences(
                                                          'qtyoff$index',
                                                          value);
                                                    });
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                actions: <Widget>[
                                                  MaterialButton(
                                                    color:
                                                        AppConfig.colorPrimary,
                                                    textColor: Colors.white,
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      quantity = qtysctrl.text;
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Text('Qty: '),
                                            Text(
                                              '${qtys[index] ?? '1'}',
                                              style: TextStyle(
                                                color: AppConfig.colorPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
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
            ],
          ),
        ),
        bottomSheet: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .08,
          color: Colors.white,
          child: Column(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  backgroundColor:
                      const WidgetStatePropertyAll(AppConfig.colorPrimary),
                ),
                onPressed: () {
                  setState(() {
                    _loaded == false ? null : saveData();
                  });

                  // saveData();
                },
                child: Text(
                  'SAVE',
                  style: TextStyle(
                      fontSize: AppConfig.textCaption3Size,
                      color: AppConfig.backgroundColor,
                      fontWeight: AppConfig.headLineWeight),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  // Future<void> _sendProducts() async {
  //   RestDatasource api = RestDatasource();
  //   dynamic bodyJson = {
  //     "van_id": AppState().vanId,
  //     "store_id": AppState().storeId,
  //     "user_id": AppState().userId,
  //     "item_id": cartItems[0].id,
  //     "quantity": ['100'],
  //     "unit": cartItems[0].units,
  //     "goods_return_id": ['1'],
  //     "return_type": ['1']
  //   };
  //   int units = 0;
  //   for (int i = 0; i < stocks.length; i++) {
  //     for (var j in stocks[i]['unitData']) {
  //       if (j['name'] == selectedValue[i]) {
  //         units = j['id'];
  //       }
  //     }
  //     //stocks
  //     bodyJson["item_id"].add(stocks[i]["id"]);
  //     bodyJson["quantity"].add(stocks[i]["quantity"]);
  //     bodyJson["unit"].add(units);
  //     // }
  //     debugPrint('resJson $bodyJson ');
  //     dynamic resJson = await api.sendData('/api/vanoffloadrequest.store',
  //         AppState().token, jsonEncode(bodyJson));
  //     setState(() {
  //       _loaded = true;
  //     });
  //     if (resJson['data'] != null) {
  //       if (mounted) {
  //         CommonWidgets.showDialogueBox(
  //             context: context, title: "Alert", msg: "Added Successfully");
  //         StockHistory.clearAllStockHistory().then(
  //             (value) => Navigator.of(context).pushNamed(HomeScreen.routeName));
  //       }
  //     }
  //   }
  // }

  Future<void> saveData() async {
    List<int> Quantities = [];
    List<Object> productTypesList = [];
    List<int> selectedUnitIds = [];

    for (int index = 0; index < cartItems.length; index++) {
      String? selectedUnitName = cartItems[index].selectedUnitName;
      int selectedUnitId;
      if (selectedUnitName != null) {
        selectedUnitId = cartItems[index]
            .units
            .firstWhere((unit) => unit.name == selectedUnitName)
            .unit!;
      } else {
        selectedUnitId = cartItems[index].units.first.unit!;
      }

      selectedUnitIds.add(selectedUnitId);
      String? qty = qtys[index];
      int quantity = qty != null ? int.parse(qty) : 1;
      Quantities.add(quantity);
      ProductType? selectedProductType = selectedProductTypes[index];
      Object productType =
          selectedProductType != null ? selectedProductType.id : 1;
      productTypesList.add(productType);
    }
    final url =
        Uri.parse('${RestDatasource().BASE_URL}/api/vanoffloadrequest.store');
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "van_id": AppState().vanId,
      "store_id": AppState().storeId,
      "user_id": AppState().userId,
      "item_id": cartItems.map((item) => item.id).toList(),
      "quantity": Quantities,
      "unit": selectedUnitIds,
      "goods_return_id": cartItems.map((item) => 1).toList(),
      "return_type": cartItems.map((item) => 1).toList(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print(response.body);
      // print('ggggggggggggggggggggggggggggggggg');
      if (mounted) {
        CommonWidgets.showDialogueBox(
            context: context, title: "Alert", msg: "Added Successfully");
        StockHistory.clearAllStockHistory().then(
            (value) => Navigator.of(context).pushNamed(HomeScreen.routeName));
        clearCart();
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save data')));
    }
  }
}
