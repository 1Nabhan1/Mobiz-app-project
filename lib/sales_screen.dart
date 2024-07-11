import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobizapp/selectproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Components/commonwidgets.dart';
import 'Models/sales_model.dart';
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
  TextEditingController _searchData = TextEditingController();
  int? id;
  List<ProductType> productTypes = [];
  ProductType? selectedProductType;
  String? name;
  int _ifVat = 1;
  num total = 0;
  num tax = 0;
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
      // Convert JSON strings to Product objects
      List<Product> products = cartItemsJson
          .map((json) => Product.fromJson(jsonDecode(json)))
          .toList();

      // Filter out duplicate products based on id
      List<Product> uniqueProducts = [];

      for (var product in products) {
        if (!uniqueProducts.any((element) => element.id == product.id)) {
          uniqueProducts.add(product);
        }
      }

      setState(() {
        cartItems = uniqueProducts;
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

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['customerId'];
      name = params!['name'];
    }
    return Scaffold(
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
                        border: InputBorder.none),
                  ),
                )
              : Container(),
          CommonWidgets.horizontalSpace(1),
          // (!_search)
          //     ? GestureDetector(
          //         onTap: () async {
          //           if (mounted) {
          //             Navigator.pushReplacementNamed(
          //                     context, SalesSelectProductsScreen.routeName,
          //                     arguments: {'customerId': id, 'name': name})
          //                 .then((value) {
          //               _initDone = false;
          //               _getTypes();
          //             });
          //           }
          //         },
          //         child: const Icon(
          //           Icons.add,
          //           size: 30,
          //           color: AppConfig.backgroundColor,
          //         ),
          //       )
          //     : Container(),
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
              (!_search) ? Icons.search : Icons.close,
              size: 30,
              color: AppConfig.backgroundColor,
            ),
          ),
          CommonWidgets.horizontalSpace(3),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text('No items in the cart.'),
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
                                    : AppConfig.textBlack),
                          )),
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
                                    : AppConfig.textBlack),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
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
                                    .withOpacity(0.5)),
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
                                            'https://mobiz-shop.yes45.in/uploads/product/${cartItems[index].proImage}'),
                                        placeholder: const AssetImage(
                                            'Assets/Images/no_image.jpg'),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'Assets/Images/no_image.jpg',
                                              fit: BoxFit.fitWidth);
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
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    70,
                                            child: Text(
                                                '${cartItems[index].code} | ${cartItems[index].name.toString().toUpperCase()}',
                                                style: TextStyle(
                                                  fontSize: AppConfig
                                                      .textCaption3Size,
                                                )),
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
                                          // await SaleskHistory.clearSalesHistory(data['icode'])
                                          //     .then(
                                          //       (value) {
                                          //     _getTypes();
                                          //   },
                                          // );
                                          removeFromCart(cartItems[index].id);
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 10,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<ProductType>(
                                        isExpanded: true,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                        hint: Text('Select Product Type'),
                                        value: selectedProductType,
                                        onChanged: (ProductType? newValue) {
                                          setState(() {
                                            selectedProductType = newValue;
                                          });
                                        },
                                        items: productTypes
                                            .map((ProductType productType) {
                                          return DropdownMenuItem<ProductType>(
                                            value: productType,
                                            child: Text(productType.name),
                                          );
                                        }).toList(),
                                        icon: SizedBox.shrink(),
                                      ),
                                    ),
                                  ),
                                  Text('| '),
                                  Text('Rate:${cartItems[index].price}')
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Future<void> fetchProductTypes() async {
    final response = await http
        .get(Uri.parse('https://mobiz-api.yes45.in/api/get_product_type'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<ProductType> loadedProductTypes = [];

      for (var item in data['data']) {
        loadedProductTypes.add(ProductType.fromJson(item));
      }

      setState(() {
        productTypes = loadedProductTypes;
        if (productTypes.isNotEmpty) {
          selectedProductType = productTypes.first;
        }
      });
    } else {
      throw Exception('Failed to load product types');
    }
  }
}
