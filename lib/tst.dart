import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerExample extends StatefulWidget {
  @override
  _DatePickerExampleState createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _selectedDate == null
                  ? 'No date selected!'
                  : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
            ),
            SizedBox(height: 20.0),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedDate != null) {
                  print(DateFormat('yyyy-MM-dd').format(_selectedDate!));
                } else {
                  print('No date selected');
                }
              },
              child: Text('Print Date'),
            ),
          ],
        ),
      ),
    );
  }
}


