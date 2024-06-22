import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobizapp/Components/commonwidgets.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/confg/sizeconfig.dart';
import 'package:shimmer/shimmer.dart';

import '../Models/paymentcollectionclass.dart';
import '../confg/appconfig.dart';

class PaymentCollectionScreen extends StatefulWidget {
  static const routeName = "/PaymentCollection";
  const PaymentCollectionScreen({super.key});

  @override
  State<PaymentCollectionScreen> createState() =>
      _PaymentCollectionScreenState();
}

class _PaymentCollectionScreenState extends State<PaymentCollectionScreen> {
  int cuId = 0;
  bool _initDone = false;
  bool _noData = false;
  PaymentCollectionData paymentData = PaymentCollectionData();
  num outStandingAmt = 0;
  num allocatedAmt = 0;
  num balanceAmt = 0;
  num paidAmt = 0;
  bool tapEnabled = true;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String dropdownvalue = 'Cash';

  // List of items in our dropdown menu
  var items = ['Cash', 'Cheque'];

  List<num> _payments = [];
  List<int> _godsId = [];
  List<bool> _expand = [];

  final TextEditingController _paidAmt = TextEditingController();
  final TextEditingController _bank = TextEditingController();
  final TextEditingController _cheqNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      cuId = params!['customer'];
    }
    if (!_initDone) {
      _getPaymentDetails().then((value) => _getOutStanding());
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        foregroundColor: AppConfig.backgroundColor,
        title: const Text('Payment Collection'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: (_noData && _initDone)
              ? const Text('No Data')
              : (!_noData && _initDone)
                  ? SizedBox(
                      height: SizeConfig.safeBlockVertical! * 87,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${paymentData.data![0].customer![0].code} | ${paymentData.data![0].customer![0].name} | Bill to Bill',
                            style: const TextStyle(
                                color: AppConfig.buttonDeactiveColor),
                          ),
                          CommonWidgets.verticalSpace(2),
                          Row(
                            children: [
                              const Text(
                                'Total outstanding',
                                style: TextStyle(
                                    color: AppConfig.buttonDeactiveColor),
                              ),
                              CommonWidgets.horizontalSpace(1),
                              _inputBox(
                                  status: false, value: "$outStandingAmt"),
                              const Spacer(),
                              const Text(
                                'Paid Amount',
                                style: TextStyle(
                                    color: AppConfig.buttonDeactiveColor),
                              ),
                              CommonWidgets.horizontalSpace(1),
                              InkWell(
                                  onTap: () {
                                    balanceAmt = 0;
                                    paidAmt = 0;
                                    allocatedAmt = 0;
                                    _payments = List.generate(
                                        paymentData.data!.length, (_) => 0);
                                    _godsId = List.generate(
                                        paymentData.data!.length, (_) => 0);

                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Paid Amount'),
                                            content: TextField(
                                              onChanged: (value) async {},
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _paidAmt,
                                              decoration: const InputDecoration(
                                                  hintText: "Paid Amount"),
                                            ),
                                            actions: <Widget>[
                                              MaterialButton(
                                                color: AppConfig.colorPrimary,
                                                textColor: Colors.white,
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  paidAmt =
                                                      num.parse(_paidAmt.text);
                                                  tappedIndices.clear();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        }).then((value) => setState(() {}));
                                  },
                                  child: _inputBox(
                                      status: true,
                                      value: (_paidAmt.text.isEmpty)
                                          ? '0'
                                          : _paidAmt.text)),
                            ],
                          ),
                          CommonWidgets.verticalSpace(1),
                          Row(
                            children: [
                              const Text(
                                'Allocated Amount',
                                style: TextStyle(
                                    color: AppConfig.buttonDeactiveColor),
                              ),
                              CommonWidgets.horizontalSpace(1),
                              _inputBox(status: false, value: "$allocatedAmt"),
                              const Spacer(),
                              const Text(
                                'Balance Amount',
                                style: TextStyle(
                                    color: AppConfig.buttonDeactiveColor),
                              ),
                              CommonWidgets.horizontalSpace(1),
                              _inputBox(status: false, value: "$balanceAmt"),
                            ],
                          ),
                          CommonWidgets.verticalSpace(2),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 56,
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return CommonWidgets.verticalSpace(1);
                              },
                              itemCount: paymentData.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => _paymentData(
                                  index: index,
                                  title:
                                      '${DateFormat('dd MMMM yyyy').format(DateTime.parse(paymentData.data![index].inDate!))} | ${paymentData.data![index].invoiceNo}',
                                  balance:
                                      (paymentData.data![index].grandTotal! -
                                          paymentData.data![index].receipt!),
                                  paid: paymentData.data![index].receipt ?? 0,
                                  amount:
                                      paymentData.data![index].grandTotal ?? 0,
                                  id: paymentData.data![index].id!,
                                  collection:
                                      paymentData.data![index].collection),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                    color: AppConfig.buttonDeactiveColor)),
                            width: SizeConfig.screenWidth,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Collection Type',
                                          style: TextStyle(
                                              color: AppConfig
                                                  .buttonDeactiveColor),
                                        ),
                                        CommonWidgets.horizontalSpace(1),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: AppConfig
                                                    .buttonDeactiveColor,
                                              )),
                                          constraints: BoxConstraints(
                                            minWidth:
                                                SizeConfig.blockSizeHorizontal *
                                                    13,
                                          ),
                                          height:
                                              SizeConfig.blockSizeVertical * 3,
                                          child: DropdownButton(
                                            // Initial Value
                                            value: dropdownvalue,
                                            icon: const SizedBox(),
                                            underline: const SizedBox(),
                                            // Array list of items
                                            items: items.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownvalue = newValue!;
                                              });
                                            },
                                          ),
                                        ),
                                        // _inputBox(
                                        //     status: true, value: "Cheque"),
                                        (dropdownvalue != "Cash")
                                            ? const Spacer()
                                            : Container(),
                                        (dropdownvalue != "Cash")
                                            ? const Text(
                                                'Bank',
                                                style: TextStyle(
                                                    color: AppConfig
                                                        .buttonDeactiveColor),
                                              )
                                            : Container(),
                                        (dropdownvalue != "Cash")
                                            ? CommonWidgets.horizontalSpace(1)
                                            : Container(),
                                        (dropdownvalue != "Cash")
                                            ? InkWell(
                                                onTap: () {
                                                  showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Bank'),
                                                              content:
                                                                  TextField(
                                                                onChanged:
                                                                    (value) async {},
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                controller:
                                                                    _bank,
                                                                decoration:
                                                                    const InputDecoration(
                                                                        hintText:
                                                                            "Bank"),
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
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          })
                                                      .then((value) =>
                                                          setState(() {}));
                                                },
                                                child: _inputBox(
                                                    status: true,
                                                    value: (_bank.text.isEmpty)
                                                        ? ''
                                                        : _bank.text),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    CommonWidgets.verticalSpace(1),
                                    (dropdownvalue != "Cash")
                                        ? Row(
                                            children: [
                                              const Text(
                                                'Cheque Date',
                                                style: TextStyle(
                                                    color: AppConfig
                                                        .buttonDeactiveColor),
                                              ),
                                              CommonWidgets.horizontalSpace(1),
                                              InkWell(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(1950),
                                                          //DateTime.now() - not to allow to choose before today.
                                                          lastDate:
                                                              DateTime(2100));

                                                  if (pickedDate != null) {
                                                    formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);
                                                  } else {}
                                                },
                                                child: _inputBox(
                                                    status: true,
                                                    value: "$formattedDate"),
                                              ),
                                              const Spacer(),
                                              const Text(
                                                'Cheque No',
                                                style: TextStyle(
                                                    color: AppConfig
                                                        .buttonDeactiveColor),
                                              ),
                                              CommonWidgets.horizontalSpace(1),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Cheque No'),
                                                              content:
                                                                  TextField(
                                                                onChanged:
                                                                    (value) async {},
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                controller:
                                                                    _cheqNo,
                                                                decoration:
                                                                    const InputDecoration(
                                                                        hintText:
                                                                            "Cheque No"),
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
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          })
                                                      .then((value) =>
                                                          setState(() {}));
                                                },
                                                child: _inputBox(
                                                    status: true,
                                                    value:
                                                        (_cheqNo.text.isEmpty)
                                                            ? ""
                                                            : _cheqNo.text),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                )),
                          ),
                          CommonWidgets.verticalSpace(2),
                          Center(
                            child: SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 25,
                              height: SizeConfig.blockSizeVertical * 3,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                        (_paidAmt.text.isNotEmpty &&
                                                allocatedAmt ==
                                                    num.parse(_paidAmt.text))
                                            ? AppConfig.colorPrimary
                                            : Colors.grey)
                                    // : const MaterialStatePropertyAll(
                                    //     AppConfig.buttonDeactiveColor),
                                    ),
                                onPressed: () {
                                  if (allocatedAmt ==
                                      num.parse(_paidAmt.text)) {
                                    _postData();
                                  }
                                },
                                child: Text(
                                  'SAVE',
                                  style: TextStyle(
                                      fontSize: AppConfig.textCaption3Size,
                                      color: AppConfig.backgroundColor,
                                      fontWeight: AppConfig.headLineWeight),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Shimmer.fromColors(
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
                    ),
        ),
      ),
    );
  }

  Widget _inputBox({required String value, required bool status}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppConfig.buttonDeactiveColor,
          )),
      constraints: BoxConstraints(
        minWidth: SizeConfig.blockSizeHorizontal * 13,
        minHeight: SizeConfig.blockSizeVertical * 3,
      ),
      child: Center(
          child: Text(
        '$value',
        style: TextStyle(
            color:
                (status) ? AppConfig.textBlack : AppConfig.buttonDeactiveColor),
      )),
    );
  }

  void _showInputDialog(BuildContext context, int index) {
    TextEditingController _textFieldController =
        TextEditingController(text: _payments[index].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter value'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: _textFieldController,
            decoration: InputDecoration(
              hintText: "Enter your value here",
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: AppConfig.colorPrimary,
              textColor: Colors.white,
              child: Text('OK'),
              onPressed: () {
                num enteredValue = num.tryParse(_textFieldController.text) ?? 0;
                num maxAllowedValue = paymentData.data![index].grandTotal ?? 0;
                if (enteredValue > maxAllowedValue) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Entered value cannot exceed $maxAllowedValue'),
                    ),
                  );
                } else {
                  setState(() {
                    _payments[index] = enteredValue;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Set<int> tappedIndices = Set();
  void handleTap(int index, num amount, int id) {
    if (paidAmt > 0) {
      if (amount <= paidAmt) {
        _payments[index] = amount;
        paidAmt = paidAmt - amount;
        allocatedAmt = allocatedAmt + _payments[index];
        _godsId[index] = id;
      } else {
        _payments[index] = paidAmt;
        paidAmt = paidAmt - _payments[index];
        allocatedAmt = allocatedAmt + _payments[index];
        _godsId[index] = id;
      }
      balanceAmt = num.parse(_paidAmt.text) - allocatedAmt;
      setState(() {});
    }
  }

  Widget _paymentData(
      {required int index,
      required String title,
      required num amount,
      required num balance,
      required num paid,
      required int id,
      required List<Collection>? collection}) {
    var pipe = const Text('|');
    return InkWell(
      onTap: tappedIndices.contains(index)
          ? null
          : () {
              handleTap(index, amount, id);
              tappedIndices.add(index);
            },
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(
                color: AppConfig.buttonDeactiveColor.withOpacity(0.3)),
            color: AppConfig.backgroundColor,
          ),
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: SizeConfig.blockSizeHorizontal * 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title),
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            _showInputDialog(context, index);
                          },
                          child: _inputBox(
                            value: "${_payments[index]}",
                            status: true,
                          )),
                    ],
                  ),
                  CommonWidgets.verticalSpace(1),
                  InkWell(
                    onTap: () => setState(() {
                      _expand[index] = !_expand[index];
                    }),
                    child: Row(
                      children: [
                        Text(
                          'Amount $amount',
                          style: const TextStyle(
                              color: AppConfig.buttonDeactiveColor),
                        ),
                        CommonWidgets.horizontalSpace(1),
                        pipe,
                        CommonWidgets.horizontalSpace(1),
                        Text(
                          'Paid $paid',
                          style: const TextStyle(
                              color: AppConfig.buttonDeactiveColor),
                        ),
                        CommonWidgets.horizontalSpace(1),
                        pipe,
                        CommonWidgets.horizontalSpace(1),
                        Text(
                          'Balance $balance',
                          style: const TextStyle(
                              color: AppConfig.buttonDeactiveColor),
                        ),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  (_expand[index]) ? const Divider() : Container(),
                  (_expand[index])
                      ? (collection != null)
                          ? ListView.builder(
                              // separatorBuilder: (context, index) {
                              //   return CommonWidgets.verticalSpace(0.0);
                              // },
                              itemCount: collection.length,
                              shrinkWrap: true,
                              itemBuilder: (context, j) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (collection[j].collectionType != null)
                                          ? (collection[j]
                                                      .collectionType!
                                                      .toLowerCase() ==
                                                  "cheque")
                                              ? Text(
                                                  '${DateFormat('dd MMMM yyyy').format(DateTime.parse(collection[j].inDate!))} | ${collection[j].voucherNo} | ${collection[j].amount} | ${collection[index].collectionType} |  ${collection[index].chequeNo} ')
                                              : Text(
                                                  '${DateFormat('dd MMMM yyyy').format(DateTime.parse(collection[j].inDate!))} | ${collection[j].voucherNo} | ${collection[j].amount} | ${collection[index].collectionType ?? ''} ')
                                          : Text(
                                              '${DateFormat('dd MMMM yyyy').format(DateTime.parse(collection[j].inDate!))} | ${collection[j].voucherNo} | ${collection[j].amount} '),
                                      CommonWidgets.verticalSpace(2),
                                    ],
                                  ))
                          : Container()
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getPaymentDetails() async {
    RestDatasource api = RestDatasource();
    dynamic response = await api.getDetails(
        '/api/get_sales_pending_collection?customer_id=$cuId',
        AppState().token);

    if (response['data'] != null) {
      paymentData = PaymentCollectionData.fromJson(response);
      _payments = List.generate(paymentData.data!.length, (_) => 0);
      _godsId = List.generate(paymentData.data!.length, (_) => 0);
      _expand = List.generate(paymentData.data!.length, (_) => false);
    } else {
      _noData = true;
    }
  }

  Future<void> _getOutStanding() async {
    RestDatasource api = RestDatasource();
    dynamic response = await api.getDetails(
        '/api/get_sales_pending_outstanding?customer_id=$cuId',
        AppState().token);

    if (response['status'] == "success") {
      outStandingAmt = response['result']['data'];
    } else {
      outStandingAmt = 0;
    }
    setState(() {
      _initDone = true;
    });
  }

  Future _postData() async {
    List tempPayments = _payments;
    List temgoodId = _godsId;
    tempPayments.removeWhere((element) => element == 0);
    temgoodId.removeWhere((element) => element == 0);
    RestDatasource api = RestDatasource();
    String subUrl = '/api/collection.post';
    Map<String, dynamic> bodyJson = {
      'van_id': AppState().vanId,
      'store_id': AppState().storeId,
      'user_id': AppState().userId,
      'goods_out_id': temgoodId,
      'amount': tempPayments,
      'customer_id': cuId,
      'collection_type': dropdownvalue,
      if (dropdownvalue == "Cheque") "cheque_no": _cheqNo.text,
      if (dropdownvalue == "Cheque") "bank": _bank.text,
      if (dropdownvalue == "Cheque") "cheque_date": formattedDate,
    };

    debugPrint('Body Data $bodyJson');
    dynamic resJson =
        await api.sendData(subUrl, AppState().token, jsonEncode(bodyJson));
    if (resJson['data'] != null) {
      if (mounted) {
        CommonWidgets.showDialogueBox(
                context: context, title: "Alert", msg: "Updated Successfully")
            .then((_) => Navigator.of(context).pop());
      }
    }
  }
}
