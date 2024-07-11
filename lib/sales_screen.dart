import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/selectproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/commonwidgets.dart';
import 'Models/sales_model.dart';
import 'Utilities/rest_ds.dart';
import 'confg/appconfig.dart';
import 'confg/sizeconfig.dart';

class SalesScreen extends StatefulWidget {
  static const routeName = "/ScalesScreen";

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Product> cartItems = [];
  bool _search = false;
  bool _isPercentage = false;
  final TextEditingController _discountData = TextEditingController();
  final TextEditingController amountctrl = TextEditingController();
  final TextEditingController qtysctrl = TextEditingController();
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
  num total = 0;
  num tax = 0;
  String amount = '';
  String quantity = '';
  @override
  void initState() {
    super.initState();
    fetchCartItems();
    fetchProductTypes();
  }

  Future<void> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItems');

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

  Future<void> removeFromCart(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItems');

    if (cartItemsJson != null) {
      List<Product> products = cartItemsJson
          .map((json) => Product.fromJson(jsonDecode(json)))
          .toList();

      products.removeWhere((product) => product.id == productId);

      List<String> updatedCartItemsJson =
          products.map((product) => jsonEncode(product.toJson())).toList();

      await prefs.setStringList('cartItems', updatedCartItemsJson);

      fetchCartItems(); // Refresh UI after deletion
    }
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    setState(() {
      cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        title: const Text(
          'Sales',
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
                  context, SalesSelectProductsScreen.routeName,
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
      body: cartItems.isEmpty
          ? Center(
              child: Text('No items.'),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        (name ?? '').toUpperCase(),
                        style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                          color: AppConfig.buttonDeactiveColor,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _ifVat = 1;
                          });
                          total = 0;
                          tax = 0;
                          // _calculateTotal();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: (_ifVat == 1)
                                  ? AppConfig.colorPrimary
                                  : AppConfig.backButtonColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(3),
                                  bottomLeft: Radius.circular(3))),
                          width: SizeConfig.blockSizeHorizontal * 13,
                          height: SizeConfig.blockSizeVertical * 3,
                          child: Center(
                            child: Text(
                              'VAT',
                              style: TextStyle(
                                fontSize: AppConfig.textCaption3Size,
                                color: (_ifVat == 1)
                                    ? AppConfig.backButtonColor
                                    : AppConfig.textBlack,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _ifVat = 0;
                          });
                          total = 0;
                          tax = 0;
                          // _calculateTotal();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: (_ifVat == 0)
                                  ? AppConfig.colorPrimary
                                  : AppConfig.backButtonColor,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(3),
                                  bottomRight: Radius.circular(3))),
                          width: SizeConfig.blockSizeHorizontal * 13,
                          height: SizeConfig.blockSizeVertical * 3,
                          child: Center(
                            child: Text(
                              'NO VAT',
                              style: TextStyle(
                                fontSize: AppConfig.textCaption3Size,
                                color: (_ifVat == 0)
                                    ? AppConfig.backButtonColor
                                    : AppConfig.textBlack,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 63,
                  child: ListView.builder(
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
                                            'https://mobiz-shop.yes45.in/uploads/product/${cartItems[index].proImage}',
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
                                          removeFromCart(cartItems[index].id);
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
                                      width: 45,
                                      height: 20,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<ProductType>(
                                          alignment: Alignment.center,
                                          isExpanded: true,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppConfig.colorPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          hint: Text('Select'),
                                          value: selectedProductTypes[index] !=
                                                  null
                                              ? selectedProductTypes[index]
                                              : productTypes.isNotEmpty
                                                  ? productTypes.first
                                                  : null,
                                          onChanged: (ProductType? newValue) {
                                            setState(() {
                                              selectedProductTypes[index] =
                                                  newValue;
                                            });
                                          },
                                          items: productTypes
                                              .map((ProductType productType) {
                                            return DropdownMenuItem<
                                                ProductType>(
                                              value: productType,
                                              child: Text(productType.name),
                                            );
                                          }).toList(),
                                          icon: SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                    Text('| '),
                                    SizedBox(
                                      width: 50,
                                      height: 20,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: selectedUnitName,
                                          items: unitNames
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppConfig.colorPrimary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              cartItems[index]
                                                  .selectedUnitName = newValue;
                                            });
                                          },
                                          icon: SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                    Text('| '),
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
                                    Text(' | '),
                                    GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Amount'),
                                                  content: TextField(
                                                    controller:
                                                        TextEditingController(
                                                      text:
                                                          amounts[index] ?? '',
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        amounts[index] = value;
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
                                                        amount =
                                                            amountctrl.text;
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Text('Rate: '),
                                            Text(
                                              '${amounts[index] ?? cartItems[index].price}',
                                              style: TextStyle(
                                                  color: AppConfig.colorPrimary,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )),
                                    Text(' | '),
                                    Text(
                                      'Amt: ${amounts[index] ?? cartItems[index].price}',
                                      style: TextStyle(color: Colors.grey),
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
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Discount ',
                            style: TextStyle(
                              fontSize: AppConfig.textCaption3Size,
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() {
                              _isPercentage = !_isPercentage;
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: (!_isPercentage)
                                      ? AppConfig.colorPrimary
                                      : AppConfig.backButtonColor,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      bottomLeft: Radius.circular(3))),
                              width: SizeConfig.blockSizeHorizontal * 24,
                              height: SizeConfig.blockSizeVertical * 3,
                              child: Center(
                                child: Text(
                                  'AMOUNT',
                                  style: TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                    color: (!_isPercentage)
                                        ? AppConfig.backButtonColor
                                        : AppConfig.textBlack,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() {
                              _isPercentage = !_isPercentage;
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: (_isPercentage)
                                      ? AppConfig.colorPrimary
                                      : AppConfig.backButtonColor,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      bottomRight: Radius.circular(3))),
                              width: SizeConfig.blockSizeHorizontal * 24,
                              height: SizeConfig.blockSizeVertical * 3,
                              child: Center(
                                  child: Text(
                                'PERCENTAGE',
                                style: TextStyle(
                                  fontSize: AppConfig.textCaption3Size,
                                  color: (_isPercentage)
                                      ? AppConfig.backButtonColor
                                      : AppConfig.textBlack,
                                ),
                              )),
                            ),
                          ),
                          CommonWidgets.horizontalSpace(2),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Discount'),
                                      content: TextField(
                                        onChanged: (value) async {
                                          setState(() {
                                            if (_isPercentage &&
                                                    double.parse((value.isEmpty)
                                                            ? '0'
                                                            : value) >
                                                        100 ||
                                                !_isPercentage &&
                                                    double.parse((value.isEmpty)
                                                            ? '0'
                                                            : value) >
                                                        110) {
                                              CommonWidgets.showDialogueBox(
                                                  context: context,
                                                  title: 'Error',
                                                  msg: 'Invalid Discount');
                                            } else {
                                              total = 0;
                                              tax = 0;
                                              // discount = double.parse(
                                              //     (value.isEmpty)
                                              //         ? '0'
                                              //         : value);
                                              // _calculateTotal();
                                            }
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        // controller: _discountData,
                                        decoration: const InputDecoration(
                                            hintText: "Discount"),
                                      ),
                                      actions: <Widget>[
                                        MaterialButton(
                                          color: AppConfig.colorPrimary,
                                          textColor: Colors.white,
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                                width: SizeConfig.blockSizeHorizontal * 17,
                                height: SizeConfig.blockSizeVertical * 3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppConfig.buttonDeactiveColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: Center(
                                  child: Text(_discountData.text.isEmpty
                                      ? ''
                                      : _discountData.text),
                                )
                                // TextField(
                                //   controller: _discountData,
                                //   keyboardType: TextInputType.number,
                                //   decoration: const InputDecoration(
                                //       border: InputBorder.none),
                                //   onChanged: (value) {
                                //     setState(() {
                                //       if (_isPercentage &&
                                //               double.parse((value.isEmpty)
                                //                       ? '0'
                                //                       : value) >
                                //                   100 ||
                                //           !_isPercentage &&
                                //               double.parse((value.isEmpty)
                                //                       ? '0'
                                //                       : value) >
                                //                   roundedTotal) {
                                //         CommonWidgets.showDialogueBox(
                                //             context: context,
                                //             title: 'Error',
                                //             msg: 'Invalid Discount');
                                //       } else {
                                //         total = 0;
                                //         tax = 0;
                                //         discount = double.parse(
                                //             (value.isEmpty) ? '0' : value);
                                //         _calculateTotal();
                                //       }
                                //     });
                                //   },
                                // ),
                                ),
                          )
                        ],
                      ),
                      Text('Total: 1000'),
                      Text('Tax: 20'),
                      Text('Round off: 00'),
                      Text('Grand Total: 1020'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void postDataToApi() async {
    var url = Uri.parse('https://mobiz-api.yes45.in/api/vansale.store');

    var data = {
      'van_id': AppState().vanId,
      'store_id': AppState().storeId,
      'user_id': AppState().userId,
      'item_id': '1',
      'quantity': ['100'],
      'unit': ['10'],
      'mrp': ['120'],
      'customer_id': id,
      'if_vat': '1',
      'product_type': ['1']
    };

    // Encode your data to JSON
    var body = json.encode(data);

    // Make the POST request
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    // Check the response status
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
      print(response.body); // Handle response data here
    } else {
      print('Post failed with status: ${response.statusCode}');
      print(response.body); // Handle error response here
    }
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
