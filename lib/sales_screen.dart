import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/tst.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/sales_model.dart';
import 'Components/commonwidgets.dart';
import 'Utilities/rest_ds.dart';
import 'confg/appconfig.dart';
import 'confg/sizeconfig.dart';
import 'package:http/http.dart' as http;

class SalesScreen extends StatefulWidget {
  static const routeName = "/ScalesScreen";
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
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
  int? id;
  String roundoff = '';
  @override
  void initState() {
    super.initState();
    _loadSavedProducts();
    fetchProductTypes();
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
Map<String,dynamic> CalculatedValue(){
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
      ? totalAmount -
      ((totalAmount * discountAmount) / 100) +
      taxamtperc
      : (totalAmount - discountAmount) + taxamt
      : _isPercentage
      ? totalAmount - (totalAmount * discountAmount) / 100
      : totalAmount - discountAmount;
  num roundedGrandTotal1 =
  roundoff == '' ? customRound(grandTotal) : grandTotal + rundff;
  double roundOffValue = roundedGrandTotal1 - grandTotal;
  return{
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
                    // postDataToApi();
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
        body: savedProducts.isEmpty
            ? Center(child: Text('No saved products'))
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
                    height: MediaQuery.of(context).size.height * .550,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: savedProducts.length,
                      itemBuilder: (context, index) {
                        final product = savedProducts[index];
                        final quantity = double.tryParse(
                                product['quantity']?.toString() ?? '0') ??
                            0.0;
                        final amount = double.tryParse(
                                product['amount']?.toString() ?? '0') ??
                            0.0;

                        final total = quantity * amount;
                        return InkWell(
                          onTap: () => showProductDetailsDialog(context, product),
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
                                              '${RestDatasource().Product_URL}/uploads/product/${product['proImage']}',
                                            ),
                                            placeholder: const AssetImage(
                                                'Assets/Images/no_image.jpg'),
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${product['code']} | ${product['name'].toString().toUpperCase()}',
                                              style: TextStyle(
                                                fontSize:
                                                    AppConfig.textCaption3Size,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.2),
                                        radius: 10,
                                        child: GestureDetector(
                                          onTap: () => _removeProduct(index),
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
                                      Text(product['type_name']),
                                      Text(' | '),
                                      Text(product['unit_name']),
                                      Text(' | '),
                                      Text('Qty: ${product['quantity']}'),
                                      Text(' | '),
                                      Text('Rate: ${product['amount']}'),
                                      Text(' | '),
                                      Text('Amt: ${total}')
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 18.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Remarks",
                              style: TextStyle(
                                fontSize: AppConfig.textCaption3Size,
                              ),
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
                                      title: const Text('Remarks'),
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
                                              _remarksText =
                                                  _remarksController.text;
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
                                width: MediaQuery.of(context).size.width * 0.67,
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppConfig.buttonDeactiveColor),
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
                        SizedBox(
                          height: 10,
                        ),
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
                                          keyboardType: TextInputType.number,
                                          controller: _discountData,
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
                                  )),
                            ),
                          ],
                        ),
                        Text('Total: $totalAmount'),
                        Text('Tax: ${tax.toStringAsFixed(2)}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Round off:'),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Round off'),
                                        content: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: _roundoff,
                                          decoration: const InputDecoration(
                                              hintText: "Round off"),
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
                                    child: Text(''
                                        '${roundoff == '' ?
                                            roundOffValue.toStringAsFixed(2)
                                           : roundoff}'),
                                  )),
                            ),
                          ],
                        ),
                        Text('Grand Total: '
                            '${roundedGrandTotal.toStringAsFixed(2)}'
                            ''),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void showProductDetailsDialog(
      BuildContext context, Map<String, dynamic> product) async {
    final response = await http.get(Uri.parse(
        'http://68.183.92.8:3699/api/get_product_with_units_by_products?store_id=${AppState().storeId}&van_id=${AppState().vanId}&id=${product['id']}'));
    final typeResponse = await http
        .get(Uri.parse('http://68.183.92.8:3699/api/get_product_type'));

    if (response.statusCode == 200 && typeResponse.statusCode == 200) {
      final data = jsonDecode(response.body);
      final units = data['data'] as List?;
      final lastsale = data['lastsale'];
      final typeData = jsonDecode(typeResponse.body);
      final productTypes = typeData['data'] as List;

      final existingProduct = savedProducts
          .firstWhere((p) => p['serial_number'] == product['serial_number']);

      String? selectedUnitId = existingProduct['unit_id'];
      String? selectedProductTypeId = existingProduct['type_id'];
      String? quantity = existingProduct['quantity'];
      String? amount = existingProduct['amount'];
      Map<String, dynamic>? selectedUnit;

      if (selectedUnitId != null && units != null) {
        selectedUnit = units.firstWhere(
            (unit) => unit['id'].toString() == selectedUnitId,
            orElse: () => null);
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(product['name']),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.network(
                        '${RestDatasource().Product_URL}/uploads/product/${product['proImage']}',
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('Assets/Images/no_image.jpg',
                              height: 100);
                        },
                      ),
                      SizedBox(height: 10),
                      Text('Code: ${product['code']}'),
                      Text('Name: ${product['name']}'),
                      SizedBox(height: 10),
                      lastsale == null || lastsale.isEmpty
                          ? Text('No last records found')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Sale:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Date: ${lastsale['date']}'),
                                Text('Unit: ${lastsale['unit']}'),
                                Text('Price: ${lastsale['price']}'),
                              ],
                            ),
                      if (units != null &&
                          units.any((unit) => unit != null)) ...[
                        SizedBox(height: 10),
                        Text(
                          'Product Type',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 10.w),
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                          ),
                          items: productTypes.map((type) {
                            return DropdownMenuItem<String>(
                              value: type['id'].toString(),
                              child: Text(type['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedProductTypeId = value;
                            });
                          },
                          value: selectedProductTypeId,
                          hint: Text('Select Product Type'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Unit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 10.w),
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
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
                            });
                          },
                          value: selectedUnitId,
                          hint: Text('Select Unit'),
                        ),
                        SizedBox(height: 10),
                        if (selectedUnit != null) ...[
                          Text('Price: ${selectedUnit!['price']}'),
                          Text('Stock: ${selectedUnit!['stock']}'),
                        ],
                        SizedBox(height: 10),
                        Text(
                          'Quantity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: quantity,
                          onChanged: (value) {
                            quantity = value;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 10.w),
                              hintText: 'Qty',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.shade300),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Amount',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: amount,
                          onChanged: (value) {
                            amount = value;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 10.w),
                              hintText: 'Amt',
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
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  if (units != null && units.any((unit) => unit != null)) ...[
                    TextButton(
                      child: Text('Save'),
                      onPressed: () async {
                        if (selectedUnitId != null &&
                            selectedProductTypeId != null &&
                            quantity != null &&
                            amount != null) {
                          final productIndex = savedProducts.indexWhere((p) =>
                              p['serial_number'] == product['serial_number']);
                          if (productIndex != -1) {
                            setState(() {
                              savedProducts[productIndex]['unit_id'] =
                                  selectedUnitId;
                              savedProducts[productIndex]['type_id'] =
                                  selectedProductTypeId;
                              savedProducts[productIndex]['quantity'] =
                                  quantity;
                              savedProducts[productIndex]['amount'] = amount;
                              savedProducts[productIndex]['type_name'] =
                                  productTypes.firstWhere((type) =>
                                      type['id'].toString() ==
                                      selectedProductTypeId)['name'];
                              savedProducts[productIndex]['unit_name'] =
                                  selectedUnit?['name'];
                            });

                            final prefs = await SharedPreferences.getInstance();
                            final savedProductsStringList = savedProducts
                                .map((product) => jsonEncode(product))
                                .toList();
                            await prefs.setStringList(
                                'selected_products', savedProductsStringList);

                            Navigator.of(context).pop();
                          }
                        }
                      },
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
