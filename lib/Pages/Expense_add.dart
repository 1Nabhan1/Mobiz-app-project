import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../confg/appconfig.dart';

class ExpenseAdd extends StatefulWidget {
  static const routeName = "/ExpenseAdd";

  const ExpenseAdd({super.key});

  @override
  State<ExpenseAdd> createState() => _ExpenseAddState();
}

class _ExpenseAddState extends State<ExpenseAdd> {
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
          'Expense',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Date'),
                SizedBox(
                  width: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: Icon(CupertinoIcons.calendar_today)),
                SizedBox(
                  width: 20,
                ),
                Text('Amount'),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 70,
                    height: 20,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Text(''))
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _selectedDate;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }
}
