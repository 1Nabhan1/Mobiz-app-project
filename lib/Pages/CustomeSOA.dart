import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';

import '../Components/commonwidgets.dart';
import '../Models/Soa_model.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class SOA extends StatefulWidget {
  static const routeName = "/SOA";

  const SOA({Key? key}) : super(key: key);

  @override
  State<SOA> createState() => _SOAState();
}

int? id;
String? name;
String? code;
String? payment;

class _SOAState extends State<SOA> {
  bool isOutstandingSelected = true;
  List<Transaction> transactions = [];

  void toggleSelection() {
    setState(() {
      isOutstandingSelected = !isOutstandingSelected;
    });
  }

  late Future<SOAResponse> futureSOA;
  DateTime? _selectedDatefrom;
  DateTime? _selectedDateto;

  late List<Transaction> data;
  late double opening;
  late double closing;

  @override
  void initState() {
    super.initState();
    _selectedDatefrom = DateTime.now();
    _selectedDateto = DateTime.now();
    _refreshData();
    _fetchtransactions();
    futureSOA = fetchSOAData(); // Initial data load
  }

  void _refreshData() {
    setState(() {
      futureSOA = fetchSOAData();
      _fetchtransactions();
    });
  }

  void _fetchtransactions() {
    setState(() {
      fetchTransactions();
    });
  }

  Future<SOAResponse> fetchSOAData() async {
    final fromDate = _selectedDatefrom ?? DateTime.now();
    final toDate = _selectedDateto ?? DateTime.now();
    final fromDateString = DateFormat('yyyy-MM-dd').format(fromDate);
    final toDateString = DateFormat('yyyy-MM-dd').format(toDate);

    final response = await http.get(Uri.parse(
        'https://mobiz-api.yes45.in/api/get_soa_use_outstanding?customer_id=$id&from_date=$fromDateString&to_date=$toDateString'));

    if (response.statusCode == 200) {
      return SOAResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load SOA data');
    }
  }

