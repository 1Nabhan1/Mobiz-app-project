import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/selectProducts.dart';
import 'package:mobizapp/selectproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/commonwidgets.dart';
import '../Models/sales_model.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class VanStocks extends StatefulWidget {
  static const routeName = "/NewVanStockRequests";

  @override
  _VanStocksState createState() => _VanStocksState();
}

class _VanStocksState extends State<VanStocks> {
  List<Product> cartItems = [];
  bool _search = false;

  bool _isPercentage = false;
  final TextEditingController _discountData = TextEditingController();
  final TextEditingController amountctrl = TextEditingController();
  final TextEditingController qtysctrl = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  String _remarksText = "";
  Map<int, String> amounts = {};
  Map<int, String> qtys = {};
  TextEditingController _searchData = TextEditingController();
  int? id;
  String? selectedUnitName;
  List<ProductType> productTypes = [];
  List<ProductType?> selectedProductTypes =
  []; // List to store selected product types
  String? name;
  int _ifVat = 1;
  // num tax = 0;

  String amount = '';
  String quantity = '';
  @override
  void initState() {
    super.initState();
    fetchCartItems();
    fetchProductTypes();
    initializeValues();
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

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> initializeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Wait until productTypes and cartItems are populated
    setState(() {
      for (int i = 0; i < cartItems.length; i++) {
        qtys[i] = prefs.getString('qtyreq$i') ?? '1';
        amounts[i] =
            prefs.getString('amountreq$i') ?? cartItems[i].price.toString();

        if (cartItems[i].units.isNotEmpty) {
          cartItems[i].selectedUnitName =
              prefs.getString('unitNamereq$i') ?? cartItems[i].units.first.name;
        }
      }
    });
  }

  Future<void> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItemsvanstock');

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
    List<String>? cartItemsJson = prefs.getStringList('cartItemsvanstock');

    if (cartItemsJson != null) {
      List<Product> products = cartItemsJson
          .map((json) => Product.fromJson(jsonDecode(json)))
          .toList();

      // Remove the item at the specific index
      products.removeAt(index);

      // Remove quantity and amount for the removed product
      qtys.remove(index);
      amounts.remove(index);

      // Update the keys of the qtys and amounts maps
      Map<int, String> newQtys = {};
      Map<int, String> newAmounts = {};
      for (int i = 0; i < products.length; i++) {
        newQtys[i] =
            qtys[i + (i >= index ? 1 : 0)] ?? '1'; // Adjusting the index
        newAmounts[i] = amounts[i + (i >= index ? 1 : 0)] ??
            products[i].price.toString(); // Adjusting the index
      }

      qtys = newQtys;
      amounts = newAmounts;

      List<String> updatedCartItemsJson =
      products.map((product) => jsonEncode(product.toJson())).toList();

      await prefs.setStringList('cartItemsvanstock', updatedCartItemsJson);
      fetchCartItems(); // Refresh UI after deletion
    }
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItemsvanstock');
    setState(() {
      cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    void postDataToApi() async {
      var url = Uri.parse('${RestDatasource().BASE_URL}/api/vanrequest.store');
      List<int> quantities = [];
      List<int> selectedUnitIds = [];

      for (int index = 0; index < cartItems.length; index++) {
        String? qty = qtys[index];
        int quantity = qty != null ? int.parse(qty) : 1;
        quantities.add(quantity);
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
      }
      var data = {
        'van_id': AppState().vanId,
        'store_id': AppState().storeId,
        'user_id': AppState().userId,
        'item_id': cartItems.map((item) => item.id).toList(),
        'quantity': quantities,
        'unit': selectedUnitIds,
      };
      // print(_remarksText);
      // print('wwwwwwwwwwwwwwwwwwwwwwwww');
      var body = json.encode(data);

      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Post successful');
        if (mounted) {
          CommonWidgets.showDialogueBox(
              context: context, title: "Alert", msg: "Created Successfully")
              .then(
                (value) {
              clearCart();
            },
          );
        }
        print(response.body);
      } else {
        print('Post failed with status: ${response.statusCode}');
        print(response.body);
      }
    }

    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['customerId'];
      name = params['name'];
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: SizeConfig.blockSizeHorizontal * 35,
        height: SizeConfig.blockSizeVertical * 5,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            backgroundColor: (cartItems.isNotEmpty)
                ? const WidgetStatePropertyAll(AppConfig.colorPrimary)
                : const WidgetStatePropertyAll(AppConfig.buttonDeactiveColor),
          ),
          onPressed: (cartItems.isNotEmpty)
              ? () async {
            postDataToApi();
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
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              clearSharedPreferences();
            },
            child: Icon(Icons.arrow_back_rounded)),
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        title: const Text(
          'Van Stocks Requests',
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
                context,
                SelectProductsScreen.routeName,
              );
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
      body: cartItems.isEmpty
          ? Center(
        child: Text('No items.'),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
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
                    cartItems[index].selectedUnitName ?? unitNames.first;
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
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
                              Flexible(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    isExpanded: false,
                                    alignment: Alignment.center,
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
                                                  color:
                                                  AppConfig.colorPrimary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        cartItems[index]
                                            .selectedUnitName = newValue;
                                        saveToSharedPreferences(
                                            'unitNamereq$index',
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
                                            title: const Text('Quantity'),
                                            content: TextField(
                                              controller:
                                              TextEditingController(
                                                text: qtys[index] ?? '',
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  qtys[index] = value;
                                                  saveToSharedPreferences(
                                                      'qtyreq$index',
                                                      value);
                                                });
                                              },
                                              keyboardType:
                                              TextInputType.number,
                                              // controller: _discountData,
                                            ),
                                            actions: <Widget>[
                                              MaterialButton(
                                                color: AppConfig
                                                    .colorPrimary,
                                                textColor: Colors.white,
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  quantity =
                                                      qtysctrl.text;
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Text('Qty: '),
                                      Text(
                                        '${qtys[index] ?? '1'}',
                                        style: TextStyle(
                                            color: AppConfig.colorPrimary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchProductTypes() async {
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
  }
}