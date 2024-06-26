import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../confg/appconfig.dart';

class SOA extends StatefulWidget {
  static const routeName = "/SOA";

  const SOA({super.key});

  @override
  State<SOA> createState() => _SOAState();
}

class _SOAState extends State<SOA> {
  bool isOutstandingSelected = true;
  void toggleSelection() {
    setState(() {
      isOutstandingSelected = !isOutstandingSelected;
    });
  }

  final List<Map<String, String>> data = [
    {
      "Date": "",
      "Reference": "",
      "Amount": "",
      "Payment": "Opening Balance",
      "Balance": "200.00"
    },
    {
      "Date": "22-May-2024",
      "Reference": "S10007",
      "Amount": "300.00",
      "Payment": "",
      "Balance": "500.00"
    },
    {
      "Date": "24-May-2024",
      "Reference": "S10008",
      "Amount": "450.00",
      "Payment": "",
      "Balance": "950.00"
    },
    {
      "Date": "22-May-2024",
      "Reference": "RV0007",
      "Amount": "",
      "Payment": "100.00",
      "Balance": "850.00"
    },
    {
      "Date": "24-May-2024",
      "Reference": "CN0008",
      "Amount": "",
      "Payment": "50.00",
      "Balance": "800.00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConfig.colorPrimary,
        title: Text(
          'Statement Of Accounts',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "AR0034 | AL MADINA TRADING LLC | BILL TO BILL",
              style: TextStyle(color: Colors.grey, fontSize: 15),
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
                            constraints: BoxConstraints(
                              maxWidth: 120.0,
                              minHeight: 25.0,
                            ),
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(2),
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
                            constraints: BoxConstraints(
                              maxWidth: 120.0,
                              minHeight: 25.0,
                            ),
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(2),
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
                  children: [
                    Icon(
                      Icons.print,
                      color: Colors.blue,
                      size: 30,
                    ),
                    Icon(Icons.document_scanner, color: Colors.red, size: 30),
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
                Row(
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
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("01-May-2024"),
                      ),
                    ),
                    Icon(Icons.calendar_month),
                  ],
                ),
                Row(
                  children: [
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
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("31-May-2024"),
                      ),
                    ),
                    Icon(Icons.calendar_month),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 35,
            color: Colors.grey,
            child: Table(defaultVerticalAlignment: TableCellVerticalAlignment.bottom,border: TableBorder(bottom: WidgetStateBorderSide.resolveWith((states) {},)),
              columnWidths: {
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
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Reference",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Amount",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Payment",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Balance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
                for (int i = 0; i < data.length; i++)
                  TableRow(
                    decoration: BoxDecoration(
                      color: (i == 1 || i == 3) ? Colors.grey.shade300 : Colors.transparent,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(data[i]["Date"]!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data[i]["Reference"]!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data[i]["Amount"]!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data[i]["Payment"]!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data[i]["Balance"]!),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 250,top: 210),
            child: Text("Balance Due 800.00",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }
}