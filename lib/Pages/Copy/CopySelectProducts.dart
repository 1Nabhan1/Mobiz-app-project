import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:mobizapp/Pages/salesscreen.dart';
import 'package:mobizapp/sales_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Components/commonwidgets.dart';
import '../../Models/ProductsModelClass.dart';
import '../../Models/appstate.dart';
import '../../Models/sales_model.dart';
import '../../Utilities/rest_ds.dart';
import '../../confg/appconfig.dart';
import '../../confg/sizeconfig.dart';
import 'Copy.dart';

class CopySelectProduct extends StatefulWidget {
  static const routeName = "/CopySelectProduct";
  @override
  _CopySelectProductState createState() => _CopySelectProductState();
}

String? name;
// int?id;
int? pricegroupId;

class _CopySelectProductState extends State<CopySelectProduct> {
  List<Products> products = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreProducts = true;
  String? paydata;
  String? code;
  String? paymentTerms;
  // int? pricegroupId;
  bool _search = true;
  List<Products> filteredProducts = [];
  bool _isDialogOpen = false;
  bool isAvailable = true;
  final TextEditingController _searchData = TextEditingController();
  @override
  void initState() {
    super.initState();
    // fetchProducts(currentPage); // Initial fetch
    _searchData.addListener(() {
      _filterProducts(_searchData.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if arguments are passed via the ModalRoute and extract them
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final Map<String, dynamic>? params =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

        if (params != null) {
          setState(() {
            name = params['name'];
            id = params['customerId'];
            pricegroupId = params['price_group_id'];
            paydata = params['outstandamt'];
            code = params['code'];
            paymentTerms = params['paymentTerms'];
            // print('sdfkjbvhjbdsvkjsdnv');
            // print(paydata);
          });
        }
      }
      fetchProducts(currentPage);
    });
  }

  Future<void> fetchProducts(int page) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    int? prid = pricegroupId == 0 ? 0 : id;

