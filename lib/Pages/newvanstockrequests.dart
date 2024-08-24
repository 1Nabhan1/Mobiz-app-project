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

        // for (int i = 0; i < cartItems.length; i++) {
        //   selectedProductTypes[i] = productTypes.firstWhere(
        //         (type) => type.name == prefs.getString('productType$i'),
        //     orElse: () => productTypes.first,
        //   );
        // }
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

  // double total = 0;
  double calculateTotalRate() {
    double total = 0;
    for (int index = 0; index < cartItems.length; index++) {
      double rate = double.tryParse(
              amounts[index] ?? cartItems[index].price.toString()) ??
          0;
      int quantity = int.tryParse(qtys[index] ?? '1') ?? 1;
      total += rate * quantity;
    }
    return total;
  }

  // double tax = 0;
  double calculateTax() {
    double tax = 0;
    for (int index = 0; index < cartItems.length; index++) {
      double rate = double.tryParse(
              amounts[index] ?? cartItems[index].price.toString()) ??
          0;
      int stock = cartItems[index].units[0].stock ?? 0;
      int quantity = int.tryParse(qtys[index] ?? '1') ?? 1;
      double totaltax = ((rate) / 100) * quantity;
      tax += totaltax;
    }
    return tax;
  }

  // double grnddtotal = 0;
  Map<String, dynamic> grandTotal() {
    String discountValue = _discountData.text.trim();
    double discountAmount = double.tryParse(discountValue) ?? 0;
    double totalRate = calculateTotalRate();
    double totalTax = calculateTax();
    double grandTotal = _ifVat == 1
        ? _isPercentage
            ? totalRate - ((totalRate + totalTax) * discountAmount) / 100
            : totalRate + totalTax - discountAmount
        : _isPercentage
            ? totalRate - (totalRate * discountAmount) / 100
            : totalRate - discountAmount;
    int roundedGrandTotal = customRound(grandTotal);

    return {
      'original': grandTotal,
      'rounded': roundedGrandTotal,
      'roundOffValue': roundedGrandTotal - grandTotal,
    };
  }

  int customRound(double value) {
    double fractionalPart = value - value.toInt();

    if (fractionalPart >= 0.5) {
      return value.ceil();
    } else {
      return value.floor();
    }
  }

  Future<void> removeFromCart(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItemsvanstock');

    if (cartItemsJson != null) {
      List<Product> products = cartItemsJson
          .map((json) => Product.fromJson(jsonDecode(json)))
          .toList();

      products.removeAt(index); // Remove the item at the specific index

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
    Map<String, dynamic> grandTotalMap = grandTotal();

    double total = calculateTotalRate();
    double tax = _ifVat == 1 ? calculateTax() : 0;
    int roundedGrandTotal = grandTotalMap['rounded'];
    double roundOffValue = grandTotalMap['roundOffValue'];

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
                context, SelectProductsScreen.routeName,
                //     arguments: {'customerId': id, 'name': name}).then((value) {
                //   // _initDone = false;
                //   // _getTypes();
                // }
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
                                    // SizedBox(
                                    //   width: 45,
                                    //   height: 20,
                                    //   child: DropdownButtonHideUnderline(
                                    //     child: DropdownButton<ProductType>(
                                    //       alignment: Alignment.center,
                                    //       isExpanded: true,
                                    //       style: TextStyle(
                                    //         fontSize: 12,
                                    //         color: AppConfig.colorPrimary,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //       hint: Center(child: Text('Select')),
                                    //       value: selectedProductTypes[index] !=
                                    //               null
                                    //           ? selectedProductTypes[index]
                                    //           : productTypes.isNotEmpty
                                    //               ? productTypes.first
                                    //               : null,
                                    //       onChanged: (ProductType? newValue) {
                                    //         setState(() {
                                    //           selectedProductTypes[index] =
                                    //               newValue;
                                    //         });
                                    //       },
                                    //       items: productTypes
                                    //           .map((ProductType productType) {
                                    //         return DropdownMenuItem<
                                    //             ProductType>(
                                    //           value: productType,
                                    //           child: Center(
                                    //               child: Text(productType
                                    //                   .name)), // Center align the item text
                                    //         );
                                    //       }).toList(),
                                    //       icon: SizedBox.shrink(),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Text('| '),
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

                                              // Find the selected unit and update the rate
                                              // for (var unit
                                              //     in cartItems[index].units) {
                                              //   if (unit.name == newValue) {
                                              //     // Perform validation based on stock
                                              //     if (unit.stock >=
                                              //         int.parse(
                                              //             qtys[index] ?? '1')) {
                                              //       // Stock is sufficient
                                              //       amounts[index] =
                                              //           unit.price.toString();
                                              //     } else {
                                              //       // Stock is insufficient, handle this scenario (e.g., show error message)
                                              //       // For now, setting rate to default or handle as per your app logic
                                              //       amounts[index] =
                                              //           cartItems[index]
                                              //               .price
                                              //               .toString();
                                              //       // You can show a snackbar or dialog here indicating insufficient stock
                                              //       ScaffoldMessenger.of(
                                              //               context)
                                              //           .showSnackBar(SnackBar(
                                              //         content: Text(
                                              //             'Insufficient stock for ${unit.name}'),
                                              //         duration:
                                              //             Duration(seconds: 2),
                                              //       ));
                                              //     }
                                              //     // saveToSharedPreferences(
                                              //     //     'amountreq$index',
                                              //     //     amounts[index]);
                                              //     break;
                                              //   }
                                              // }
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
                                                        // var selectedUnit =
                                                        //     cartItems[index]
                                                        //         .units
                                                        //         .firstWhere(
                                                        //           (unit) =>
                                                        //               unit.name ==
                                                        //               selectedUnitName,
                                                        //           // orElse: () => null,
                                                        //         );
                                                        //
                                                        // if (selectedUnit !=
                                                        //     null) {
                                                        //   int enteredQuantity =
                                                        //       int.tryParse(qtys[
                                                        //                   index] ??
                                                        //               '1') ??
                                                        //           0;
                                                        //   if (enteredQuantity >
                                                        //       selectedUnit
                                                        //           .stock) {
                                                        //     // Quantity entered exceeds available stock
                                                        //     ScaffoldMessenger
                                                        //             .of(context)
                                                        //         .showSnackBar(
                                                        //             SnackBar(
                                                        //       content: Text(
                                                        //         'Quantity exceeds available stock (${selectedUnit.stock}) for ${selectedUnit.name}',
                                                        //       ),
                                                        //       duration:
                                                        //           Duration(
                                                        //               seconds:
                                                        //                   2),
                                                        //     ));
                                                        //     // Reset quantity to available stock or handle as per your app logic
                                                        //     setState(() {
                                                        //       qtys[index] =
                                                        //           selectedUnit
                                                        //               .stock
                                                        //               .toString();
                                                        //       saveToSharedPreferences(
                                                        //           'qtyreq$index',
                                                        //           qtys[index]);
                                                        //     });
                                                        //   } else {
                                                        //     Navigator.pop(
                                                        //         context); // Close dialog if validation passed
                                                        //   }
                                                        // } else {
                                                        //   Navigator.pop(
                                                        //       context); // Close dialog if no unit found (shouldn't happen if UI is consistent)
                                                        // }
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
                                    // Text(' | '),
                                    // GestureDetector(
                                    //     onTap: () {
                                    //       showDialog(
                                    //           context: context,
                                    //           builder: (context) {
                                    //             return AlertDialog(
                                    //               title: const Text('Amount'),
                                    //               content: TextField(
                                    //                 controller:
                                    //                     TextEditingController(
                                    //                   text:
                                    //                       '${amounts[index] ?? cartItems[index].price}',
                                    //                 ),
                                    //                 onChanged: (value) {
                                    //                   setState(() {
                                    //                     amounts[index] = value;
                                    //                   });
                                    //                 },
                                    //                 keyboardType:
                                    //                     TextInputType.number,
                                    //                 // controller: _discountData,
                                    //               ),
                                    //               actions: <Widget>[
                                    //                 MaterialButton(
                                    //                   color: AppConfig
                                    //                       .colorPrimary,
                                    //                   textColor: Colors.white,
                                    //                   child: const Text('OK'),
                                    //                   onPressed: () {
                                    //                     amount =
                                    //                         amountctrl.text;
                                    //                     Navigator.pop(context);
                                    //                   },
                                    //                 ),
                                    //               ],
                                    //             );
                                    //           });
                                    //     },
                                    //     child: Row(
                                    //       children: [
                                    //         Text('Rate: '),
                                    //         Text(
                                    //           '${amounts[index] ?? cartItems[index].price}',
                                    //           style: TextStyle(
                                    //               color: AppConfig.colorPrimary,
                                    //               fontWeight: FontWeight.bold),
                                    //         ),
                                    //       ],
                                    //     )),
                                    // Text(' | '),
                                    // Text(
                                    //   'Amt: ${amounts[index] ?? cartItems[index].price}',
                                    //   style: TextStyle(color: Colors.grey),
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     right: 18.0,
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       // Row(
                  //       //   mainAxisAlignment: MainAxisAlignment.end,
                  //       //   children: [
                  //       //     Text("REMARKS"),
                  //       //     SizedBox(
                  //       //       width: 10,
                  //       //     ),
                  //       //     InkWell(
                  //       //       onTap: () {
                  //       //         showDialog(
                  //       //           context: context,
                  //       //           builder: (context) {
                  //       //             return AlertDialog(
                  //       //               title: const Text('Remarks'),
                  //       //               content: TextField(
                  //       //                 controller: _remarksController,
                  //       //                 onChanged: (value) {
                  //       //                   setState(() {
                  //       //                     _remarksText = value;
                  //       //                   });
                  //       //                 },
                  //       //                 keyboardType: TextInputType.text,
                  //       //                 decoration: const InputDecoration(
                  //       //                   hintText: "Enter your remarks",
                  //       //                 ),
                  //       //               ),
                  //       //               actions: <Widget>[
                  //       //                 MaterialButton(
                  //       //                   color: AppConfig.colorPrimary,
                  //       //                   textColor: Colors.white,
                  //       //                   child: const Text('OK'),
                  //       //                   onPressed: () {
                  //       //                     setState(() {
                  //       //                       _remarksText =
                  //       //                           _remarksController.text;
                  //       //                     });
                  //       //                     Navigator.pop(context);
                  //       //                   },
                  //       //                 ),
                  //       //               ],
                  //       //             );
                  //       //           },
                  //       //         );
                  //       //       },
                  //       //       child: Container(
                  //       //         constraints: BoxConstraints(
                  //       //           minWidth: 70,
                  //       //           maxWidth: 150,
                  //       //         ),
                  //       //         padding: EdgeInsets.symmetric(
                  //       //             horizontal: 10, vertical: 3),
                  //       //         decoration: BoxDecoration(
                  //       //           border: Border.all(
                  //       //               color: AppConfig.buttonDeactiveColor),
                  //       //           borderRadius:
                  //       //               const BorderRadius.all(Radius.circular(5)),
                  //       //         ),
                  //       //         child: Text(
                  //       //           _remarksText,
                  //       //           style: TextStyle(
                  //       //             color: Colors.black,
                  //       //             // fontWeight: FontWeight.bold,
                  //       //           ),
                  //       //           maxLines: 1,
                  //       //           overflow: TextOverflow.ellipsis,
                  //       //         ),
                  //       //       ),
                  //       //     ),
                  //       //   ],
                  //       // ),
                  //       // SizedBox(
                  //       //   height: 10,
                  //       // ),
                  //       // Row(
                  //       //   mainAxisAlignment: MainAxisAlignment.end,
                  //       //   children: [
                  //       //     Text(
                  //       //       'Discount ',
                  //       //       style: TextStyle(
                  //       //         fontSize: AppConfig.textCaption3Size,
                  //       //       ),
                  //       //     ),
                  //       //     // InkWell(
                  //       //     //   onTap: () => setState(() {
                  //       //     //     _isPercentage = !_isPercentage;
                  //       //     //   }),
                  //       //     //   child: Container(
                  //       //     //     decoration: BoxDecoration(
                  //       //     //         border: Border.all(color: Colors.black),
                  //       //     //         color: (!_isPercentage)
                  //       //     //             ? AppConfig.colorPrimary
                  //       //     //             : AppConfig.backButtonColor,
                  //       //     //         borderRadius: const BorderRadius.only(
                  //       //     //             topLeft: Radius.circular(3),
                  //       //     //             bottomLeft: Radius.circular(3))),
                  //       //     //     width: SizeConfig.blockSizeHorizontal * 24,
                  //       //     //     height: SizeConfig.blockSizeVertical * 3,
                  //       //     //     child: Center(
                  //       //     //       child: Text(
                  //       //     //         'AMOUNT',
                  //       //     //         style: TextStyle(
                  //       //     //           fontSize: AppConfig.textCaption3Size,
                  //       //     //           color: (!_isPercentage)
                  //       //     //               ? AppConfig.backButtonColor
                  //       //     //               : AppConfig.textBlack,
                  //       //     //         ),
                  //       //     //       ),
                  //       //     //     ),
                  //       //     //   ),
                  //       //     // ),
                  //       //     // InkWell(
                  //       //     //   onTap: () => setState(() {
                  //       //     //     _isPercentage = !_isPercentage;
                  //       //     //   }),
                  //       //     //   child: Container(
                  //       //     //     decoration: BoxDecoration(
                  //       //     //         border: Border.all(color: Colors.black),
                  //       //     //         color: (_isPercentage)
                  //       //     //             ? AppConfig.colorPrimary
                  //       //     //             : AppConfig.backButtonColor,
                  //       //     //         borderRadius: const BorderRadius.only(
                  //       //     //             topRight: Radius.circular(3),
                  //       //     //             bottomRight: Radius.circular(3))),
                  //       //     //     width: SizeConfig.blockSizeHorizontal * 24,
                  //       //     //     height: SizeConfig.blockSizeVertical * 3,
                  //       //     //     child: Center(
                  //       //     //         child: Text(
                  //       //     //       'PERCENTAGE',
                  //       //     //       style: TextStyle(
                  //       //     //         fontSize: AppConfig.textCaption3Size,
                  //       //     //         color: (_isPercentage)
                  //       //     //             ? AppConfig.backButtonColor
                  //       //     //             : AppConfig.textBlack,
                  //       //     //       ),
                  //       //     //     )),
                  //       //     //   ),
                  //       //     // ),
                  //       //     // CommonWidgets.horizontalSpace(2),
                  //       //     // InkWell(
                  //       //     //   onTap: () {
                  //       //     //     showDialog(
                  //       //     //         context: context,
                  //       //     //         builder: (context) {
                  //       //     //           return AlertDialog(
                  //       //     //             title: const Text('Discount'),
                  //       //     //             content: TextField(
                  //       //     //               keyboardType: TextInputType.number,
                  //       //     //               controller: _discountData,
                  //       //     //               decoration: const InputDecoration(
                  //       //     //                   hintText: "Discount"),
                  //       //     //             ),
                  //       //     //             actions: <Widget>[
                  //       //     //               MaterialButton(
                  //       //     //                 color: AppConfig.colorPrimary,
                  //       //     //                 textColor: Colors.white,
                  //       //     //                 child: const Text('OK'),
                  //       //     //                 onPressed: () {
                  //       //     //                   Navigator.pop(context);
                  //       //     //                 },
                  //       //     //               ),
                  //       //     //             ],
                  //       //     //           );
                  //       //     //         });
                  //       //     //   },
                  //       //     //   child: Container(
                  //       //     //       width: SizeConfig.blockSizeHorizontal * 17,
                  //       //     //       height: SizeConfig.blockSizeVertical * 3,
                  //       //     //       decoration: BoxDecoration(
                  //       //     //           border: Border.all(
                  //       //     //               color: AppConfig.buttonDeactiveColor),
                  //       //     //           borderRadius: const BorderRadius.all(
                  //       //     //               Radius.circular(5))),
                  //       //     //       child: Center(
                  //       //     //         child: Text(_discountData.text.isEmpty
                  //       //     //             ? ''
                  //       //     //             : _discountData.text),
                  //       //     //       )),
                  //       //     // ),
                  //       //   ],
                  //       // ),
                  //       // Text('Total: $total'),
                  //       // Text('Tax: $tax'),
                  //       // Text('Round off: ${roundOffValue.toStringAsFixed(2)}'),
                  //       // Text('Grand Total: $roundedGrandTotal'),
                  //     ],
                  //   ),
                  // ),
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
