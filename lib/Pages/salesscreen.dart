import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobizapp/Models/vanstockdata.dart';

import '../Models/salesdata.dart';
import '../Models/typedetails.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../Components/commonwidgets.dart';
import '../Models/appstate.dart';
import '../confg/sizeconfig.dart';
import 'customerscreen.dart';
import 'salesselectproducts.dart';

class SalesScreen extends StatefulWidget {
  static const routeName = "/ScalesScreen";
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _searchData = TextEditingController();
  final TextEditingController _discountData = TextEditingController();

  List<TextEditingController> _qtyData = [];
  List<TextEditingController> _rateData = [];

  bool _search = false;
  bool _isSale = false;
  bool _initDone = false;
  bool _isPercentage = false;
  int _ifVat = 1;
  List<Map<String, dynamic>> stocks = [];
  num subTotal = 0;
  num discount = 0;
  num total = 0;
  num grandTotal = 0;
  num roundedTotal = 0;
  num tax = 0;
  int? id;
  String? name;
  String? _previousRate;
  TypesData typeDetails = TypesData();

  List<String?> selectedValue = [" "];
  List<String?> selectedTypeData = [" "];
  List<List<DropdownMenuItem<String>>> menuItems = [[]];
  List<List<DropdownMenuItem<String>>> typeItems = [[]];
  List<Map<String, dynamic>?> selectedId = [];
  List<Map<String, dynamic>?> selectedTypes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTypes();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['customerId'];
      name = params!['name'];
    }
    return WillPopScope(
      onWillPop: () async {
        if (_isSale) {
          SaleskHistory.clearAllSalesHistory().then((value) =>
              Navigator.of(context)
                  .pushReplacementNamed(CustomersDataScreen.routeName));
        }
        SaleskHistory.clearAllSalesHistory();
        return true;
      },
      child: Scaffold(
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
                          hintStyle:
                              TextStyle(color: AppConfig.backgroundColor),
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
                // setState(() {
                //   _search = !_search;
                Navigator.pushReplacementNamed(
                    context, SalesSelectProductsScreen.routeName,
                    arguments: {'customerId': id, 'name': name}).then((value) {
                  _initDone = false;
                  _getTypes();
                });

                //});
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
              backgroundColor: (stocks.isNotEmpty)
                  ? const WidgetStatePropertyAll(AppConfig.colorPrimary)
                  : const WidgetStatePropertyAll(AppConfig.buttonDeactiveColor),
            ),
            onPressed: (stocks.isNotEmpty)
                ? () async {
                    _sendRequest();
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
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        _calculateTotal();
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
                        _calculateTotal();
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
                CommonWidgets.verticalSpace(1),
                (_initDone)
                    ? SizedBox(
                        height: SizeConfig.blockSizeVertical * 63,
                        child: ListView.separated(
                          itemCount: stocks.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _stockCard(stocks[index], index);
                          },
                          separatorBuilder: (context, index) {
                            return CommonWidgets.verticalSpace(1);
                          },
                        ),
                      )
                    : Container(),
                (_initDone && stocks.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.only(right: 18.0),
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
                                                          double.parse((value
                                                                      .isEmpty)
                                                                  ? '0'
                                                                  : value) >
                                                              100 ||
                                                      !_isPercentage &&
                                                          double.parse((value
                                                                      .isEmpty)
                                                                  ? '0'
                                                                  : value) >
                                                              roundedTotal) {
                                                    CommonWidgets.showDialogueBox(
                                                        context: context,
                                                        title: 'Error',
                                                        msg:
                                                            'Invalid Discount');
                                                  } else {
                                                    total = 0;
                                                    tax = 0;
                                                    discount = double.parse(
                                                        (value.isEmpty)
                                                            ? '0'
                                                            : value);
                                                    _calculateTotal();
                                                  }
                                                });
                                              },
                                              keyboardType:
                                                  TextInputType.number,
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
                                      width:
                                          SizeConfig.blockSizeHorizontal * 17,
                                      height: SizeConfig.blockSizeVertical * 3,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppConfig
                                                  .buttonDeactiveColor),
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
                            Text(
                              'Total : $total',
                              style: TextStyle(
                                  fontSize: AppConfig.textCaption3Size),
                            ),
                            Text(
                              'Tax : ${tax.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: AppConfig.textCaption3Size),
                            ),
                            (roundedTotal != 0)
                                ? Text(
                                    'Round Off. : ${(roundedTotal - grandTotal).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: AppConfig.textCaption3Size),
                                  )
                                : Container(),
                            Text(
                              'Grand Total : ${(_ifVat == 0) ? (roundedTotal - tax) : roundedTotal}',
                              style: TextStyle(
                                  fontSize: AppConfig.textCaption3Size),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stockCard(Map<dynamic, dynamic> data, int index) {
    return Card(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(5),
        width: SizeConfig.blockSizeHorizontal * 90,
        decoration: BoxDecoration(
          color: AppConfig.backgroundColor,
          border:
              Border.all(color: AppConfig.buttonDeactiveColor.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  height: 60,
                  child: FadeInImage(
                    image: NetworkImage(
                        'https://mobiz-shop.yes45.in/uploads/product/${data['image']}'),
                    placeholder: const AssetImage('Assets/Images/no_image.jpg'),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('Assets/Images/no_image.jpg',
                          fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
                CommonWidgets.horizontalSpace(1),
                Column(
                  children: [
                    CommonWidgets.verticalSpace(1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidgets.horizontalSpace(1),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 70,
                          child: Text(
                              '${data['code']} | ${data['name'].toString().toUpperCase()}',
                              style: TextStyle(
                                fontSize: AppConfig.textCaption3Size,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    radius: 10,
                    child: GestureDetector(
                      onTap: () async {
                        await SaleskHistory.clearSalesHistory(data['icode'])
                            .then(
                          (value) {
                            _getTypes();
                          },
                        );
                      },
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.red,
                      ),
                    ))
              ],
            ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 90,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minWidth: SizeConfig.blockSizeHorizontal * 11,
                      ),
                      height: SizeConfig.blockSizeVertical * 2.5,
                      // ),
                      // decoration: BoxDecoration(
                      //     border:
                      //         Border.all(color: AppConfig.buttonDeactiveColor),
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(10))),
                      child: DropdownButton(
                        isDense: true,
                        icon: const SizedBox(),
                        alignment: Alignment.center,
                        underline: Container(),
                        value: selectedTypeData[index],
                        style: TextStyle(
                            color: AppConfig.colorPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: AppConfig.textCaption3Size),
                        onChanged:  (String? newValue) async {
                          if (newValue != null) {
                            setState(() {
                              selectedTypeData[index] = newValue;
                            });

                            if (newValue.toLowerCase() == 'foc' ||
                                newValue.toLowerCase() == 'change') {
                              _previousRate = _rateData[index].text;
                              _rateData[index].text = '0';
                            } else if (newValue.toLowerCase() == 'Normal') {
                              if (_previousRate != null) {
                                _rateData[index].text = _previousRate!;
                              } else {
                                // Set to the default rate if _previousRate is not set
                                for (var unit in data['unitData']) {
                                  if (unit['name'] == selectedValue[index]) {
                                    _rateData[index].text = unit['price'];
                                  }
                                }
                              }
                            } else {
                              // Handle 'Change' case or other cases
                              for (var unit in data['unitData']) {
                                if (unit['name'] == selectedValue[index]) {
                                  _rateData[index].text = unit['price'];
                                }
                              }
                            }

                            total = 0;
                            tax = 0;
                            _calculateTotal();
                          }
                        },
                        items: typeItems[index],
                      ),
                    ),
                    // CommonWidgets.horizontalSpace(1),

                    // Text(
                    //   'Unit',
                    //   style: TextStyle(
                    //       color: Color.fromARGB(255, 111, 110, 110),
                    //       fontSize: AppConfig.textCaption3Size),
                    // ),
                    // CommonWidgets.horizontalSpace(0.7),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical * 2.5,
                    //   child: DropdownButton(
                    //     value: selectedTypeData[index],
                    //     onChanged: (String? newValue) async {
                    //       if (newValue != null) {
                    //         setState(() {
                    //           selectedTypeData[index] = newValue;
                    //         });
                    //
                    //         if (newValue.toLowerCase() == 'foc' ||
                    //             newValue.toLowerCase() == 'change') {
                    //           _previousRate = _rateData[index].text;
                    //           _rateData[index].text = '0';
                    //         } else if (newValue.toLowerCase() == 'Normal') {
                    //           if (_previousRate != null) {
                    //             _rateData[index].text = _previousRate!;
                    //           } else {
                    //             // Set to the default rate if _previousRate is not set
                    //             for (var unit in data['unitData']) {
                    //               if (unit['name'] == selectedValue[index]) {
                    //                 _rateData[index].text = unit['price'];
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           // Handle 'Change' case or other cases
                    //           for (var unit in data['unitData']) {
                    //             if (unit['name'] == selectedValue[index]) {
                    //               _rateData[index].text = unit['price'];
                    //             }
                    //           }
                    //         }
                    //
                    //         total = 0;
                    //         tax = 0;
                    //         _calculateTotal();
                    //       }
                    //     },
                    //     items: typeItems[index],
                    //   ),
                    // ),

                    CommonWidgets.horizontalSpace(1),
                    const Text('|'),
                    CommonWidgets.horizontalSpace(1),
                    Text(
                      'Qty :',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 111, 110, 110),
                          fontSize: AppConfig.textCaption3Size),
                    ),
                    CommonWidgets.horizontalSpace(0.5),
                    InkWell(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Quantity'),
                                  content: TextField(
                                    onChanged: (value) async {
                                      int max = 1;
                                      for (var i in stocks[index]['unitData']) {
                                        if (i['name'] == selectedValue[index]) {
                                          max = i['stock'];
                                        }
                                      }
                                      if (num.parse(value) > max) {
                                        _qtyData[index].text = '1';
                                        CommonWidgets.showDialogueBox(
                                            context: context,
                                            title: 'Error',
                                            msg:
                                                'Please enter smaller quantity.');
                                      } else {
                                        if (num.parse(value) == 0) {
                                          await SaleskHistory.updateSaleItem(
                                              data['icode'], 'quantity', 1);
                                          _qtyData[index].text = '1';
                                        } else {
                                          await SaleskHistory.updateSaleItem(
                                              data['icode'],
                                              'quantity',
                                              int.parse(value));
                                          _qtyData[index].text = value;
                                        }
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: _qtyData[index],
                                    decoration: const InputDecoration(
                                        hintText: "Quantity"),
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                      color: AppConfig.colorPrimary,
                                      textColor: Colors.white,
                                      child: const Text('OK'),
                                      onPressed: () {
                                        if (_qtyData[index].text == '') {
                                          _qtyData[index].text =
                                              data['quantity'].toString();
                                        }
                                        Navigator.pop(context);
                                        tax = 0;
                                        total = 0;
                                        _calculateTotal();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: SizedBox(
                          child: Text(
                            _qtyData[index].text,
                            style: TextStyle(
                                color: AppConfig.colorPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: AppConfig.textCaption3Size),
                          ),
                        )
                        // _dataContainer(data:),
                        ),
                    // Container(
                    //   width: SizeConfig.blockSizeHorizontal * 15,
                    //   height: SizeConfig.blockSizeVertical * 2.5,
                    //   decoration: BoxDecoration(
                    //       border:
                    //           Border.all(color: AppConfig.buttonDeactiveColor),
                    //       borderRadius:
                    //           const BorderRadius.all(Radius.circular(10))),
                    //   child: TextField(
                    //     controller: _qtyData[index],
                    //     textAlign: TextAlign.center,
                    //     keyboardType: TextInputType.number,
                    //     style: TextStyle(
                    //         fontSize: AppConfig.textCaption3Size * 0.9),
                    //     decoration:
                    //         const InputDecoration(border: InputBorder.none),
                    //     onChanged: (value) {
                    //       if (value.isNotEmpty && int.parse(value) > 0) {
                    //         SaleskHistory.updateSaleItem(
                    //             data['itemId'], 'quantity', int.parse(value));
                    //         _getTypes();
                    //       }
                    //     },
                    //   ),
                    // ),
                    // CommonWidgets.horizontalSpace(1),
                    CommonWidgets.horizontalSpace(1),
                    const Text('|'),
                    CommonWidgets.horizontalSpace(1),
                    Text(
                      'Rate :',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 111, 110, 110),
                          fontSize: AppConfig.textCaption3Size),
                    ),
                    CommonWidgets.horizontalSpace(0.5),
                    InkWell(
                      onTap: (data['selectedType'].toString().toLowerCase() !=
                              'foc')
                          ? () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Rate'),
                                      content: TextField(
                                        onChanged: (value) async {
                                          _rateData[index].text = value;
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: _rateData[index],
                                        decoration: const InputDecoration(
                                            hintText: "Rate"),
                                      ),
                                      actions: <Widget>[
                                        MaterialButton(
                                          color: AppConfig.colorPrimary,
                                          textColor: Colors.white,
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);

                                            tax = 0;
                                            total = 0;
                                            _calculateTotal();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          : null,
                      child: Text(
                        _rateData[index].text,
                        style: TextStyle(
                            color: AppConfig.colorPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: AppConfig.textCaption3Size),
                      ),
                    ),
                    CommonWidgets.horizontalSpace(1),
                    const Text('|'),
                    CommonWidgets.horizontalSpace(1),
                    Text(
                      'Amt :${num.parse(_rateData[index].text) * (num.parse(_qtyData[index].text))}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 111, 110, 110),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getStockData() async {
    subTotal = 0;
    discount = 0;
    total = 0;
    roundedTotal = 0;
    tax = 0;
    print('Sales data $stocks');
    menuItems = List.generate(stocks.length, (_) => []);
    selectedValue = List.filled(stocks.length, '');
    selectedId = List.filled(stocks.length, {});
    _qtyData = List.generate(stocks.length, (_) => TextEditingController());
    _rateData = List.generate(stocks.length, (_) => TextEditingController());

    for (int index = 0; index < stocks.length; index++) {
      List<dynamic> listData = stocks[index]['unitData'];
      for (int i = 0; i < listData.length; i++) {
        menuItems[index].add(DropdownMenuItem(
            value: (listData[i]['name']).toString(),
            child: Text((listData[i]['name']).toString())));
        selectedValue[index] = (stocks[index]['selectedUnit'] != null)
            ? stocks[index]['selectedUnit']
            : listData[0]['name'].toString();
        selectedId[index] = {
          'name': listData[i]['name'].toString(),
          'id': listData[i]['id'],
          'price': listData[i]['price'],
          'minPrice': listData[i]['minPrice']
        };
      }

      print('Response ${stocks[index]['unitData']}');

      _qtyData[index].text = stocks[index]['quantity'].toString();
      for (var k in stocks[index]['unitData']) {
        for (int j = 0; j < k.length; j++) {
          if (k['name'] == selectedValue[index]) {
            _rateData[index].text =
                (stocks[index]['selectedType'].toString().toLowerCase() ==
                        "foc")
                    ? '0'
                    : k['price'];
          }
        }
      }
    }

    _calculateTotal();
  }

  _dataContainer({required String data}) {
    return Container(
      height: SizeConfig.blockSizeVertical * 3,
      constraints: BoxConstraints(
        minWidth: SizeConfig.blockSizeHorizontal * 15,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: AppConfig.buttonDeactiveColor),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Text(
          data,
          style: TextStyle(fontSize: AppConfig.textCaption3Size),
        ),
      ),
    );
  }

  int customRound(double value) {
    double fractionalPart = value - value.toInt();

    if (fractionalPart >= 0.5) {
      return value.ceil();
    } else {
      return value.floor();
    }
  }

  void _calculateTotal({num? qty}) {
    for (int i = 0; i < stocks.length; i++) {
      if (selectedTypeData[i] == "FOC" || _ifVat == 0) {
        tax = tax;
      } else {
        tax = tax +
            (((num.parse(_rateData[i].text) * stocks[i]['tax']) / 100) *
                num.parse(_qtyData[i].text));
      }
      total =
          total + (num.parse(_rateData[i].text) * num.parse(_qtyData[i].text));
    }
    num percentValue =
        (_discountData.text.isNotEmpty) ? num.parse(_discountData.text) : 0;
    grandTotal = total + tax;

    if (percentValue > 0) {
      if (_isPercentage) {
        grandTotal = grandTotal - (grandTotal * (percentValue / 100));
      } else {
        grandTotal = grandTotal - percentValue;
      }
    }

    roundedTotal = customRound(double.parse((grandTotal).toString()));
    print('Calc $grandTotal $tax $discount');
    if (mounted) {
      setState(() {
        _initDone = true;
      });
    }
  }

  Future<void> _sendRequest() async {
    RestDatasource api = RestDatasource();
    stocks = await SaleskHistory.getSalesHistory();
    Map<String, dynamic> bodyJson = {
      'van_id': AppState().vanId,
      'store_id': AppState().storeId,
      'user_id': AppState().userId,
      'item_id': [],
      'quantity': [],
      'unit': [],
      'mrp': [],
      'product_type': [],
      'customer_id': id,
      'if_vat': _ifVat,
      'total_tax': tax,
      "total": total,
      "discount": discount,
      "round_off": ' ${(roundedTotal - grandTotal).toStringAsFixed(2)}',
      "grand_total": roundedTotal
    };
    int units = 0;
    int? type;

    for (int i = 0; i < stocks.length; i++) {
      for (var j in stocks[i]['unitData']) {
        if (j['name'] == selectedValue[i]) {
          units = j['id'];
        }
        for (int k = 0; k < typeDetails.data!.length; k++) {
          if (typeDetails.data![k].name == selectedTypeData[i]) {
            type = typeDetails.data![k].id;
          }
        }
      }

      //stocks
      bodyJson["item_id"].add(stocks[i]["itemId"]);
      bodyJson["quantity"].add(_qtyData[i].text);
      bodyJson["mrp"].add(_rateData[i].text);
      bodyJson["unit"].add(units);
      bodyJson['product_type'].add(type!);
    }

    print('BodyJson $bodyJson');
    dynamic resJson = await api.sendData(
        '/api/vansale.store', AppState().token, jsonEncode(bodyJson));
    debugPrint('Body Data $bodyJson');
    setState(() {
      _initDone = true;
    });
    if (resJson['data'] != null) {
      _isSale = true;
      if (mounted) {
        CommonWidgets.showDialogueBox(
                context: context,
                title: "Alert",
                msg: "${resJson['data']['invoice_no']} Created Successfully")
            .then(
          (value) => SaleskHistory.clearAllSalesHistory().then(
            (value) => Navigator.of(context)
                .pushReplacementNamed(CustomersDataScreen.routeName),
          ),
        );
      }
    }
  }

  _getTypes() async {
    RestDatasource api = RestDatasource();
    stocks = await SaleskHistory.getSalesHistory();
    Map<String, dynamic> resJson =
        await api.getDetails('/api/get_product_type', null);
    typeDetails = TypesData.fromJson(resJson);
    typeItems = List.generate(stocks.length, (_) => []);
    selectedTypeData = List.filled(stocks.length, '');
    selectedTypes = List.filled(stocks.length, {});

    for (int index = 0; index < stocks.length; index++) {
      print('selected values');
      for (int i = 0; i < typeDetails.data!.length; i++) {
        typeItems[index].add(DropdownMenuItem(
            value: (typeDetails.data![i].name).toString(),
            child: Text(((typeDetails.data![i].name).toString()))));
        selectedTypeData[index] = (stocks[index]['selectedType'] != null)
            ? stocks[index]['selectedType']
            : typeDetails.data![0].name!;

        print('selected values ${selectedTypeData[index]}');
        selectedTypes[index] = {
          'name': typeDetails.data![i].name,
          'id': typeDetails.data![i].id
        };
      }
    }

    _getStockData();
  }
}
