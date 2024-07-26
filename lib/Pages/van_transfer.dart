import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Pages/vanselectproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Components/commonwidgets.dart';
import '../Models/VanTransfer.dart';
import '../Models/appstate.dart';
import '../Models/sales_model.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class VanTransfer extends StatefulWidget {
  static const routeName = "/VanTransfer";

  const VanTransfer({super.key});

  @override
  State<VanTransfer> createState() => _VanTransferState();
}

class _VanTransferState extends State<VanTransfer> {
  String? selectedVan;
  List<VanData> vans = [];
  List<Product> cartItems = [];
  Map<int, String> amounts = {};
  Map<int, String> qtys = {};
  int? selectedVanId;
  List<ProductType> productTypes = [];
  List<ProductType?> selectedProductTypes = [];
  final TextEditingController _remarksController = TextEditingController();
  String _remarksText = "";
  String amount = '';
  String quantity = '';
  final TextEditingController amountctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
    fetchVans();
    initializeValues();
  }

  Future<void> fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('vantrans');

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
    if (vans.isNotEmpty && cartItems.isNotEmpty) {
      setState(() {
        selectedVan = prefs.getString('selectedVan');
        selectedVanId = prefs.getInt('selectedVanId');
        for (int i = 0; i < cartItems.length; i++) {
          qtys[i] = prefs.getString('qtyvan$i') ?? '1';
          amounts[i] =
              prefs.getString('amountvan$i') ?? cartItems[i].price.toString();

          if (cartItems[i].units.isNotEmpty) {
            cartItems[i].selectedUnitName = prefs.getString('unitNamevan$i') ??
                cartItems[i].units.first.name;
          }
        }
      });
    }
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> removeFromCart(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('vantrans');

    if (cartItemsJson != null) {
      List<Product> products = cartItemsJson
          .map((json) => Product.fromJson(jsonDecode(json)))
          .toList();

      products.removeAt(index);

      List<String> updatedCartItemsJson =
      products.map((product) => jsonEncode(product.toJson())).toList();

      await prefs.setStringList('vantrans', updatedCartItemsJson);
      setState(() {
        cartItems = products; // Refresh UI after deletion
      });
      fetchCartItems();
    }
  }

  Future<void> fetchVans() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_van_by_store?store_id=${AppState().storeId}&van_id=${AppState().vanId}'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['data'];
      setState(() {

        vans = jsonResponse.map((van) => VanData.fromJson(van)).toList();
        initializeValues();
      });
    } else {
      throw Exception('Failed to load vans');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            clearSharedPreferences();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConfig.colorPrimary,
        title: const Text(
          'Van Transfer Request',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepPurple.shade100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.flip(
                            flipX: true,
                            child: Image.asset(
                              'Assets/Images/van stock.png',
                              width: 60,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'D 87550',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppConfig.colorPrimary,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.person,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ' ${AppState().name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppConfig.colorPrimary,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    CupertinoIcons.arrow_right_arrow_left,
                    color: AppConfig.backgroundColor,
                  ),
                ),
                decoration: BoxDecoration(
                  color: AppConfig.colorPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .47,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          .03,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Select Van to Transfer",
                                          style: TextStyle(
                                            color: AppConfig.colorPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .32,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          .03,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isDense: true,
                                          isExpanded: true,
                                          style: TextStyle(),
                                          value: selectedVan,
                                          hint: Center(
                                            child: Text(
                                              'Select here',
                                            ),
                                          ),
                                          items: vans.map((VanData van) {
                                            return DropdownMenuItem<String>(
                                              value: van.name,
                                              child: Center(
                                                child: Text(
                                                  van.name ?? '',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) async {
                                            setState(() {
                                              selectedVan = newValue;
                                              selectedVanId = vans
                                                  .firstWhere((van) =>
                                              van.name == newValue)
                                                  .id;
                                            });
                                            await saveToSharedPreferences(
                                                'selectedVan', newValue);
                                            await saveToSharedPreferences(
                                                'selectedVanId', selectedVanId);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'Assets/Images/van stock.png',
                                width: 60,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  selectedVan ?? 'Van no:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppConfig.colorPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.person,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'MAHAMOOD KHAN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppConfig.colorPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stock Detail',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            GestureDetector(
              // onTap: () {
              //   transferData();
              // },
              child: Container(
                  height: SizeConfig.blockSizeVertical * 58,
                  color: Colors.grey.shade300,
                  child: Scrollbar(
                    thickness: 10,
                    thumbVisibility: false,
                    radius: Radius.circular(5),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Vanselectproducts.routeName,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      color: AppConfig.colorPrimary,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ),
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
                              List<int> unitid = cartItems[index]
                                  .units
                                  .where((unit) => unit.unit != null)
                                  .map((unit) => unit.unit!)
                                  .toList();

                              if (unitNames.isEmpty) {
                                return SizedBox.shrink();
                              }

                              // Ensure each item has its own selected unit name state
                              String? selectedUnitName =
                                  cartItems[index].selectedUnitName ??
                                      unitNames.first;
                              String quantity = qtys[index] ?? '1';
                              String rate = amounts[index] ??
                                  cartItems[index].price.toString();
                              double ttlamount =
                                  double.parse(quantity) * double.parse(rate);
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
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
                                            Column(
                                              children: [
                                                CommonWidgets.verticalSpace(1),
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child:
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    isDense: true,
                                                    alignment: Alignment.center,
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

                                                        // Find the selected unit and update the rate
                                                        for (var unit
                                                        in cartItems[index]
                                                            .units) {
                                                          if (unit.name ==
                                                              newValue) {
                                                            // Perform validation based on stock
                                                            if (unit.stock >=
                                                                int.parse(qtys[
                                                                index] ??
                                                                    '1')) {
                                                              // Stock is sufficient
                                                              amounts[index] =
                                                                  unit.price
                                                                      .toString();
                                                            } else {
                                                              // Stock is insufficient, handle this scenario (e.g., show error message)
                                                              // For now, setting rate to default or handle as per your app logic
                                                              amounts[index] =
                                                                  cartItems[
                                                                  index]
                                                                      .price
                                                                      .toString();
                                                              // You can show a snackbar or dialog here indicating insufficient stock
                                                              ScaffoldMessenger
                                                                  .of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Insufficient stock for ${unit.name}'),
                                                                    duration:
                                                                    Duration(
                                                                        seconds:
                                                                        2),
                                                                  ));
                                                            }
                                                            saveToSharedPreferences(
                                                                'amountvan$index',
                                                                amounts[index]);
                                                            break;
                                                          }
                                                        }
                                                        saveToSharedPreferences(
                                                            'unitNamevan$index',
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
                                                              text: qtys[
                                                              index]),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              qtys[index] =
                                                                  value;
                                                              saveToSharedPreferences(
                                                                  'qty$index',
                                                                  value);
                                                            });
                                                          },
                                                          keyboardType:
                                                          TextInputType
                                                              .number,
                                                        ),
                                                        actions: <Widget>[
                                                          MaterialButton(
                                                            color: AppConfig
                                                                .colorPrimary,
                                                            textColor:
                                                            Colors.white,
                                                            child: Text('OK'),
                                                            onPressed: () {
                                                              // Validate quantity against selected unit stock
                                                              var selectedUnit =
                                                              cartItems[
                                                              index]
                                                                  .units
                                                                  .firstWhere(
                                                                    (unit) =>
                                                                unit.name ==
                                                                    selectedUnitName,
                                                                // orElse: () => null,
                                                              );

                                                              if (selectedUnit !=
                                                                  null) {
                                                                int enteredQuantity =
                                                                    int.tryParse(qtys[index] ??
                                                                        '1') ??
                                                                        0;
                                                                if (enteredQuantity >
                                                                    selectedUnit
                                                                        .stock) {
                                                                  // Quantity entered exceeds available stock
                                                                  ScaffoldMessenger.of(
                                                                      context)
                                                                      .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                        Text(
                                                                          'Quantity exceeds available stock (${selectedUnit.stock}) for ${selectedUnit.name}',
                                                                        ),
                                                                        duration: Duration(
                                                                            seconds:
                                                                            2),
                                                                      ));
                                                                  // Reset quantity to available stock or handle as per your app logic
                                                                  setState(() {
                                                                    qtys[index] =
                                                                        selectedUnit
                                                                            .stock
                                                                            .toString();
                                                                    saveToSharedPreferences(
                                                                        'qtyvan$index',
                                                                        qtys[
                                                                        index]);
                                                                  });
                                                                } else {
                                                                  Navigator.pop(
                                                                      context); // Close dialog if validation passed
                                                                }
                                                              } else {
                                                                Navigator.pop(
                                                                    context); // Close dialog if no unit found (shouldn't happen if UI is consistent)
                                                              }
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
                                                        color: AppConfig
                                                            .colorPrimary,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Remarks",
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Remarks'),
                            content: TextField(
                              controller: _remarksController,
                              onChanged: (value) {
                                setState(() {
                                  _remarksText = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "Enter your remarks",
                              ),
                            ),
                            actions: <Widget>[
                              MaterialButton(
                                color: AppConfig.colorPrimary,
                                textColor: Colors.white,
                                child: const Text('OK'),
                                onPressed: () {
                                  setState(() {
                                    _remarksText = _remarksController.text;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.9,
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: AppConfig.buttonDeactiveColor),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                        child: Text(
                          _remarksText,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.colorPrimary),
                onPressed: (cartItems.isNotEmpty)
                    ? () async {
                  postDataToApi();
                }
                    : null,
                child: Text(
                  'TRANSFER',
                  style: TextStyle(color: AppConfig.backgroundColor),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void postDataToApi() async {
    var url = Uri.parse('http://68.183.92.8:3699/api/vantransfar.store');
    List<int> quantities = [];
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
      quantities.add(quantity);

      ProductType? selectedProductType = selectedProductTypes[index];
      Object productType =
      selectedProductType != null ? selectedProductType.id : 1;
      productTypesList.add(productType);
    }
    var data = {
      'from_van_id': AppState().vanId,
      'store_id': AppState().storeId,
      'user_id': AppState().userId,
      'to_van_id': selectedVanId,
      'item_id': cartItems.map((item) => item.id).toList(),
      'quantity': quantities,
      'unit': selectedUnitIds,
      // 'mrp': amounts.entries.map((entry) {
      //   return double.parse(entry.value);
      // }).toList(),

      'remarks': _remarksText
    };
    var body = json.encode(data);

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // print(cartItems.map((item) => item.id).toList(),);
      // print(AppState().userId);
      // print(selectedUnitIds);
      // print(selectedVanId);
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

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    setState(() {
      cartItems.clear();
    });
  }
}