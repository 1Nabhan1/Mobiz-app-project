import 'package:flutter/material.dart';

import '../confg/appconfig.dart';

class Expensespage extends StatefulWidget {
  static const routeName = "/Expensespage";
  Expensespage({super.key});

  @override
  State<Expensespage> createState() => _ExpensespageState();
}

class _ExpensespageState extends State<Expensespage> {
  bool isExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2= false;
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
          'Expenses',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                                '22 May 2024 | EX0015\nPetrol Expenses | Remarks entered will show here'),
                          ),
                          Text('Pending')
                        ],
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Divider(color: Colors.grey.shade300),
                              Text(
                                  'More details about the expense will be shown here.'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded1 = !isExpanded1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                                '22 May 2024 | EX0010\nPetrol Expenses | Remarks entered will show here'),
                          ),
                          Text('Rejected')
                        ],
                      ),
                      if (isExpanded1)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Divider(color: Colors.grey.shade300),
                              Text("Rejected Reason : This bill is not valid"),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded2 = !isExpanded2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                                '22 May 2024 | EX0007\nPetrol Expenses | Remarks entered will show here'),
                          ),
                          Text('Approved')
                        ],
                      ),
                      if (isExpanded2)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Divider(color: Colors.grey.shade300),
                              Text(
                                  'Approval Remarks : Next time please get prior approval'),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.network("https://5.imimg.com/data5/SD/MV/SX/SELLER-15122437/tax-invoice-1-8-500x500.jpg",height: 150,),
                                  Image.network("https://trbahadurpur.com/wp-content/uploads/2023/01/Bill-of-Supply-Design-CDR-File.jpg",height: 150,),
                                ],),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




