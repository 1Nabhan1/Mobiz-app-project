import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DayClosePage extends StatefulWidget {
  @override
  _DayClosePageState createState() => _DayClosePageState();
}

class _DayClosePageState extends State<DayClosePage> {
  DateTime selectedDate = DateTime.now();
  DayCloseData? dayCloseData;

  Future<void> fetchDayCloseData(DateTime selectedDate) async {
    final url = 'https://mobiz-api.yes45.in/api/get_dayclose_outstanding_by_date?van_id=9&store_id=10&in_date=${DateFormat('dd/MM/yyyy').format(selectedDate)}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        setState(() {
          dayCloseData = DayCloseData.fromJson(jsonResponse['data']);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDayCloseData(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day Close Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Select Date:'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // DatePicker.showDatePicker(
                //   context,
                //   showTitleActions: true,
                //   onConfirm: (date) {
                //     setState(() {
                //       selectedDate = date;
                //       fetchDayCloseData(selectedDate);
                //     });
                //   },
                //   currentTime: selectedDate,
                // );
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            if (dayCloseData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Cash Deposited: ${dayCloseData!.cashDeposited}'),
                  Text('Cash Hand Over: ${dayCloseData!.cashHandOver}'),
                  Text('No. of Cheque Deposited: ${dayCloseData!.numberOfChequeDeposited}'),
                  Text('Cheque Deposited Amount: ${dayCloseData!.chequeDepositedAmount}'),
                  Text('No. of Cheque Hand Over: ${dayCloseData!.numberOfChequeHandOver}'),
                  Text('Cheque Hand Over Amount: ${dayCloseData!.chequeHandOverAmount}'),
                  Text('Balance Cash in Hand: ${dayCloseData!.balanceCashInHand}'),
                  Text('No. of Cheque in Hand: ${dayCloseData!.numberOfChequeInHand}'),
                  Text('Cheque Amount in Hand: ${dayCloseData!.chequeAmountInHand}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class DayCloseData {
  final int id;
  final String cashDeposited;
  final String cashHandOver;
  final int numberOfChequeDeposited;
  final String chequeDepositedAmount;
  final int numberOfChequeHandOver;
  final String chequeHandOverAmount;
  final String balanceCashInHand;
  final int numberOfChequeInHand;
  final String chequeAmountInHand;

  DayCloseData({
    required this.id,
    required this.cashDeposited,
    required this.cashHandOver,
    required this.numberOfChequeDeposited,
    required this.chequeDepositedAmount,
    required this.numberOfChequeHandOver,
    required this.chequeHandOverAmount,
    required this.balanceCashInHand,
    required this.numberOfChequeInHand,
    required this.chequeAmountInHand,
  });

  factory DayCloseData.fromJson(Map<String, dynamic> json) {
    return DayCloseData(
      id: json['id'],
      cashDeposited: json['cash_deposited'],
      cashHandOver: json['cash_hand_over'],
      numberOfChequeDeposited: json['no_of_cheque_deposited'],
      chequeDepositedAmount: json['cheque_deposited_amount'],
      numberOfChequeHandOver: json['no_of_cheque_hand_over'],
      chequeHandOverAmount: json['cheque_hand_over_amount'],
      balanceCashInHand: json['balance_cash_in_hand'],
      numberOfChequeInHand: json['no_of_cheque_in_hand'],
      chequeAmountInHand: json['cheque_amount_in_hand'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DayClosePage(),
  ));
}
