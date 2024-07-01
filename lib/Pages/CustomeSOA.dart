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

  void toggleSelection() {
    setState(() {
      isOutstandingSelected = !isOutstandingSelected;
    });
  }

  late Future<SOAResponse> futureSOA;
  DateTime? _selectedDatefrom;
  DateTime? _selectedDateto;

  @override
  void initState() {
    super.initState();
    _selectedDatefrom = DateTime.now();
    _selectedDateto = DateTime.now();
    _refreshData();
    futureSOA = fetchSOAData(); // Initial data load
  }

  void _refreshData() {
    setState(() {
      futureSOA = fetchSOAData();
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
              final closing = snapshot.data!.closing;

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
                    Container(
                      width: double.infinity,
                      height: 35,
                      color: Colors.grey,
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
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text("Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text("Reference",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text("Amount",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text("Payment",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text("Balance",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
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
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Display opening balance
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // padding: EdgeInsets.symmetric(horizontal: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Opening Balance    ",
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "$opening",
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
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
                          // Last row for balance due
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width:
                                          SizeConfig.safeBlockHorizontal! * 35,
                                      height: 1.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          final row = data[index - 1];
                          return Container(
                            width: double.infinity,
                            height: 35,
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
                                      child: Text(row[0].toString(),
                                          style: TextStyle(fontSize: 13)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(row[1].toString(),
                                          style: TextStyle(fontSize: 13)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(row[2].toString(),
                                          style: TextStyle(fontSize: 13)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(row[3].toString(),
                                          style: TextStyle(fontSize: 13)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(row[4].toString(),
                                          style: TextStyle(fontSize: 13)),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Closing Balance    ",
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "$closing",
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
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
