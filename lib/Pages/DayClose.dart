import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:shimmer/shimmer.dart';

import '../Components/commonwidgets.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import 'Day_closeReport.dart';
import 'homepage.dart';

class Dayclose extends StatefulWidget {
  static const routeName = "/Dayclose";
  const Dayclose({super.key});

  @override
  State<Dayclose> createState() => _DaycloseState();
}

TextEditingController CashDepositedcontrol = TextEditingController();
TextEditingController CashHandedOvercontrol = TextEditingController();
TextEditingController NoofChequeDepositedcontrol = TextEditingController();
TextEditingController ChequeDepositedAmountcontrol = TextEditingController();
TextEditingController NoofChequeHandedOvercontrol = TextEditingController();
TextEditingController ChequeHandedOverAmountcontrol = TextEditingController();

class _DaycloseState extends State<Dayclose> {
  late Future<Map<String, dynamic>> futureData;
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String cashdeposit = '';
  String cashHanded = '';
  String Ncheqdepo = '';
  String cheqdepo = '';
  String cheqhandedovr = '';
  String cheqhandedamt = '';
  String cheqhand = '';
  String balcash = '';
  String amtinhand = '';
  // var selectedDate = DateTime.now();
  var selectedDate = DateTime.now();

  Random random = Random();
  @override
  void initState() {
    super.initState();
    fetchData();
    futureData = fetchDayCloseOutstanding();
  }

  bool isdayclose = false;
  Map<String, dynamic>? Dayclosedata;

