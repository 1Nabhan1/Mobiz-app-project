import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'Models/paymentcollectionclass.dart';
import 'confg/appconfig.dart';
import 'confg/sizeconfig.dart';
import '../Components/commonwidgets.dart';

class PaymentCollectionScreen extends StatefulWidget {
  static const routeName = "/PaymentCollection";

  @override
  _PaymentCollectionScreenState createState() =>
      _PaymentCollectionScreenState();
}

class _PaymentCollectionScreenState extends State<PaymentCollectionScreen> {
  List<Invoice> invoices = [];
  String dropdownvalue = 'Cash';
  var items = ['Cash', 'Cheque'];
  late Future<ApiResponse> futureInvoices;
  List<bool> expandedStates = [];
  TextEditingController _paidAmt = TextEditingController();
  String PaidAmt = '';
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<String> enteredValues = [];

  Future<ApiResponse> fetchInvoices() async {
    final response = await http.get(Uri.parse(
        'http://68.183.92.8:3699/api/get_invoice_outstanding_detail?customer_id=38'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMMM yyyy').format(parsedDate);
  }

  @override
  void initState() {
    super.initState();
    futureInvoices = fetchInvoices();
  }

  double getAllocatedAmount() {
    return enteredValues
        .where((value) => value.isNotEmpty)
        .map((value) => double.parse(value))
        .fold(0, (sum, amount) => sum + amount);
  }

  double getBalanceAmount() {
    double paidAmount = PaidAmt.isNotEmpty ? double.parse(PaidAmt) : 0;
    double allocatedAmount = getAllocatedAmount();
    return paidAmount - allocatedAmount;
  }

  void updateBalanceAndAllocatedAmounts() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PaidAmt = _paidAmt.text;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        foregroundColor: AppConfig.backgroundColor,
        title: const Text('Payment Collection'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Code | Name | Payment Terms',
                    style:
                        const TextStyle(color: AppConfig.buttonDeactiveColor),
                  ),
                  CommonWidgets.verticalSpace(2),
                  Row(
                    children: [
                      const Text(
                        'Total outstanding',
                        style: TextStyle(color: AppConfig.buttonDeactiveColor),
                      ),
                      CommonWidgets.horizontalSpace(1),
                      _inputBox(status: false, value: "4321"),
                      const Spacer(),
                      const Text(
                        'Paid Amount',
                        style: TextStyle(color: AppConfig.buttonDeactiveColor),
                      ),
                      CommonWidgets.horizontalSpace(1),
                      InkWell(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Paid Amount'),
                                  content: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        PaidAmt = value;
                                        updateBalanceAndAllocatedAmounts();
                                      });
                                    },
                                    keyboardType: TextInputType.number,
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
                                        Navigator.of(context).pop();
                                        setState(() {
                                          updateBalanceAndAllocatedAmounts();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }).then((value) => setState(() {}));
                        },
                        child: _inputBox(status: true, value: (PaidAmt ?? '')),
                      ),
                    ],
                  ),
                  CommonWidgets.verticalSpace(1),
                  Row(
                    children: [
                      const Text(
                        'Allocated Amount',
                        style: TextStyle(color: AppConfig.buttonDeactiveColor),
                      ),
                      CommonWidgets.horizontalSpace(1),
                      _inputBox(
                          status: false,
                          value: getAllocatedAmount().toString()),
                      const Spacer(),
                      const Text(
                        'Balance Amount',
                        style: TextStyle(color: AppConfig.buttonDeactiveColor),
                      ),
                      CommonWidgets.horizontalSpace(1),
                      _inputBox(
                          status: false, value: getBalanceAmount().toString()),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .5,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<ApiResponse>(
                      future: futureInvoices,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.data.isEmpty) {
                          return Center(child: Text('No invoices found'));
                        } else {
                          // Initialize the expanded states
                          if (expandedStates.isEmpty) {
                            expandedStates = List<bool>.filled(
                                snapshot.data!.data.length, false);
                          }
                          if (enteredValues.length !=
                              snapshot.data!.data.length) {
                            enteredValues =
                                List.filled(snapshot.data!.data.length, '');
                          }
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.data.length,
                            itemBuilder: (context, index) {
                              final invoice = snapshot.data!.data[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Card(
                                  color: AppConfig.backgroundColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              expandedStates[index] =
                                                  !expandedStates[index];
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "${formatDate(invoice.invoiceDate)} | ${invoice.invoiceNo} | ${invoice.invoiceType}"),
                                                    InkWell(
                                                      onTap: () {
                                                        _showDialog(context,
                                                            index, invoice);
                                                      },
                                                      child: _inputBox(
                                                          status: false,
                                                          value: enteredValues[
                                                              index]),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Amount: ${invoice.amount} | Paid: ${invoice.paid} | Balance: ${invoice.amount - invoice.paid}',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: expandedStates[index],
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: invoice.collection
                                                      .map((collection) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 18.0,
                                                          vertical: 10),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                              '${formatDate(collection.inDate)} | ${collection.voucherNo} | ${collection.amount} | ${collection.collectionType}')
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const Text(
                  'Mode of Payment',
                  style: TextStyle(color: AppConfig.buttonDeactiveColor),
                ),
                CommonWidgets.horizontalSpace(1),
                DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
                CommonWidgets.horizontalSpace(2),
                const Text(
                  'Reference Number',
                  style: TextStyle(color: AppConfig.buttonDeactiveColor),
                ),
                CommonWidgets.horizontalSpace(1),
                _inputBox(status: true, value: ""),
              ],
            ),
            CommonWidgets.verticalSpace(1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Submit button functionality here
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppConfig.colorPrimary,
                  ),
                ),
                CommonWidgets.horizontalSpace(2),
                ElevatedButton(
                  onPressed: () {
                    // Cancel button functionality here
                  },
                  child: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppConfig.colorPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, int index, Invoice invoice) {
    double paidAmount = PaidAmt.isNotEmpty ? double.parse(PaidAmt) : 0;
    double allocatedAmount = getAllocatedAmount();
    double remainingAmount = paidAmount - allocatedAmount;
    double invoiceBalance = invoice.amount - invoice.paid;

    double initialAmount =
        remainingAmount < invoiceBalance ? remainingAmount : invoiceBalance;

    TextEditingController _amountController = TextEditingController(
      text: enteredValues[index].isEmpty
          ? initialAmount.toString()
          : enteredValues[index],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Amount'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: _amountController,
            onChanged: (value) {
              setState(() {
                enteredValues[index] = value;
              });
            },
            decoration: InputDecoration(hintText: "Enter amount"),
          ),
          actions: <Widget>[
            MaterialButton(
              color: AppConfig.colorPrimary,
              textColor: Colors.white,
              child: const Text('OK'),
              onPressed: () {
                double enteredAmount =
                    double.tryParse(_amountController.text) ?? 0;
                if (enteredAmount > invoiceBalance) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Entered amount cannot be greater than balance amount.'),
                    ),
                  );
                } else if (enteredAmount > remainingAmount) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Entered amount cannot be greater than remaining paid amount.'),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                  setState(() {
                    if (invoice.invoiceType == 'sales') {
                      PaidAmt =
                          (double.parse(PaidAmt) - enteredAmount).toString();
                    } else if (invoice.invoiceType == 'salesreturn' ||
                        invoice.invoiceType == 'payment_voucher') {
                      PaidAmt =
                          (double.parse(PaidAmt) + enteredAmount).toString();
                    }
                    enteredValues[index] = _amountController.text;
                    updateBalanceAndAllocatedAmounts();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _inputBox({required bool status, required String value}) {
    return Container(
      height: 40,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: status ? AppConfig.backgroundColor : AppConfig.backgroundColor,
        border: Border.all(color: AppConfig.buttonDeactiveColor),
      ),
      child: Center(
        child: Text(value),
      ),
    );
  }
}

class ApiResponse {
  final List<Invoice> data;

  ApiResponse({required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: List<Invoice>.from(
          json['data'].map((item) => Invoice.fromJson(item))),
    );
  }
}