    final url =
        '${RestDatasource().BASE_URL}/api/get_product_with_van_stock_and_sales?store_id=${AppState().storeId}&customer_id=$prid';
    print(pricegroupId);
    print('Request URL: $url'); // Log the URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      if (!data.containsKey('data') || !data.containsKey('pagination')) {
        throw Exception('Invalid response format: Missing required keys');
      }

      final List<Products> fetchedProducts = (data['data'] as List)
          .map((json) => Products.fromJson(json))
          .toList();

      final pagination = data['pagination'];

      setState(() {
        isLoading = false;
        products.addAll(fetchedProducts);
        filteredProducts = List.from(products); // Update filtered products
        currentPage++;
        hasMoreProducts = currentPage <= pagination['last_page'];
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e'); // Log any errors
      throw Exception('Failed to load products. Error: $e');
    }
  }

  void _filterProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = List.from(products);
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          '${RestDatasource().BASE_URL}/api/get_product_with_van_stock_for_search?store_id=${AppState().storeId}&value=$query'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Products> fetchedProducts = (data['data'] as List)
            .map((json) => Products.fromJson(json))
            .toList();

        setState(() {
          isLoading = false;
          filteredProducts =
              fetchedProducts; // Update the filtered products with the search results
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching search results: $e');
    }
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_products');
  }

  Future<void> _onBackPressed() async {
    clearCart();
    // Your custom function logic here
    print('Back button pressed');
    // You can also show a dialog, navigate to another page, etc.
  }

  @override
  Widget build(BuildContext context) {
    // if (ModalRoute.of(context)!.settings.arguments != null) {
    //   final Map<String, dynamic>? params =
    //   ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    //   name = params!['name'];
    //   id = params!['customerId'];
    //   pricegroupId = params!['price_group_id'];
    // }
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
                Navigator.pushReplacementNamed(context, CopyScreen.routeName,
                    arguments: {
                      'name': name,
                      'customerId': id,
                      'price_group_id': pricegroupId,
                      'outstandamt': paydata,
                      'code': code,
                      'paymentTerms': paymentTerms,
                    });
              },
              child: Icon(Icons.arrow_back)),
          iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
          title: const Text(
            'Copy Products',
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
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      controller: _searchData,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          hintText: "Search...",
                          hintStyle:
                              TextStyle(color: AppConfig.backgroundColor),
                          border: InputBorder.none),
                    ),
                  )
                : Container(),
            CommonWidgets.horizontalSpace(1),
            GestureDetector(
              onTap: () {
                setState(() {
                  _search = !_search;
                  if (!_search) {
                    _searchData.clear();
                  }
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
        body: filteredProducts.isEmpty
            ? Center(
                child: isLoading
                    ? Shimmer.fromColors(
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
                            ],
                          ),
                        ),
                      )
                    : Text('No products found'))
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading &&
                      hasMoreProducts &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    fetchProducts(currentPage);
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount:
                      filteredProducts.length + (hasMoreProducts ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredProducts.length) {
                      return Center(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "That's All",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ));
                    }

                    final product = filteredProducts[index];
                    return Card(
                      elevation: 3,
                      child: InkWell(
                        onTap: _isDialogOpen
                            ? null
                            : () {
                                setState(() {
                                  _isDialogOpen = true;
                                });
                                showProductDetailsDialog(context, product);
                              },
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 90,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            color: AppConfig.backgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                                          '${RestDatasource().Product_URL}/uploads/product/${product.proImage}'),
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
                                CommonWidgets.horizontalSpace(3),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Tooltip(
                                      message: product.name!.toUpperCase(),
                                      child: SizedBox(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 70,
                                        child: Text(
                                          '${product.code} | ${product.name!.toUpperCase()}',
                                          style: TextStyle(
                                              fontSize:
                                                  AppConfig.textCaption2Size),
                                        ),
                                      ),
                                    ),
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
              ),
      ),
    );
  }

  void showProductDetailsDialog(BuildContext context, Products product) async {
    List<TextEditingController> serialTextControllers = [];
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_product_with_units_by_products?store_id=${AppState().storeId}&van_id=${AppState().vanId}&id=${product.id}&customer_id=$id'));
    final typeResponse = await http
        .get(Uri.parse('${RestDatasource().BASE_URL}/api/get_product_type'));

    if (response.statusCode == 200 && typeResponse.statusCode == 200) {
      print(response.request);
      print(product.id);
      print("dbfdjfjbdfbjdjjdvddv");
      print(id);
      final data = jsonDecode(response.body);
      final units = data['data'] as List?;
      final lastsale = data['lastsale'];
      final typeData = jsonDecode(typeResponse.body);
      final productTypes = typeData['data'] as List;

      String? selectedUnitId;
      String? selectedProductTypeId;
      String? quantity;
      String? amount;
      double? availableStock;
      Map<String, dynamic>? selectedUnit;
      String? name;
      String? paydata;
      if (productTypes.isNotEmpty) {
        selectedProductTypeId = productTypes[0]['id'].toString();
      }

      final amountController = TextEditingController();
      if (units != null && units.any((unit) => unit != null)) {
        selectedUnitId = units[0]['id'].toString();
        selectedUnit = units[0];
        amountController.text = selectedUnit?['price']?.toString() ?? '';
        availableStock =
            double.tryParse(selectedUnit?['stock']?.toString() ?? '0');
      }
      bool isQuantityValid(String? value) {
        final quantityValue = double.tryParse(value ?? '') ?? 0;
        return value != null &&
            value.isNotEmpty &&
            quantityValue > 0 &&
            quantityValue <= (availableStock ?? 0);
      }

      if (ModalRoute.of(context)!.settings.arguments != null) {
        final Map<String, dynamic>? params =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        name = params!['name'];
        id = params!['customerId'];
        paydata = params!['outstandamt'];
        print("asasasasa");
        print(paydata);
      }
      void onSerialNumberChanged(int index) async {
        // bool isValid = await checkSerialNumber(value);
        setState(() {
          // isAvailable = isValid;
          // if (!isValid) {
          serialTextControllers[index].clear(); // Clear invalid serial
          // }
        });
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              Future<bool> checkSerialNumber(String serialNumber) async {
                print('AppState().storeId');
                print(AppState().storeId);
                const String apiUrl =
                    'http://68.183.92.8:3699/api/cash_sale_serial_checking';
                try {
                  final response = await http.post(
                    Uri.parse(apiUrl),
                    body: {
                      'store_id': AppState().storeId.toString(),
                      'product_serial': serialNumber,
                    },
                  );

                  print("Response body: ${response.body}");
                  if (response.statusCode != 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid Serial Number')),
                    );
                  }
                  if (response.statusCode == 200) {
                    setDialogState(() {
                      isAvailable = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Serial Number Available')),
                    );
                    print("sjdjfjdfjdv");
                    print(response.body);
                    final data = json.decode(response.body);

                    // Inspect the structure of `data` here
                    if (data.containsKey('is_valid') &&
                        data['is_valid'] == true) {
                      return true;
                    } else {
                      return false;
                    }
                  } else {
                    // Handle non-200 responses, possibly showing a message to the user
                    return false;
                  }
                } catch (e) {
                  print("Error checking serial number: $e");
                  return false;
                }
              }

              return AlertDialog(
                title: Text(
                  '${product.code} | ${product.name!}',
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp),
                ),
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
                              '${RestDatasource().Product_URL}/uploads/product/${product.proImage}',
                              height: 50.h,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('Assets/Images/no_image.jpg',
                                    height: 50.h);
                              },
                            ),
                            lastsale == null || lastsale.isEmpty
                                ? Text('No last records found')
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Sale:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Date: ${lastsale['date']}'),
                                      Text('Unit: ${lastsale['unit']}'),
                                      Text('Price: ${lastsale['price']}'),
                                    ],
                                  ),
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
                          SizedBox(height: 10.h),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Product Type',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 10.w),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
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

                                // Check if the selected product type is not "Normal"
                                final selectedType = productTypes.firstWhere(
                                  (type) => type['id'].toString() == value,
                                  orElse: () => null,
                                );

                                if (selectedType != null &&
                                    selectedType['name'] != 'Normal') {
                                  // Set amount to 0 if type is not "Normal"
                                  amountController.text = '0';
                                } else if (selectedUnit != null) {
                                  // Set amount to the selected unit's price if type is "Normal"
                                  amountController.text =
                                      selectedUnit?['price']?.toString() ?? '';
                                }
                              });
                            },
                            value: selectedProductTypeId,
                            hint: Text('Select Product Type'),
                          ),
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
                          SizedBox(height: 10.h),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: amountController,
                            decoration: InputDecoration(
                                labelText: 'Amount',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 10.w),
                                hintText: 'Amt',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey.shade300),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              quantity = value;
                              int count = int.tryParse(quantity ?? '') ?? 0;
                              setDialogState(() {
                                int qty = int.tryParse(value) ?? 0;
                                serialTextControllers = List.generate(
                                  qty,
                                  (index) => TextEditingController(),
                                );
                              });
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
                          if (product.serialbarcode_required == 'YES')
                            ...serialTextControllers
                                .asMap()
                                .entries
                                .map((entry) {
                              int i = entry.key;
                              TextEditingController controller = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: TextFormField(
                                  onChanged: (value) {
                                    print(isAvailable);
                                    setDialogState(() {
                                      isAvailable = false;
                                    });
                                  },
                                  controller: controller,
                                  decoration: InputDecoration(
                                    labelText: 'Serial No: ${i + 1}',
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 2.h, horizontal: 10.w),
                                    hintText: 'Enter value',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                  ),
                                  onFieldSubmitted: (value) async {
                                    // bool isValid =
                                    await checkSerialNumber(value);
                                    if (!isAvailable) onSerialNumberChanged(i);
                                    // if (!isValid) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     SnackBar(
                                    //         content:
                                    //             Text('Invalid Serial Number')),
                                    //   );
                                    // }
                                  },
                                ),
                              );
                            }).toList(),
                          if (product.serialbarcode_required != 'YES')
                            Text('No units available for this product.'),
                          SizedBox(height: 10.h),
                        ]
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
                          backgroundColor:
                              isQuantityValid(quantity) && isAvailable
                                  ? AppConfig.colorPrimary
                                  : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r))),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: isQuantityValid(quantity) && isAvailable
                          ? () async {
                              print('isAvailable');
                              print(isAvailable);
                              final prefs =
                                  await SharedPreferences.getInstance();
                              List<String>? selectedProducts =
                                  prefs.getStringList('selected_products');
                              selectedProducts ??= [];
                              final serialNumber = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString() +
                                  '-' +
                                  (1000 + (DateTime.now().microsecond % 9000))
                                      .toString();
                              List<String> serialNumbers = serialTextControllers
                                  .map((controller) => controller.text)
                                  .where((text) => text.isNotEmpty)
                                  .toList();
                              final selectedProduct = {
                                'serial_number': serialNumber,
                                'id': product.id,
                                'code': product.code,
                                'name': product.name,
                                'pro_image': product.proImage,
                                'type_id': selectedProductTypeId,
                                'type_name': productTypes.firstWhere((type) =>
                                    type['id'].toString() ==
                                    selectedProductTypeId)['name'],
                                'unit_id': selectedUnitId,
                                'unit_name': selectedUnit?['name'],
                                'quantity': quantity ?? '',
                                'amount': amountController.text ?? '',
                                'serial_numbers': serialNumbers
                              };
                              selectedProducts.add(jsonEncode(selectedProduct));
                              print(selectedProduct);
                              await prefs.setStringList(
                                  'selected_products', selectedProducts);
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, CopyScreen.routeName,
                                  arguments: {
                                    'name': name,
                                    'customerId': id,
                                    'outstandamt': paydata,
                                    'code': code,
                                    'price_group_id': pricegroupId,
                                    'paymentTerms': paymentTerms,
                                  }).then((value) {
                                // _initDone = false;
                                // _getTypes();
                                print("bfbfbfbfbfb");
                                print(paydata);
                              });
                            }
                          : null,
                    ),
                  ] else ...[
                    SizedBox.shrink(),
                  ],
                ],
              );
            },
          );
        },
      ).then((_) {
        _isDialogOpen =
            false; // Reset the flag if the dialog is dismissed by other means
      });
    }
  }
}
