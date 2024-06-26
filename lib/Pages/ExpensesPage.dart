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
                                // Add more widgets here as needed
                              ],
                            ),
                          ),
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
