import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    futureSOA = fetchSOAData();
  }

  Future<SOAResponse> fetchSOAData() async {
    final response = await http.get(Uri.parse(
        'https://mobiz-api.yes45.in/api/get_soa_use_outstanding?customer_id=$id&from_date=2024-06-26&to_date=2024-06-29'));

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
      body: FutureBuilder<SOAResponse>(
        future: futureSOA,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$code | $name | $payment",
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
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
                            child: Text("01-May-2024"),
                          ),
                        ),
                        Icon(Icons.calendar_month),
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
                            child: Text("31-May-2024"),
                          ),
                        ),
                        Icon(Icons.calendar_month),
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
                      if (index == data.length) {
                        // Last row for balance due
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Regular row
                        return Column(
                          children: [
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(1.3),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth(),
                                3: FlexColumnWidth(),
                                4: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Colors.grey.shade300
                                        : Colors.transparent,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data[index][0] ?? ''),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data[index][1] ?? ''),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          data[index][2]?.toString() ?? '0'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          data[index][3]?.toString() ?? '0'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          data[index][4]?.toString() ?? '0'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          // By default, show a loading spinner
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
    );
  }
}
