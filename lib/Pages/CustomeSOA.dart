import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../Components/commonwidgets.dart';
import '../Models/Soa_model.dart';
import '../Models/Store_model.dart';
import '../Utilities/rest_ds.dart';
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
String? address;
String? code;
String? payment;

class _SOAState extends State<SOA> {
  // Future<void> _generateAndPrintPdf1(List<Transaction> transactions, double opening, double closing) async {
  //   final pdf = pw.Document();
  //   double balance = opening;
  //
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text(
  //               'Statement of Accounts',
  //               style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Text(
  //               "$code | $name | $payment",
  //               style: pw.TextStyle(fontSize: 15, ),
  //             ),
  //             pw.SizedBox(height: 20),
  //             pw.Text(
  //               'Opening Balance: ${opening.toStringAsFixed(2)}',
  //               style: pw.TextStyle(fontSize: 15),
  //             ),
  //             pw.SizedBox(height: 10),
  //             pw.Table.fromTextArray(
  //               headers: ['Date', 'Reference', 'Amount', 'Payment', 'Balance'],
  //               data: List<List<String>>.generate(transactions.length, (index) {
  //                 final transaction = transactions[index];
  //                 double amount = transaction.receipt ?? 0.0;
  //                 double payment = transaction.receipt ?? 0.0;
  //                 balance += amount;
  //                 balance -= payment;
  //
  //                 return [
  //                   transaction.inDate.toString(),
  //                   transaction.invoiceNo,
  //                   amount.toStringAsFixed(2),
  //                   payment.toStringAsFixed(2),
  //                   balance.toStringAsFixed(2),
  //                 ];
  //               }),
  //             ),
  //             pw.SizedBox(height: 10),
  //             pw.Text(
  //               'Closing Balance: ${closing.toStringAsFixed(2)}',
  //               style: pw.TextStyle(fontSize: 15),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //
  //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  // }
  void sortDataByDate(List<List<dynamic>> data) {
    data.sort((a, b) {
      DateTime dateA = DateTime.parse(a[0]);
      DateTime dateB = DateTime.parse(b[0]);
      return dateA.compareTo(dateB);
    });
  }
  Future<void> _generateAndPrintPdf(
      List data, double opening, double closing) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_store_detail?store_id=${AppState().storeId}'));
    if (response.statusCode == 200) {
      // Parse JSON response into StoreDetail object
      StoreDetail storeDetail =
          StoreDetail.fromJson(json.decode(response.body));

      final pdf = pw.Document();
      double balance = opening;
      final String api =
          '${RestDatasource().Image_URL}/uploads/store/${storeDetail.logos}';
      final logoResponse = await http.get(Uri.parse(api));
      if (logoResponse.statusCode != 200) {
        throw Exception('Failed to load logo image');
      }
      final Uint8List logoBytes = logoResponse.bodyBytes;

      String addressText = storeDetail.address != null
          ? "Address: ${storeDetail.address}, "
          : "";
      String countryText =
          storeDetail.country != null ? "${storeDetail.country}" : "";

      pdf.addPage(
        pw.MultiPage(
          header: (pw.Context context) {
            if (context.pageNumber == 1) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                storeDetail.name,
                                style: pw.TextStyle(
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              if (storeDetail.address != null)
                                pw.Text(storeDetail.address!),
                              if (storeDetail.trn != null)
                                pw.Text('TRN: ${storeDetail.trn}'),
                            ]
                        ),
                        pw.Column(
                          children: [
                            pw.Image(
                              pw.MemoryImage(logoBytes),
                              height: 100,
                              width: 150,
                              fit: pw.BoxFit.fitWidth,
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Text(
                      'Statement of Accounts',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Text(
                              overflow: pw.TextOverflow.span,
                              "Customer : ${code} | ${name}",
                              style: pw.TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          pw.SizedBox(
                            width: 300,
                            child: pw.Text(
                              overflow: pw.TextOverflow.span,
                              "Address : $address",
                              style: pw.TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          // if (addressText.isNotEmpty || countryText.isNotEmpty)
                          //   pw.SizedBox(width: 300,
                          //     child: pw.Text(overflow: pw.TextOverflow.span,
                          //       "${addressText.isNotEmpty ? addressText : ''} ${countryText.isNotEmpty ? countryText : ''}",
                          //       style: pw.TextStyle(
                          //         fontSize: 15,
                          //       ),
                          //     ),
                          //   )
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'From Date: ${_selectedDatefrom != null ? DateFormat('dd MMMM yyyy').format(_selectedDatefrom!) : 'Select Date'}',
                            style: pw.TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          pw.Text(
                            'To Date: ${_selectedDateto != null ? DateFormat('dd MMMM yyyy').format(_selectedDateto!) : 'Select Date'}',
                            style: pw.TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          if (storeDetail.currency != null)
                            pw.Text(
                              'Currency: ${storeDetail.currency}',
                              style: pw.TextStyle(fontSize: 15),
                            ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                ],
              );
            } else {
              return pw.Container(); // Empty container for other pages
            }
          },
          build: (pw.Context context) => [
            pw.Table(
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Reference',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Payment',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Balance',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(''),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(''),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(''),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Opening Balance'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(balance.toStringAsFixed(2)),
                    ),
                  ],
                ),
                ...data.asMap().entries.map((entry) {
                  int index = entry.key;
                  var row = entry.value;

                  double amount =
                      row[2] != null ? double.parse(row[2].toString()) : 0.0;
                  double payment =
                      row[3] != null ? double.parse(row[3].toString()) : 0.0;
                  balance += amount;
                  balance -= payment;

                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color:
                          index % 2 == 0 ? PdfColors.white : PdfColors.grey200,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(row[0].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(row[1].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(row[2].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(row[3].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(balance.toStringAsFixed(2)),
                      ),
                    ],
                  );
                }).toList(),
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.white),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(''),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(''),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(''),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 20),
                      child: pw.Text('Closing Balance',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 20),
                      child: pw.Text(closing.toStringAsFixed(2),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/Custom SOA.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } else {
      throw Exception('Failed to load store details');
    }
  }

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

  // late List<Transaction> data;
  // late double openingBalance;
  // late double closingBalance;

  @override
  void initState() {
    super.initState();
    _selectedDatefrom = DateTime.now();
    _selectedDateto = DateTime.now();
    _refreshData();
    // _fetchtransactions();
    // futureSOA = fetchSOAData(); // Initial data load
    _selectedDatefrom = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _selectedDateto =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['customerId'];
      name = params['name'];
      address = params['address'];
      code = params['code'];
      payment = params!['paymentTerms'];
    }

    // Fetch customer deliveries here, as the context is now safe to use.
    futureSOA = fetchSOAData();
  }

  void _refreshData() {
    setState(() {
      futureSOA = fetchSOAData();
      // _fetchtransactions();
    });
  }

  // void _fetchtransactions() {
  //   setState(() {
  //     fetchTransactions();
  //   });
  // }

  Future<SOAResponse> fetchSOAData() async {
    final fromDate = _selectedDatefrom ?? DateTime.now();
    final toDate = _selectedDateto ?? DateTime.now();
    final fromDateString = DateFormat('yyyy-MM-dd').format(fromDate);
    final toDateString = DateFormat('yyyy-MM-dd').format(toDate);
    final String outstand =
        '${RestDatasource().BASE_URL}/api/get_soa_use_outstanding?customer_id=$id&from_date=$fromDateString&to_date=$toDateString';
    final String alltransaction =
        '${RestDatasource().BASE_URL}/api/get_soa_use_alltransaction?customer_id=$id&from_date=$fromDateString&to_date=$toDateString';
    final String url = isOutstandingSelected ? outstand : alltransaction;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.request);
      print(id);
      return SOAResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load SOA data');
    }
  }

  // Future<void> fetchTransactions() async {
  //   final fromDate = _selectedDatefrom ?? DateTime.now();
  //   final toDate = _selectedDateto ?? DateTime.now();
  //   final fromDateString = DateFormat('yyyy-MM-dd').format(fromDate);
  //   final toDateString = DateFormat('yyyy-MM-dd').format(toDate);
  //   var url = Uri.parse(
  //      );
  //
  //   try {
  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(response.body);
  //       var transactionList = jsonData['data'] as List<dynamic>;
  //       List<Transaction> tempTransactions =
  //           transactionList.map((e) => Transaction.fromJson(e)).toList();
  //
  //       setState(() {
  //         transactions = tempTransactions;
  //       });
  //     } else {
  //       throw Exception('Failed to load transactions');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // if (ModalRoute.of(context)!.settings.arguments != null) {
    //   final Map<String, dynamic>? params =
    //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    //   id = params!['customerId'];
    //   name = params!['name'];
    //   address = params['address'];
    //   code = params!['code'];
    //   payment = params!['paymentTerms'];
    // }
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
              double balanceDue = 0;
              for (var item in data) {
                if (item is List && item.length > 4) {
                  balanceDue += double.tryParse(item[4].toString()) ?? 0;
                }
                print(double.tryParse(item[4].toString()));              }
              sortDataByDate(data);

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
                                        setState(() {
                                          _refreshData();
                                        });
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
                                        setState(() {
                                          _refreshData();
                                        });
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
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _generateAndPrintPdf(
                                      data, opening, closing);
                                },
                                child: Icon(
                                  Icons.print,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await _generateAndPrintPdf(
                                      data, opening, closing);
                                },
                                child: Icon(Icons.document_scanner,
                                    color: Colors.red, size: 30),
                              ),
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
                    if (isOutstandingSelected)
                      Container(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.grey,
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(),
                                  1: FlexColumnWidth(),
                                  2: FlexColumnWidth(),
                                  3: FlexColumnWidth(),
                                  4: FlexColumnWidth(),
                                },
                                children: [
                                  const TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8),
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ),
                                      Text(
                                        "Reference",
                                        maxLines: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.fade,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        "Amount",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        "Payment",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        "Balance",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
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
                              itemCount: data.length +
                                  2, // increase by 2 to account for opening and closing balance rows
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // Display opening balance
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Opening Balance : ${opening.toStringAsFixed(2)}",
                                              // style: TextStyle(
                                              //   fontSize: 15,
                                              // ),
                                            ),
                                            SizedBox(
                                              width: 3,
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
                                    double amount = data[i][2] != null
                                        ? double.parse(data[i][2].toString())
                                        : 0.0;
                                    double payment = data[i][3] != null
                                        ? double.parse(data[i][3].toString())
                                        : 0.0;
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
                                    double amount = data[i][2] != null
                                        ? double.parse(data[i][2].toString())
                                        : 0.0;
                                    double payment = data[i][3] != null
                                        ? double.parse(data[i][3].toString())
                                        : 0.0;
                                    balance += amount;
                                    balance -= payment;
                                  }
                                  // Get current row's amount and payment
                                  double amount = row[2] != null
                                      ? double.parse(row[2].toString())
                                      : 0.0;
                                  double payment = row[3] != null
                                      ? double.parse(row[3].toString())
                                      : 0.0;
                                  // double babalance = row[5] != null
                                  // ? double.parse(row[5].toString()):0.0;
                                  // Adjust the balance
                                  balance += amount;
                                  balance -= payment;

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
                                                row[4].toString(),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Balance Due: ${balanceDue.toStringAsFixed(2)}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.grey,
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(),
                                  1: FlexColumnWidth(),
                                  2: FlexColumnWidth(),
                                  3: FlexColumnWidth(),
                                  4: FlexColumnWidth(),
                                },
                                children: [
                                  const TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8),
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ),
                                      Text(
                                        "Reference",
                                        maxLines: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.fade,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        "Amount",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        "Payment",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        "Balance",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
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
                              itemCount: data.length +
                                  2, // increase by 2 to account for opening and closing balance rows
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // Display opening balance
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Opening Balance : ${opening.toStringAsFixed(2)}",
                                              // style: TextStyle(
                                              //   fontSize: 15,
                                              // ),
                                            ),
                                            SizedBox(
                                              width: 3,
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
                                    double amount = data[i][2] != null
                                        ? double.parse(data[i][2].toString())
                                        : 0.0;
                                    double payment = data[i][3] != null
                                        ? double.parse(data[i][3].toString())
                                        : 0.0;
                                    // double babalance = data[i][5] != null
                                    //     ? double.parse(data[i][5].toString()):0.0;
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
                                    double amount = data[i][2] != null
                                        ? double.parse(data[i][2].toString())
                                        : 0.0;
                                    double payment = data[i][3] != null
                                        ? double.parse(data[i][3].toString())
                                        : 0.0;
                                    balance += amount;
                                    balance -= payment;
                                  }
                                  // Get current row's amount and payment
                                  double amount = row[2] != null
                                      ? double.parse(row[2].toString())
                                      : 0.0;
                                  double payment = row[3] != null
                                      ? double.parse(row[3].toString())
                                      : 0.0;
                                  // Adjust the balance
                                  balance += amount;
                                  balance -= payment;

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
                                                row[4].toString(),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Balance Due: ${balanceDue.toStringAsFixed(2)}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
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
      initialDate: _selectedDatefrom ?? DateTime.now(),
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
      initialDate: _selectedDateto ?? DateTime.now(),
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