  Future<void> fetchTransactions() async {
    final fromDate = _selectedDatefrom ?? DateTime.now();
    final toDate = _selectedDateto ?? DateTime.now();
    final fromDateString = DateFormat('yyyy-MM-dd').format(fromDate);
    final toDateString = DateFormat('yyyy-MM-dd').format(toDate);
    var url = Uri.parse(
        'https://mobiz-api.yes45.in/api/get_soa_use_alltransaction?customer_id=$id&from_date=$fromDateString&to_date=$toDateString');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var transactionList = jsonData['data'] as List<dynamic>;
        List<Transaction> tempTransactions =
        transactionList.map((e) => Transaction.fromJson(e)).toList();

        setState(() {
          transactions = tempTransactions;
        });
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['customerId'];
      name = params!['name'];
      code = params!['code'];
      payment = params!['paymentTerms'];
    }
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConfig.colorPrimary,
        title: const Text(
          'Statement Of Accounts',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => futureSOA,
        child: FutureBuilder<SOAResponse>(
          future: futureSOA,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data;
              final opening = snapshot.data!.opening;
              var closing = snapshot.data!.closing;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$code | $name | $payment",
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (!isOutstandingSelected) {
                                        toggleSelection();
                                      }
                                    },
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 120.0,
                                        minHeight: 25.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isOutstandingSelected
                                            ? AppConfig.colorPrimary
                                            : Colors.transparent,
                                        border: Border.all(
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Outstanding",
                                          style: TextStyle(
                                            color: isOutstandingSelected
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (isOutstandingSelected) {
                                        toggleSelection();
                                      }
                                    },
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 120.0,
                                        minHeight: 25.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: !isOutstandingSelected
                                            ? AppConfig.colorPrimary
                                            : Colors.transparent,
                                        border: Border.all(
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "All Transactions",
                                          style: TextStyle(
                                            color: !isOutstandingSelected
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.print,
                                color: Colors.blue,
                                size: 30,
                              ),
                              Icon(Icons.document_scanner,
                                  color: Colors.red, size: 30),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "From Date",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                _selectedDatefrom == null
                                    ? 'Select Date'
                                    : DateFormat('dd/MM/yyyy')
                                    .format(_selectedDatefrom!),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                _selectDatefrom(context);
                              },
                              child: Icon(Icons.calendar_month)),
                          Text(
                            "To Date",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                _selectedDateto == null
                                    ? 'Select Date'
                                    : DateFormat('dd/MM/yyyy')
                                    .format(_selectedDateto!),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                _selectDateto(context);
                              },
                              child: Icon(Icons.calendar_month)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isOutstandingSelected) Container(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(1.3),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth(),
                                3: FlexColumnWidth(),
                                4: FlexColumnWidth(),
                              },
                              children: [
                                const TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(
                                        "Date",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(
                                        "Reference",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(
                                        "Amount",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(
                                        "Payment",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(
                                        "Balance",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: data.length + 2, // increase by 2 to account for opening and closing balance rows
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // Display opening balance
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Opening Balance    ",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            opening.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else if (index == data.length + 1) {
                                // Display closing balance
                                double balance = opening;
                                for (int i = 0; i < data.length; i++) {
                                  double amount = data[i][2] != null ? double.parse(data[i][2].toString()) : 0.0;
                                  double payment = data[i][3] != null ? double.parse(data[i][3].toString()) : 0.0;
                                  balance += amount;
                                  balance -= payment;
                                }
                                // return Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     children: [
                                //       Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //         children: [
                                //           Text(
                                //             "Closing Balance    ",
                                //             style: TextStyle(
                                //               fontSize: 15,
                                //             ),
                                //           ),
                                //           Text(
                                //             balance.toStringAsFixed(2),
                                //             style: TextStyle(
                                //               fontSize: 15,
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             width: 40,
                                //           )
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // );
                              } else {
                                final row = data[index - 1];
                                double balance = opening;
                                for (int i = 0; i < index - 1; i++) {
                                  double amount = data[i][2] != null ? double.parse(data[i][2].toString()) : 0.0;
                                  double payment = data[i][3] != null ? double.parse(data[i][3].toString()) : 0.0;
                                  balance += amount;
                                  balance -= payment;
                                }
                                // Get current row's amount and payment
                                double amount = row[2] != null ? double.parse(row[2].toString()) : 0.0;
                                double payment = row[3] != null ? double.parse(row[3].toString()) : 0.0;
                                // Adjust the balance
                                balance += amount;
                                balance -= payment;

                                return Container(
                                  width: double.infinity,
                                  height: 35,
                                  color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
                                  child: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(1.3),
                                      1: FlexColumnWidth(),
                                      2: FlexColumnWidth(),
                                      3: FlexColumnWidth(),
                                      4: FlexColumnWidth(),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text(
                                              row[0].toString(),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text(
                                              row[1].toString(),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text(
                                              row[2].toString(),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text(
                                              row[3].toString(),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text(
                                              balance.toStringAsFixed(2),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                          Divider(
                            color: Colors.black38,
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Balance Due:$closing",style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    else Column(
                      children: [
                        Container(
                          width: double.infinity,
                          // height: ,
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Table(
                                defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(1.3),
                                  1: FlexColumnWidth(),
                                  2: FlexColumnWidth(),
                                  3: FlexColumnWidth(),
                                  4: FlexColumnWidth(),
                                },
                                children: [
                                  const TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Text(
                                          "Reference",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Text(
                                          "Amount",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Text(
                                          "Payment",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Text(
                                          "Balance",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: transactions.length +
                                    1, // +1 for opening balance
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    // Display opening balance
                                    return Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Opening Balance : $opening",
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    final transaction =
                                    transactions[index - 1];
                                    double balance = opening;
                                    if (transaction.collection.isNotEmpty) {
                                      double amount = double.parse(
                                          transaction.collection[0].amount);
                                      double payment = transaction.receipt;

                                      // Adjust balance based on transaction type
                                      if (index == 1) {
                                        balance +=
                                            amount; // Add amount to opening balance
                                        balance -=
                                            payment; // Subtract payment from balance
                                      } else {
                                        // If it's not the first transaction, subtract from previous balance
                                        balance -=
                                            payment; // Subtract payment from previous balance
                                      }
                                    }

                                    return Container(
                                      width: double.infinity,
                                      // height: 35,
                                      color: index % 2 == 0
                                          ? Colors.grey.shade200
                                          : Colors.white,
                                      child: Table(
                                        defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                        columnWidths: const {
                                          0: FlexColumnWidth(1.3),
                                          1: FlexColumnWidth(),
                                          2: FlexColumnWidth(),
                                          3: FlexColumnWidth(),
                                          4: FlexColumnWidth(),
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Text(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(
                                                    DateTime.parse(
                                                        transaction.inDate),
                                                  ),
                                                  style:
                                                  TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Text(
                                                  transaction.invoiceNo,
                                                  style:
                                                  TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Text(
                                                  transaction.collection
                                                      .isNotEmpty
                                                      ? transaction
                                                      .collection[0]
                                                      .amount
                                                      : '',
                                                  style:
                                                  TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Text(
                                                  transaction.receipt
                                                      .toString(),
                                                  style:
                                                  TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Text(
                                                  balance.toStringAsFixed(
                                                      2), // Display balance
                                                  style:
                                                  TextStyle(fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                              Divider(
                                color: Colors.black38,
                                height: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*.006,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Balance Due : $closing",style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
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
                        height: SizeConfig.blockSizeVertical * 60,
                        width: SizeConfig.blockSizeHorizontal * 90),

                    // CommonWidgets.loadingContainers(
                    //     height: SizeConfig.blockSizeVertical * 10,
                    //     width: SizeConfig.blockSizeHorizontal * 90),
                    // CommonWidgets.loadingContainers(
                    //     height: SizeConfig.blockSizeVertical * 10,
                    //     width: SizeConfig.blockSizeHorizontal * 90),
                    // CommonWidgets.loadingContainers(
                    //     height: SizeConfig.blockSizeVertical * 10,
                    //     width: SizeConfig.blockSizeHorizontal * 90),
                    // CommonWidgets.loadingContainers(
                    //     height: SizeConfig.blockSizeVertical * 10,
                    //     width: SizeConfig.blockSizeHorizontal * 90),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectDatefrom(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDatefrom) {
      setState(() {
        _selectedDatefrom = pickedDate;
      });
      _refreshData(); // Refresh data after selecting from date
    }
  }

// Function to show the date picker
  Future<void> _selectDateto(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDateto) {
      setState(() {
        _selectedDateto = pickedDate;
      });
      _refreshData(); // Refresh data after selecting to date
    }
  }
}