  void fetchData() async {
    try {
      final data = await fetchDayclose();
      setState(() {
        Dayclosedata = data['data'];
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDayclose() async {
    var apiUrl =
        '${RestDatasource().BASE_URL}/api/get_dayclose_outstanding_by_date?van_id=${AppState().vanId}&store_id=${AppState().storeId}&in_date=${DateFormat('dd/MM/yyyy').format(selectedDate)}&user_id=${AppState().userId}';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    Dayclosedata == null ? isdayclose = true : isdayclose = false;
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
            'Day close',
            style: TextStyle(color: AppConfig.backgroundColor),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  DaycloseReport.routeName,
                );
              },
              child: Icon(
                Icons.report_gmailerrorred_outlined,
                color: AppConfig.backgroundColor,
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: AppConfig.buttonDeactiveColor.withOpacity(0.1),
                highlightColor: AppConfig.backButtonColor,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) =>
                      CommonWidgets.loadingContainers(
                    height: SizeConfig.blockSizeVertical * 40,
                    width: SizeConfig.blockSizeHorizontal * 40,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final data = snapshot.data!['data'];
              void postData() async {
                var url = '${RestDatasource().BASE_URL}/api/dayclose.store';

                var Data = {
                  "expense": data['expense'],
                  "in_date": formattedDate,
                  "store_id": AppState().storeId,
                  "van_id": AppState().vanId,
                  "user_id": AppState().userId,
                  "scheduled": data['sheduled'],
                  "visited": data['vist_customer'],
                  "not_visited": data['non_vist_customer'],
                  "visit_pending": data['pending'],
                  "no_of_sales": data['no_of_sales'],
                  "amount_of_sales": data['amount_of_sales'],
                  "no_of_order": data['no_of_sales_order'],
                  "amount_of_order": data['amount_of_sales_order'],
                  "no_of_returns": data['no_of_sales_return'],
                  "amount_of_returns": data['amount_of_sales_return'],
                  "collection_cash_amount": data['collection_cash'],
                  "collection_cheque_amount": data['collection_cheque'],
                  "last_day_balance_amount": data['last_day_balance_amount'],
                  "last_day_balance_no_of_cheque":
                      data['last_day_balance_no_of_cheque'],
                  "last_day_balance_cheque_amount":
                      data['last_day_balance_cheque_amount'],
                  "cash_deposited": cashdeposit,
                  "cash_hand_over": cashHanded,
                  "no_of_cheque_deposited": Ncheqdepo,
                  "cheque_deposited_amount": cheqdepo,
                  "no_of_cheque_hand_over": cheqhandedovr,
                  "cheque_hand_over_amount": cheqhandedamt,
                  "balance_cash_in_hand": balcash,
                  "no_of_cheque_in_hand": cheqhand,
                  "cheque_amount_in_hand": amtinhand,
                  "collection_no_of_cheque": data['collection_no_cheque']
                };

                var response = await http.post(
                  Uri.parse(url),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(Data),
                );

                if (response.statusCode == 200) {
                  if (mounted) {
                    CommonWidgets.showDialogueBox(
                            context: context,
                            title: "",
                            msg: "Data Inserted Successfully")
                        .then((value) =>
                            Navigator.pushNamed(context, HomeScreen.routeName));
                  }
                  print('Data posted successfully');
                  print('Response: ${response.body}');
                } else {
                  print('Failed to post data');
                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');
                }
              }

              Future<void> _showDialog(
                  TextEditingController control, String field) async {
                String? dialogValue = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Enter a value'),
                      content: TextField(
                        keyboardType: TextInputType.number,
                        controller: control,
                        decoration: InputDecoration(hintText: "Enter here"),
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: Size(100, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            backgroundColor: AppConfig.colorPrimary,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(control.text); // Return the value
                          },
                          child: Text('OK',
                              style:
                                  TextStyle(color: AppConfig.backgroundColor)),
                        ),
                      ],
                    );
                  },
                );

                if (dialogValue != null) {
                  setState(() {
                    switch (field) {
                      case 'cashdeposit':
                        cashdeposit = dialogValue;
                        break;
                      case 'cashHanded':
                        cashHanded = dialogValue;
                        break;
                      case 'Ncheqdepo':
                        Ncheqdepo = dialogValue;
                        break;
                      case 'cheqdepoamt':
                        cheqdepo = dialogValue;
                        break;
                      case 'cheqhandedovr':
                        cheqhandedovr = dialogValue;
                        break;
                      case 'cheqhandedamt':
                        cheqhandedamt = dialogValue;
                        break;
                      default:
                        break;
                    }
                  });
                  if (cashdeposit.isNotEmpty && cashHanded.isNotEmpty) {
                    balcash = ((((data['collection_cash']) +
                                    (data['last_day_balance_amount'])) -
                                (double.parse(cashdeposit) +
                                    double.parse(cashHanded))) -
                            data['expense'])
                        .toString();
                  }
                  if (Ncheqdepo.isNotEmpty && cheqhandedovr.isNotEmpty) {
                    cheqhand = (((data['collection_no_cheque']) +
                                (data['last_day_balance_no_of_cheque'])) -
                            (double.parse(Ncheqdepo) +
                                double.parse(cheqhandedovr)))
                        .toString();
                  }
                  if (cheqdepo.isNotEmpty && cheqhandedovr.isNotEmpty) {
                    amtinhand = (((data['collection_cheque']) +
                                (data['last_day_balance_cheque_amount'])) -
                            (double.parse(cheqdepo) +
                                double.parse(cheqhandedamt)))
                        .toString();
                  }
                }
              }

              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // GestureDetector(
                      //   onLongPress: () async {
                      //     DateTime? pickedDate = await showDatePicker(
                      //       context: context,
                      //       initialDate: selectedDate,
                      //       firstDate: DateTime(2023, 12, 31),
                      //       lastDate: DateTime(2028, 1, 31),
                      //       builder: (context, child) {
                      //         return Theme(
                      //           data: Theme.of(context).copyWith(
                      //             colorScheme: ColorScheme.light(
                      //               primary: AppConfig
                      //                   .colorPrimary, // header background color
                      //               onPrimary:
                      //                   Colors.white, // header text color
                      //               onSurface: AppConfig
                      //                   .colorPrimary, // body text color
                      //             ),
                      //             textButtonTheme: TextButtonThemeData(
                      //               style: TextButton.styleFrom(
                      //                 foregroundColor: Colors
                      //                     .deepPurple, // button text color
                      //               ),
                      //             ),
                      //           ),
                      //           child: child!,
                      //         );
                      //       },
                      //     );
                      //     if (pickedDate != null) {
                      //       setState(() {
                      //         selectedDate = pickedDate;
                      //       });
                      //     }
                      //   },
                      //
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                      //     child: HorizontalWeekCalendar(
                      //       key: ValueKey(
                      //           selectedDate), // Use ValueKey to trigger rebuild
                      //       minDate: DateTime(2023, 12, 31),
                      //       maxDate: DateTime(2028, 1, 31),
                      //       initialDate: selectedDate,
                      //       onDateChange: (date) {
                      //         setState(() {
                      //           selectedDate = date;
                      //           futureData;
                      //           fetchData();
                      //         });
                      //       },
                      //       showTopNavbar: false,
                      //       monthFormat: "MMMM yyyy",
                      //       showNavigationButtons: true,
                      //       weekStartFrom: WeekStartFrom.Monday,
                      //       borderRadius: BorderRadius.circular(7),
                      //       activeBackgroundColor: AppConfig.colorPrimary,
                      //       activeTextColor: Colors.white,
                      //       inactiveBackgroundColor:
                      //           Colors.deepPurple.withOpacity(.3),
                      //       inactiveTextColor: Colors.white,
                      //       disabledTextColor: Colors.grey,
                      //       disabledBackgroundColor:
                      //           Colors.grey.withOpacity(.3),
                      //       activeNavigatorColor: Colors.deepPurple,
                      //       inactiveNavigatorColor: Colors.grey,
                      //       monthColor: AppConfig.colorPrimary,
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello ${AppState().name}'),
                            RichText(
                              text: TextSpan(
                                  text: 'Van  ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: ' ${data['van']}',
                                        style: TextStyle(color: Colors.grey))
                                  ]),
                            ),
                            // Text(
                            //     'Scheduled ${data['sheduled']} | Visited  ${data['vist_customer']} | Not Visited ${data['non_vist_customer']} | Pending ${data['pending']}'),
                            RichText(
                              text: TextSpan(
                                  text: 'Sales  ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${data['no_of_sales']} | ${data['amount_of_sales']}',
                                        style: TextStyle(color: Colors.grey))
                                  ]),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: 'Orders  ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${data['no_of_sales_order']} | ${data['amount_of_sales_order']}',
                                        style: TextStyle(color: Colors.grey))
                                  ]),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: 'Returns  ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${data['no_of_sales_return']} | ${data['amount_of_sales_return']}',
                                        style: TextStyle(color: Colors.grey))
                                  ]),
                            ),
                            Text('Collection'),
                            Text(
                              'Cash ${data['collection_cash']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                                'Cheque ${data['collection_cheque']} | ${data['collection_no_cheque']}',
                                style: TextStyle(color: Colors.grey)),
                            Text('Last Day Balance'),
                            Text('Cash ${data['last_day_balance_amount']}',
                                style: TextStyle(color: Colors.grey)),
                            Text(
                                'Cheque ${data['last_day_balance_no_of_cheque']} | ${data['last_day_balance_cheque_amount']}',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Expense'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Cash Deposited'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Cash Handed Over'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('No of Cheque Deposited'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Cheque Deposited Amount'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('No of Cheque Handed Over'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Cheque Handed Over Amount'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Balance Cash in Hand'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('No of Cheque in Hand'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Cheque Amount in Hand'),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child:
                                    Center(child: Text("${data['expense']}")),
                                width: 70,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: isdayclose == false
                                    ? null
                                    : () {
                                        _showDialog(CashDepositedcontrol,
                                            'cashdeposit');
                                      },
                                child: Container(
                                  child: Center(
                                      child: Text(isdayclose == false
                                          ? Dayclosedata == null
                                              ? ''
                                              : Dayclosedata!['cash_deposited']
                                          : cashdeposit)),
                                  width: 70,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color: Colors.grey)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: isdayclose == false
                                    ? null
                                    : () {
                                        _showDialog(CashHandedOvercontrol,
                                            'cashHanded');
                                      },
                                child: Container(
                                  child: Center(
                                      child: Text(isdayclose == false
                                          ? Dayclosedata == null
                                              ? ''
                                              : Dayclosedata!['cash_hand_over']
                                          : cashHanded)),
                                  width: 70,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color: Colors.grey)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: isdayclose == false
                                    ? null
                                    : () {
                                        _showDialog(NoofChequeDepositedcontrol,
                                            'Ncheqdepo');
                                      },
                                child: Container(
                                  child: Center(
                                      child: Text(isdayclose == false
                                          ? Dayclosedata == null
                                              ? ''
                                              : "${Dayclosedata!['no_of_cheque_deposited']}"
                                          : Ncheqdepo)),
                                  width: 70,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color: Colors.grey)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: isdayclose == false
                                    ? null
                                    : () {
                                        _showDialog(
                                            ChequeDepositedAmountcontrol,
                                            'cheqdepoamt');
                                      },
                                child: Container(
                                  child: Center(
                                      child: Text(isdayclose == false
                                          ? Dayclosedata == null
                                              ? ''
                                              : Dayclosedata![
                                                  'cheque_deposited_amount']
                                          : cheqdepo)),
                                  width: 70,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color: Colors.grey)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: isdayclose == false
                                    ? null
                                    : () {
                                        _showDialog(NoofChequeHandedOvercontrol,
                                            'cheqhandedovr');
                                      },
                                child: Container(
                                  child: Center(
                                      child: Text(isdayclose == false
                                          ? Dayclosedata == null
                                              ? ''
                                              : "${Dayclosedata!['no_of_cheque_hand_over']}"
                                          : cheqhandedovr)),
                                  width: 70,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color: Colors.grey)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: isdayclose == false
                                    ? null
                                    : () {
                                        _showDialog(
                                            ChequeHandedOverAmountcontrol,
                                            'cheqhandedamt');
                                      },
                                child: Container(
                                  child: Center(
                                      child: Text(isdayclose == false
                                          ? Dayclosedata == null
                                              ? ''
                                              : Dayclosedata![
                                                  'cheque_hand_over_amount']
                                          : cheqhandedamt)),
                                  width: 70,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color: Colors.grey)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Center(
                                    child: Text(isdayclose == false
                                        ? Dayclosedata == null
                                            ? ''
                                            : "${Dayclosedata!['balance_cash_in_hand']}"
                                        : balcash)),
                                width: 70,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Center(
                                  child: Text(isdayclose == false
                                      ? Dayclosedata == null
                                          ? ''
                                          : "${Dayclosedata!['no_of_cheque_in_hand']}"
                                      : cheqhand),
                                ),
                                width: 70,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Center(
                                  child: Text(isdayclose == false
                                      ? Dayclosedata == null
                                          ? ''
                                          : "${Dayclosedata!['cheque_amount_in_hand']}"
                                      : amtinhand),
                                ),
                                width: 70,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: AppConfig.colorPrimary,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.upload,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  isdayclose == false
                                      ? Colors.grey
                                      : AppConfig.colorPrimary),
                              shape: WidgetStateProperty.all(
                                  BeveledRectangleBorder()),
                              minimumSize:
                                  WidgetStateProperty.all(Size(70, 30)),
                            ),
                            onPressed: isdayclose == false
                                ? null
                                : () {
                                    postData();
                                    // print(DateFormat('dd/MM/yyyy').format(selectedDate));
                                  },
                            child: SizedBox(
                              width: 120,
                              child: Center(
                                child: Text(
                                  "Send for Approval",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text('No data available');
            }
          },
        ));
  }

  Future<Map<String, dynamic>> fetchDayCloseOutstanding() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_dayclose_outstanding?van_id=${AppState().vanId}&store_id=${AppState().storeId}&in_date=${DateFormat('dd/MM/yyyy').format(selectedDate)}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
