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
  bool _loaded = true;
  late Future<Offload> _Offload;
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
    _getStockData();
    fetchCartItems();
    _Offload = fetchData();
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: SizeConfig.blockSizeHorizontal * 25,
            height: SizeConfig.blockSizeVertical * 5,
            child: ElevatedButton(
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
                saveData();
                // saveData();
              },
              // (_loaded == false)
              //     ? () {
              //         saveData();
              //       }
              //     : () {
              //         if (stocks.isNotEmpty) {
              //           setState(() {
              //             _loaded = false;
              //           });
              //           _sendProducts();
              //           saveData();
              //         }
              //       },
              child: (_loaded == false)
                  ? const CircularProgressIndicator(
                      color: AppConfig.backgroundColor,
                    )
                  : Text(
                      'SAVE',
                      style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                          color: AppConfig.backgroundColor,
                          fontWeight: AppConfig.headLineWeight),
                    ),
            ),
          ),
          body: FutureBuilder<Offload>(
            future: _Offload,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                itemIds.clear();
                quantities.clear();
                units.clear();
                goodsReturnIds.clear();
                returnTypes.clear();
                return SingleChildScrollView(
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
                                      width:
                                          SizeConfig.blockSizeHorizontal * 90,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // SizedBox(
                                                //   width: 50,
                                                //   height: 60,
                                                //   child: ClipRRect(
                                                //     borderRadius:
                                                //         BorderRadius.circular(10),
                                                //     child: FadeInImage(
                                                //       image: NetworkImage(
                                                //         '${RestDatasource().BASE_URL}/uploads/product/${cartItems[index].proImage}',
                                                //       ),
                                                //       placeholder:
                                                //           const AssetImage(
                                                //         'Assets/Images/no_image.jpg',
                                                //       ),
                                                //       imageErrorBuilder: (context,
                                                //           error, stackTrace) {
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
                                                Column(
                                                  children: [
                                                    CommonWidgets.verticalSpace(
                                                        1),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonWidgets
                                                            .horizontalSpace(1),
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
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.2),
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
                                                //   child:
                                                //       DropdownButtonHideUnderline(
                                                //     child: DropdownButton<
                                                //         ProductType>(
                                                //       alignment: Alignment.center,
                                                //       isExpanded: true,
                                                //       style: TextStyle(
                                                //         fontSize: 12,
                                                //         color: AppConfig
                                                //             .colorPrimary,
                                                //         fontWeight:
                                                //             FontWeight.bold,
                                                //       ),
                                                //       hint: Center(
                                                //           child: Text('Select')),
                                                //       value: selectedProductTypes[
                                                //                   index] !=
                                                //               null
                                                //           ? selectedProductTypes[
                                                //               index]
                                                //           : productTypes
                                                //                   .isNotEmpty
                                                //               ? productTypes.first
                                                //               : null,
                                                //       onChanged: (ProductType?
                                                //           newValue) {
                                                //         setState(() {
                                                //           selectedProductTypes[
                                                //               index] = newValue;
                                                //         });
                                                //       },
                                                //       items: productTypes.map(
                                                //           (ProductType
                                                //               productType) {
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
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child:
                                                        DropdownButton<String>(
                                                      alignment:
                                                          Alignment.center,
                                                      isExpanded: false,
                                                      value: selectedUnitName,
                                                      items: unitNames.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Center(
                                                            child: Text(
                                                              value,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppConfig
                                                                    .colorPrimary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          cartItems[index]
                                                                  .selectedUnitName =
                                                              newValue;
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
                                                            if (qtys[index] ==
                                                                    null ||
                                                                qtys[index]!
                                                                    .isEmpty) {
                                                              qtys[index] = '1';
                                                            }

                                                            TextEditingController
                                                                qtyController =
                                                                TextEditingController(
                                                              text: qtys[index],
                                                            );
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Quantity'),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    qtyController,
                                                                //     TextEditingController(
                                                                //   text: qtys[
                                                                //           index] ??
                                                                //       '',
                                                                // ),
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    qtys[index] =
                                                                        value;
                                                                  });
                                                                },
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                // controller: _discountData,
                                                              ),
                                                              actions: <Widget>[
                                                                MaterialButton(
                                                                  color: AppConfig
                                                                      .colorPrimary,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                  onPressed:
                                                                      () {
                                                                    quantity =
                                                                        qtysctrl
                                                                            .text;
                                                                    Navigator.pop(
                                                                        context);
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
                                                              color: AppConfig
                                                                  .colorPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                //               title: const Text(
                                                //                   'Amount'),
                                                //               content:
                                                //                   TextField(
                                                //                 controller:
                                                //                     TextEditingController(
                                                //                   text:
                                                //                       '${amounts[index] ?? cartItems[index].price}',
                                                //                 ),
                                                //                 onChanged:
                                                //                     (value) {
                                                //                   setState(() {
                                                //                     amounts[index] =
                                                //                         value;
                                                //                   });
                                                //                 },
                                                //                 keyboardType:
                                                //                     TextInputType
                                                //                         .number,
                                                //                 // controller: _discountData,
                                                //               ),
                                                //               actions: <Widget>[
                                                //                 MaterialButton(
                                                //                   color: AppConfig
                                                //                       .colorPrimary,
                                                //                   textColor:
                                                //                       Colors
                                                //                           .white,
                                                //                   child:
                                                //                       const Text(
                                                //                           'OK'),
                                                //                   onPressed:
                                                //                       () {
                                                //                     amount =
                                                //                         amountctrl
                                                //                             .text;
                                                //                     Navigator.pop(
                                                //                         context);
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
                                                //               color: AppConfig
                                                //                   .colorPrimary,
                                                //               fontWeight:
                                                //                   FontWeight
                                                //                       .bold),
                                                //         ),
                                                //       ],
                                                //     )),
                                                // Text(' | '),
                                                // Text(
                                                //   'Amt: ${amounts[index] ?? cartItems[index].price}',
                                                //   style: TextStyle(
                                                //       color: Colors.grey),
                                                // )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Text(
                              'Return',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
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
                            final salesReturnItem = snapshot.data!.data[index];
                            itemIds.add(salesReturnItem.product.first.id);
                            quantities.add(salesReturnItem.quantity);
                            units.add(salesReturnItem.units.first.id);
                            goodsReturnIds.add(salesReturnItem.id);
                            returnTypes
                                .add(salesReturnItem.returntype.first.id);
                            return Container(
                              width: SizeConfig.blockSizeHorizontal * 90,
                              child: Card(
                                color: AppConfig.backgroundColor,
                                elevation: 3,
                                // margin: EdgeInsets.symmetric(
                                //     vertical: 8.0, horizontal: 7.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8.0),
                                      Text(
                                        '${salesReturnItem.product.first.code} | ${salesReturnItem.product.first.name}',
                                        style: TextStyle(
                                          // color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Text(
                                            '${salesReturnItem.returntype[0].name} | ${salesReturnItem.units[0].name} | Qty: ${salesReturnItem.quantity} ',
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
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
            },
          )),
    );
  }

  Future<void> _getStockData() async {
    stocks = await StockHistory.getStockHistory();
    print('stock Data $stocks');
    menuItems = List.generate(stocks.length, (_) => []);
    selectedValue = List.filled(stocks.length, '');
    selectedId = List.filled(stocks.length, {});
    for (int index = 0; index < stocks.length; index++) {
      dynamic listData = stocks[index]['unitData'].toSet().toList();
      for (int i = 0; i < listData.length; i++) {
        menuItems[index].add(DropdownMenuItem(
            value: (listData[i]['name']).toString(),
            child: Text((listData[i]['name']).toString())));
        selectedValue[index] = (stocks[index]['selectedUnit'] != null)
            ? stocks[index]['selectedUnit']
            : listData[i]['name'].toString();
        selectedId[index] = {
          'name': listData[i]['name'].toString(),
          'id': listData[i]['id'],
        };
      }
    }

    setState(() {
      _initDone = true;
    });
  }

  Widget _stockCard(Map<dynamic, dynamic> data, int index) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(5),
        width: SizeConfig.blockSizeHorizontal * 90,
        decoration: const BoxDecoration(
          color: AppConfig.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ListTile(
          title: Tooltip(
            message: data['name'].toString().toUpperCase(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    radius: 8,
                    child: GestureDetector(
                      onTap: () async {
                        StockHistory.clearStockHistory(data['itemId'])
                            .then((value) => _getStockData());
                      },
                      child: const Icon(
                        Icons.close,
                        size: 13,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Text(
                    '${data['code']} | ${data['name'].toString().toUpperCase()}',
                    style: TextStyle(fontSize: AppConfig.textCaption2Size)),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Unit :'),
                  DropdownButton(
                      value: selectedValue[index],
                      underline: const SizedBox(),
                      style: const TextStyle(
                          color: AppConfig.colorPrimary,
                          fontWeight: FontWeight.w600),
                      icon: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue[index] = newValue!;
                        });
                        StockHistory.updateStockItem(data['itemId'],
                            'selectedUnit', selectedValue[index]);
                      },
                      items: menuItems[index]),
                  CommonWidgets.horizontalSpace(1),
                  const Text('|'),
                  CommonWidgets.horizontalSpace(1),
                  const Text('Qty :'),
                  GestureDetector(
                    onTap: () {
                      _qty.text = '${data['quantity']}';
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Quantity'),
                              content: TextField(
                                onChanged: (value) async {},
                                keyboardType: TextInputType.number,
                                controller: _qty,
                                decoration:
                                    const InputDecoration(hintText: "Quantity"),
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  color: AppConfig.colorPrimary,
                                  textColor: Colors.white,
                                  child: const Text('OK'),
                                  onPressed: () {
                                    data['quantity'] = num.parse(_qty.text);
                                    setState(() {
                                      StockHistory.updateStockItem(
                                          data['itemId'],
                                          'quantity',
                                          data['quantity']);
                                    });

                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Text(
                      data['quantity'].toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppConfig.colorPrimary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // trailing:
          //     //Text(data['quantity'].toString()),
          //     SizedBox(
          //   width: SizeConfig.blockSizeHorizontal * 45,
          //   child: Row(
          //     children: [
          //       const Spacer(),
          //       CommonWidgets.horizontalSpace(2),
          //       CommonWidgets.horizontalSpace(3),
          //       Column(
          //         children: [
          //           GestureDetector(
          //             onTap: () {
          //               setState(
          //                 () {
          //                   if (data['quantity'] > 1) {
          //                     data['quantity'] = data['quantity'] - 1;
          //                   }
          //                 },
          //               );
          //             },
          //             child: CircleAvatar(
          //               radius: 9,
          //               backgroundColor: Colors.red,
          //               child: Center(
          //                 child: Text('-',
          //                     style: TextStyle(
          //                         fontSize: 14,
          //                         color: AppConfig.backgroundColor,
          //                         fontWeight: AppConfig.headLineWeight)),
          //               ),
          //             ),
          //           ),
          //           CommonWidgets.verticalSpace(2),
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 data['quantity'] = data['quantity'] + 1;
          //               });
          //               StockHistory.updateStockItem(
          //                   data['itemId'], 'quantity', data['quantity']);
          //             },
          //             child: const CircleAvatar(
          //               radius: 9,
          //               backgroundColor: Colors.green,
          //               child: Center(
          //                 child: Icon(Icons.add,
          //                     size: 14, color: AppConfig.backgroundColor),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       CommonWidgets.horizontalSpace(3),
          //       GestureDetector(
          //         onTap: () {
          //           StockHistory.clearStockHistory(data['itemId'])
          //               .then((value) => _getStockData());
          //         },
          //         child: const Icon(
          //           Icons.delete,
          //           color: Colors.red,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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

    for (int index = 0; index < cartItems.length; index++) {
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
      "unit": cartItems.map((item) => item.units[0].unit).toList(),
      "goods_return_id": ['1'],
      "return_type": ['1']
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
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
