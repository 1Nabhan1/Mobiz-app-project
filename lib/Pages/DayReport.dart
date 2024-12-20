import 'dart:convert';
import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/main.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/DayReport.dart';
import '../confg/appconfig.dart';

class DayReport extends StatefulWidget {
  static const routeName = "/DayReport";
  @override
  State<DayReport> createState() => _DayReportState();
}

class _DayReportState extends State<DayReport> {
  bool _connected = false;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;


  @override
  void initState() {
    super.initState();
    _initPrinter();
  }

  Future<DayCloseOutstandingReport> fetchDayCloseOutstandingReport() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_dayclose_outstanding_report?user_id=${AppState().userId}&van_id=${AppState().vanId}&store_id=${AppState().storeId}'));

    if (response.statusCode == 200) {
      return DayCloseOutstandingReport.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load report');
    }
  }
  void _initPrinter() async {
    bool? isConnected = await printer.isConnected;
    if (isConnected!) {
      setState(() {
        _connected = true;
      });
    }
    _getBluetoothDevices();
  }

  void _connect() async {
    if (_selectedDevice != null) {
      await printer.connect(_selectedDevice!);
      setState(() {
        _connected = true;
      });
      print("Printer connected: $_connected");
    } else {
      print("No device selected");
    }
  }



  void _getBluetoothDevices() async {
    List<BluetoothDevice> devices = await printer.getBondedDevices();
    BluetoothDevice? defaultDevice;
    final prefs = await SharedPreferences.getInstance();
    final savedDeviceAddress = prefs.getString('selected_device_address');

    for (BluetoothDevice device in devices) {
      if (device.address == savedDeviceAddress) {
        defaultDevice = device;
        break;
      }
    }

    setState(() {
      _devices = devices;
      _selectedDevice = defaultDevice;
    });

    // Call _connect if a default device is selected
    if (_selectedDevice != null) {
      _connect();
    }
  }


  Future<void> generatePdf(DayCloseOutstandingReport report) async {
    final pdf = pw.Document();

    double totalSales = report.sales != null && report.sales!.isNotEmpty
        ? report.sales!.map((sales) {
            return double.tryParse(sales.grandTotal.toString()) ?? 0.0;
          }).reduce((a, b) => a + b)
        : 0.0;

    double totalSalesreturn = report.salesReturn != null &&
            report.salesReturn!.isNotEmpty
        ? report.salesReturn!.map((salesReturn) {
            return double.tryParse(salesReturn.grandTotal.toString()) ?? 0.0;
          }).reduce((a, b) => a + b)
        : 0.0;

    double totalCollections = report.collection != null &&
            report.collection!.isNotEmpty
        ? report.collection!.map((collection) {
            return double.tryParse(collection.totalAmount.toString()) ?? 0.0;
          }).reduce((a, b) => a + b)
        : 0.0; // Default to 0 if the list is empty

    double totalExpenses = report.expense != null && report.expense!.isNotEmpty
        ? report.expense!.map((expense) {
            return double.tryParse(expense.amount.toString()) ?? 0.0;
          }).reduce((a, b) => a + b)
        : 0.0; // Default to 0 if the list is empty

    pdf.addPage(
        pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Salesman: ${report.data!.user}',
                style: pw.TextStyle(fontSize: 20)),
            pw.Text(
                'Date: ${report.data?.date != null ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(report.data!.date!)) : 'No Date'}',
                style: pw.TextStyle(fontSize: 20)),
            pw.Text('VAN NO: ${report.data!.van}',
                style: pw.TextStyle(fontSize: 20)),
            pw.Text('Petty Cash: ${report.data!.pettyCash} in hand',
                style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            if (report.sales != null && report.sales!.isNotEmpty) ...[
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Sales', style: pw.TextStyle(fontSize: 15)),
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(50), // SI NO
                  1: pw.FixedColumnWidth(120), // SHOP NAME
                  2: pw.FlexColumnWidth(), // INVOICE NO
                  3: pw.FixedColumnWidth(70), // Amount
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    children: [
                      pw.Text('SI NO',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('SHOP NAME',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('INVOICE NO',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  ...report.sales!.map((sale) {
                    String customerNames = sale.customer!
                        .map((customer) => customer.name)
                        .join(", ");
                    List<String> words = customerNames.split(' ');
                    String formattedShopName = words.length > 4
                        ? '${words.take(4).join(' ')}\n${words.skip(4).join(' ')}'
                        : customerNames;

                    return pw.TableRow(
                      children: [
                        pw.Text('${report.sales!.indexOf(sale) + 1}'), // SI NO
                        pw.Text(formattedShopName), // SHOP NAME
                        pw.Text('${sale.invoiceNo}'), // INVOICE NO
                        pw.Text('${sale.grandTotal}'), // Amount
                      ],
                    );
                  }).toList(),
                  // Total Row for Sales
                  pw.TableRow(
                    children: [
                      pw.SizedBox(), // Empty SI NO column
                      pw.SizedBox(), // Empty SHOP NAME column
                      pw.Text('Total:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('${totalSales.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],

            // Return Section
            if (report.salesReturn != null &&
                report.salesReturn!.isNotEmpty) ...[
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Return', style: pw.TextStyle(fontSize: 15)),
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(50), // SI NO
                  1: pw.FixedColumnWidth(120), // SHOP NAME
                  2: pw.FlexColumnWidth(), // Reference
                  3: pw.FixedColumnWidth(70), // Amount
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('SI NO',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('SHOP NAME',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Reference',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  ...report.salesReturn!.map((returns) {
                    String customerNames = returns.customer!
                        .map((customer) => customer.name)
                        .join(", ");
                    List<String> words = customerNames.split(' ');
                    String formattedShopName = words.length > 3
                        ? '${words.take(3).join(' ')}\n${words.skip(3).join(' ')}'
                        : customerNames;
                    return pw.TableRow(
                      children: [
                        pw.Text(
                            '${report.salesReturn!.indexOf(returns) + 1}'), // SI NO
                        pw.Text(formattedShopName), // SHOP NAME
                        pw.Text(
                            '${returns.invoiceNo ?? 'No Invoice'}'), // Reference
                        pw.Text('${returns.grandTotal}'), // Amount
                      ],
                    );
                  }).toList(),
                  pw.TableRow(
                    children: [
                      pw.SizedBox(), // Empty SI NO column
                      pw.SizedBox(), // Empty SHOP NAME column
                      pw.Text('Total:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('${totalSalesreturn.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],

// Collection Section
            if (report.collection != null && report.collection!.isNotEmpty) ...[
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Collection', style: pw.TextStyle(fontSize: 15)),
                ],
              ),
              // pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(50), // SI NO
                  1: pw.FixedColumnWidth(120), // SHOP NAME
                  2: pw.FlexColumnWidth(), // TYPE
                  3: pw.FixedColumnWidth(70), // Amount
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('SI NO',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('SHOP NAME',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('TYPE',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  ...report.collection!.map((collection) {
                    String customerNames = collection.customer!
                        .map((customer) => customer.name)
                        .join(", ");
                    List<String> words = customerNames.split(' ');
                    String formattedShopName = words.length > 3
                        ? '${words.take(3).join(' ')}\n${words.skip(3).join(' ')}'
                        : customerNames;
                    return pw.TableRow(
                      children: [
                        pw.Text(
                            '${report.collection!.indexOf(collection) + 1}'), // SI NO
                        pw.Text(formattedShopName), // SHOP NAME
                        pw.Text(
                            '${collection.collectionType ?? 'No Type'}'), // TYPE
                        pw.Text('${collection.totalAmount}'), // Amount
                      ],
                    );
                  }).toList(),
                  pw.TableRow(
                    children: [
                      pw.SizedBox(), // Empty SI NO column
                      pw.SizedBox(), // Empty SHOP NAME column
                      pw.Text('Total:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('${totalCollections.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],

// Expense Section
            if (report.expense != null && report.expense!.isNotEmpty) ...[
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Expense', style: pw.TextStyle(fontSize: 15)),
                ],
              ),
              // pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(50), // SI NO
                  1: pw.FixedColumnWidth(120), // Type
                  2: pw.FlexColumnWidth(), // Remarks
                  3: pw.FixedColumnWidth(70), // Amount
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('SI NO',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Type',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Remarks',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  ...report.expense!.map((expense) {
                    String expenseTypes =
                        expense.expense!.map((e) => e.name).join(", ");
                    return pw.TableRow(
                      children: [
                        pw.Text(
                            '${report.expense!.indexOf(expense) + 1}'), // SI NO
                        pw.Text(expenseTypes), // Type
                        pw.Text(
                            '${expense.description ?? 'No Remarks'}'), // Remarks
                        pw.Text('${expense.amount}'), // Amount
                      ],
                    );
                  }).toList(),
                  pw.TableRow(
                    children: [
                      pw.SizedBox(), // Empty SI NO column
                      pw.SizedBox(), // Empty Type column
                      pw.Text('Total:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('${totalExpenses.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],

            pw.SizedBox(height: 20),

            pw.Row(
              children: [
                pw.Text(
                    'Net Cash Balance: ${totalCollections - totalExpenses}'),
              ],
            ),
          ],
        );
      },
    ));
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/day_report.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  // Function to format shop names
  String formatShopName(String name, int maxWordsPerLine) {
    List<String> words = name.split(' ');

    // If the name has fewer words than maxWordsPerLine, return it as is
    if (words.isEmpty) {
      return '';
    }

    if (words.length <= maxWordsPerLine) {
      return name;
    }

    // Break the name into lines based on maxWordsPerLine
    StringBuffer formattedName = StringBuffer();
    for (int i = 0; i < words.length; i++) {
      formattedName.write(words[i] + ' ');

      // Insert a newline after reaching max words per line
      if ((i + 1) % maxWordsPerLine == 0 && i != words.length - 1) {
        formattedName.write('\n'); // New line
      }
    }

    return formattedName.toString().trim();
  }

  void _print(DayCloseOutstandingReport report) async {
    if (_connected) {
      double totalSales = report.sales != null && report.sales!.isNotEmpty
          ? report.sales!.map((sales) {
        return double.tryParse(sales.grandTotal.toString()) ?? 0.0;
      }).reduce((a, b) => a + b)
          : 0.0;

      double totalSalesreturn = report.salesReturn != null &&
          report.salesReturn!.isNotEmpty
          ? report.salesReturn!.map((salesReturn) {
        return double.tryParse(salesReturn.grandTotal.toString()) ?? 0.0;
      }).reduce((a, b) => a + b)
          : 0.0;

      double totalCollections = report.collection != null &&
          report.collection!.isNotEmpty
          ? report.collection!.map((collection) {
        return double.tryParse(collection.totalAmount.toString()) ?? 0.0;
      }).reduce((a, b) => a + b)
          : 0.0;

      double totalExpenses = report.expense != null && report.expense!.isNotEmpty
          ? report.expense!.map((expense) {
        return double.tryParse(expense.amount.toString()) ?? 0.0;
      }).reduce((a, b) => a + b)
          : 0.0;

      // Printing section headers and key info
      printer.printCustom('Salesman: ${report.data!.user}', 1, 0);
      printer.printCustom(
          'Date: ${report.data?.date != null ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(report.data!.date!)) : 'No Date'}',
          1, 0);
      printer.printCustom('VAN NO: ${report.data!.van}', 1, 0);
      printer.printCustom('Petty Cash: ${report.data!.pettyCash} in hand', 1, 0);
      printer.printNewLine();
      void printAlignedText(String leftText, String rightText) {
        const int maxLineLength =
        68; // Adjust the maximum line length as per your printer's character limit
        int leftTextLength = leftText.length;
        int rightTextLength = rightText.length;

        // Calculate padding to ensure rightText is right-aligned
        int spaceLength = maxLineLength - (leftTextLength + rightTextLength);
        String spaces = ' ' * spaceLength;

        printer.printCustom(
            '$leftText$spaces$rightText', 1, 0); // Print with left-aligned text
      }

      // Printing Sales Section
      if (report.sales != null && report.sales!.isNotEmpty) {
        // Define column widths
        const int columnWidth1 = 10;  // S.No
        const int columnWidth2 = 30; // Shop Name
        const int columnWidth3 = 12; // Invoice No
        const int columnWidth4 = 8;  // Amount

        // Print the table header
        String headers = "${'SI NO'.padRight(columnWidth1)}"
            "${'SHOP NAME'.padRight(columnWidth2)}"
            "${'INVOICE NO'.padRight(columnWidth3)}"
            "${'Amount'.padLeft(columnWidth4)}";
        printer.printCustom('Sales', 1, 0);  // Section title
        printer.printCustom(headers, 1, 0);  // Print table headers

        // Helper function to split text by word count
        List<String> splitByWords(String text, int maxWords) {
          List<String> words = text.split(' ');
          List<String> lines = [];
          for (int i = 0; i < words.length; i += maxWords) {
            lines.add(words.sublist(i, i + maxWords > words.length ? words.length : i + maxWords).join(' '));
          }
          return lines;
        }

        // Print each sale row
        for (var sale in report.sales!) {
          String customerNames = sale.customer!.map((customer) => customer.name).join(", ");

          List<String> customerNameLines = splitByWords(customerNames, 4);
          String firstLine = "${(report.sales!.indexOf(sale) + 1).toString().padRight(columnWidth1)}"
              "${customerNameLines[0].padRight(columnWidth2)}"
              "${sale.invoiceNo!.padRight(columnWidth3)}"
              "${sale.grandTotal!.toStringAsFixed(2).padLeft(columnWidth4)}";

          printer.printCustom(firstLine, 1, 0);

          for (int i = 1; i < customerNameLines.length; i++) {
            String subsequentLine = "${''.padRight(columnWidth1)}"  // Empty space for SI NO
                "${customerNameLines[i].padRight(columnWidth2)}";    // Print remaining shop name lines
            printer.printCustom(subsequentLine, 1, 0);
          }
        }
        printer.printNewLine();
        printAlignedText('','Total Sales: ${totalSales.toStringAsFixed(2)}');
        printer.printNewLine();
      }


      // Printing Return Section
      if (report.salesReturn != null && report.salesReturn!.isNotEmpty) {
        const int columnWidth1 = 10;  // S.No
        const int columnWidth2 = 30; // Shop Name
        const int columnWidth3 = 12; // Invoice No
        const int columnWidth4 = 8;  // Amount

        // Print the table header
        String headers = "${'SI NO'.padRight(columnWidth1)}"
            "${'SHOP NAME'.padRight(columnWidth2)}"
            "${'TYPE'.padRight(columnWidth3)}"
            "${'Amount'.padLeft(columnWidth4)}";
        printer.printCustom('Sales Return', 1, 0);  // Section title
        printer.printCustom(headers, 1, 0);       // Print table headers

        // Helper function to split text by word count
        List<String> splitByWords(String text, int maxWords) {
          List<String> words = text.split(' ');
          List<String> lines = [];
          for (int i = 0; i < words.length; i += maxWords) {
            lines.add(words.sublist(i, i + maxWords > words.length ? words.length : i + maxWords).join(' '));
          }
          return lines;
        }
        for (var salesReturn in report.salesReturn!) {
          String customerNames = salesReturn.customer!.map((customer) => customer.name).join(", ");
          List<String> customerNameLines = splitByWords(customerNames, 4);
          String firstLine = "${(report.salesReturn!.indexOf(salesReturn) + 1).toString().padRight(columnWidth1)}"
              "${customerNameLines[0].padRight(columnWidth2)}"
              "${(salesReturn.invoiceNo ?? 'No Type').padRight(columnWidth3)}"
              "${salesReturn.grandTotal!.toStringAsFixed(2).padLeft(columnWidth4)}";

          printer.printCustom(firstLine, 1, 0);
          for (int i = 1; i < customerNameLines.length; i++) {
            String subsequentLine = "${''.padRight(columnWidth1)}"
                "${customerNameLines[i].padRight(columnWidth2)}";
            printer.printCustom(subsequentLine, 1, 0);
          }
        }
        printer.printNewLine();
        printAlignedText('', 'Total Sales Return: ${totalSalesreturn.toStringAsFixed(2)}');
        // printer.printCustom('Total Collections: $totalCollections', 1, 0);
        printer.printNewLine();
        // printer.printCustom('Return', 1, 0);
        // printer.printCustom('SI NO  SHOP NAME        Reference    Amount', 1, 0);
        // for (var returns in report.salesReturn!) {
        //   String customerNames = returns.customer!.map((customer) => customer.name).join(", ");
        //   String formattedShopName = customerNames.length > 12
        //       ? '${customerNames.substring(0, 12)}...' // Shorten long names
        //       : customerNames;
        //   printer.printCustom(
        //       '${(report.salesReturn!.indexOf(returns) + 1).toString().padRight(6)}'
        //           '${formattedShopName.padRight(16)}'
        //           '${returns.invoiceNo?.padRight(12) ?? 'No Invoice'.padRight(12)}'
        //           '${returns.grandTotal.toString().padLeft(8)}',
        //       1, 0);
        // }
        // printer.printCustom('Total Sales Return: $totalSalesreturn', 1, 0);
        // printer.printNewLine();
      }

      // Printing Collection Section
      if (report.collection != null && report.collection!.isNotEmpty) {
        // Define column widths
        const int columnWidth1 = 10;  // S.No
        const int columnWidth2 = 30; // Shop Name
        const int columnWidth3 = 12; // Invoice No
        const int columnWidth4 = 8;  // Amount

        // Print the table header
        String headers = "${'SI NO'.padRight(columnWidth1)}"
            "${'SHOP NAME'.padRight(columnWidth2)}"
            "${'TYPE'.padRight(columnWidth3)}"
            "${'Amount'.padLeft(columnWidth4)}";
        printer.printCustom('Collection', 1, 0);  // Section title
        printer.printCustom(headers, 1, 0);       // Print table headers

        // Helper function to split text by word count
        List<String> splitByWords(String text, int maxWords) {
          List<String> words = text.split(' ');
          List<String> lines = [];
          for (int i = 0; i < words.length; i += maxWords) {
            lines.add(words.sublist(i, i + maxWords > words.length ? words.length : i + maxWords).join(' '));
          }
          return lines;
        }

        // Print each collection row
        for (var collection in report.collection!) {
          String customerNames = collection.customer!.map((customer) => customer.name).join(", ");
          List<String> customerNameLines = splitByWords(customerNames, 4);
          String firstLine = "${(report.collection!.indexOf(collection) + 1).toString().padRight(columnWidth1)}"
              "${customerNameLines[0].padRight(columnWidth2)}"
              "${(collection.collectionType ?? 'No Type').padRight(columnWidth3)}"
              "${(double.tryParse(collection.totalAmount ?? '0')?.toStringAsFixed(2) ?? '0.00').padLeft(columnWidth4)}";

          printer.printCustom(firstLine, 1, 0);
          for (int i = 1; i < customerNameLines.length; i++) {
            String subsequentLine = "${''.padRight(columnWidth1)}"
                "${customerNameLines[i].padRight(columnWidth2)}";
            printer.printCustom(subsequentLine, 1, 0);
          }
        }
        printer.printNewLine();
        printAlignedText('', 'Total Collections: ${totalCollections.toStringAsFixed(2)}');
        // printer.printCustom('Total Collections: $totalCollections', 1, 0);
        printer.printNewLine();
      }




      // Printing Expense Section
      if (report.expense != null && report.expense!.isNotEmpty) {
        const int columnWidth1 = 10;  // S.No
        const int columnWidth2 = 30; // Shop Name
        const int columnWidth3 = 12; // Invoice No
        const int columnWidth4 = 8;  // Amount

        // Print the table header
        String headers = "${'SI NO'.padRight(columnWidth1)}"
            "${'SHOP NAME'.padRight(columnWidth2)}"
            "${'TYPE'.padRight(columnWidth3)}"
            "${'Amount'.padLeft(columnWidth4)}";
        printer.printCustom('Expense', 1, 0);  // Section title
        printer.printCustom(headers, 1, 0);       // Print table headers

        // Helper function to split text by word count
        List<String> splitByWords(String text, int maxWords) {
          List<String> words = text.split(' ');
          List<String> lines = [];
          for (int i = 0; i < words.length; i += maxWords) {
            lines.add(words.sublist(i, i + maxWords > words.length ? words.length : i + maxWords).join(' '));
          }
          return lines;
        }
        for (var expense in report.expense!) {
          String expenseTypes = expense.expense!.map((e) => e.name).join(", ");
          List<String> customerNameLines = splitByWords(expenseTypes, 4);
          String firstLine = "${(report.expense!.indexOf(expense) + 1).toString().padRight(columnWidth1)}"
              "${customerNameLines[0].padRight(columnWidth2)}"
              "${(expense.description ?? 'No Type').padRight(columnWidth3)}"
              "${(double.tryParse(expense.amount ?? '0')?.toStringAsFixed(2) ?? '0.00').padLeft(columnWidth4)}";


          printer.printCustom(firstLine, 1, 0);
          for (int i = 1; i < customerNameLines.length; i++) {
            String subsequentLine = "${''.padRight(columnWidth1)}"
                "${customerNameLines[i].padRight(columnWidth2)}";
            printer.printCustom(subsequentLine, 1, 0);
          }

          // printer.printCustom(
          //     '${(report.expense!.indexOf(expense) + 1).toString().padRight(6)}'
          //         '${expenseTypes.padRight(16)}'
          //         '${expense.description?.padRight(12) ?? 'No Remarks'.padRight(12)}'
          //         '${expense.amount.toString().padLeft(8)}',
          //     1, 0);
        }
        printer.printNewLine();
        printAlignedText('','Total Expenses: ${totalExpenses.toStringAsFixed(2)}');
        printer.printNewLine();
      }

      // Net Cash Balance
      double netCashBalance =
          // (report.data!.pettyCash ?? 0) +
              totalCollections - totalExpenses;
      printer.printCustom('Net Cash Balance: $netCashBalance', 1, 0);
      printer.printNewLine();

      printer.printCustom('Thank you', 1, 1);
      printer.paperCut();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        title: const Text(
          'Day Report',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
      ),
      body: FutureBuilder<DayCloseOutstandingReport>(
        future: fetchDayCloseOutstandingReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final report = snapshot.data!;

            // Safely handling potential null or empty collections
            final collections = report.collection ?? [];
            final expenses = report.expense ?? [];
            final sales = report.sales ?? [];
            final salesReturns = report.salesReturn ?? [];

            double totalSale = sales.fold(0.0, (sum, returns) {
              return sum +
                  (double.tryParse(returns.grandTotal!.toStringAsFixed(2)) ?? 0.0);
            });
            double totalSum = salesReturns.fold(0.0, (sum, returns) {
              return sum +
                  (double.tryParse(returns.grandTotal!.toStringAsFixed(2)) ?? 0.0);
            });
            // Calculate totals only if the lists are not empty
            double totalCollections = collections.fold(0.0, (sum, returns) {
              return sum + (double.tryParse(returns.totalAmount.toString()) ?? 0.0);
            });

            String totalCollectionsFormatted = totalCollections.toStringAsFixed(2);

            double totalExpenses = expenses.fold(0.0, (sum, returns) {
              return sum + (double.tryParse(returns.amount.toString()) ?? 0.0);
            });

            String totalExpenseFormated  = totalExpenses.toStringAsFixed(2);
            double netCashBalance =
                // (report.data?.pettyCash ?? 0) +
                    totalCollections - totalExpenses;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Salesman: ${report.data?.user ?? 'No User'}',
                              style: TextStyle(fontSize: AppConfig.labelSize),
                            ),
                            Text(
                              'Date: ${report.data?.date != null ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(report.data!.date!)) : 'No Date'}',
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('VAN NO: ${report.data?.van ?? 'No VAN'}'),
                            Text(
                                'Petty Cash: ${report.data?.pettyCash ?? 0} in hand')
                          ],
                        ),
                        InkWell(
                          onTap: () => _print(report),
                          child: Icon(
                            Icons.print,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                        ),
                        InkWell(
                          onTap: () => generatePdf(report),
                          child: Icon(
                            Icons.document_scanner,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // Sales Section
                    Text(
                      'Sales',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    if (sales.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 40, // Fixed width for SI NO
                                child: Text(
                                  'SI NO',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Flexible(
                                flex: 5, // Fixed width for SHOP NAME
                                child: Text(
                                  'SHOP NAME',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Flexible(
                                flex: 11, // Less space for INVOICE NO
                                child: Text(
                                  'INVOICE NO',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                flex: 3, // More space for Amount
                                child: Text(
                                  'Amount',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8), // Space between header and list

                          // ListView for sales data
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: sales.length,
                            itemBuilder: (context, index) {
                              final sale = sales[index];
                              double totalAmountsss =
                                  double.tryParse(sale.grandTotal.toString()) ??
                                      0.0;
                              String shopName =
                                  '${sale.customer?.map((customer) => customer.name).join(", ") ?? 'No Customer'}';
                              List<String> words = shopName.split(' ');
                              String formattedShopName = words.length > 4
                                  ? '${words.take(4).join(' ')}\n${words.skip(4).join(' ')}'
                                  : shopName;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0), // Padding between rows
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 25, // Fixed width for SI NO
                                      child: Text(
                                        '${index + 1}', // SI NO
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 6, // Fixed width for SHOP NAME
                                      child: Text(
                                        formattedShopName, // SHOP NAME
                                        textAlign: TextAlign.center,
                                        // overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5, // Less space for INVOICE NO
                                      child: Text(
                                        '${sale.invoiceNo ?? 'No Invoice'}', // INVOICE NO
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3, // More space for Amount
                                      child: Text(
                                        '${sale.grandTotal?.toStringAsFixed(2)}', // Amount
                                        textAlign: TextAlign
                                            .right, // Align amount to the right
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Total Row
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total: ${totalSale.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Text('No Sales Available'),

                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Return',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    if (salesReturns.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 40, // Fixed width for SI NO
                                child: Text(
                                  'SI NO',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Flexible(
                                flex: 5, // Fixed width for SHOP NAME
                                child: Text(
                                  'SHOP NAME',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Flexible(
                                flex: 11, // Less space for Reference
                                child: Text(
                                  'Reference',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                flex: 3, // More space for Amount
                                child: Text(
                                  'Amount',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8), // Space between header and list

                          // ListView for sales return data
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: salesReturns.length,
                            itemBuilder: (context, index) {
                              final returns = salesReturns[index];
                              String shopName =
                                  '${returns.customer?.map((customer) => customer.name).join(", ") ?? 'No Customer'}';
                              List<String> words = shopName.split(' ');
                              String formattedShopName = words.length > 4
                                  ? '${words.take(4).join(' ')}\n${words.skip(4).join(' ')}'
                                  : shopName;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0), // Padding between rows
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 20, // Fixed width for SI NO
                                      child: Text('${index + 1}',
                                          textAlign: TextAlign.left), // SI NO
                                    ),
                                    Flexible(
                                      flex: 6, // Fixed width for SHOP NAME
                                      child: Text(
                                        formattedShopName, // SHOP NAME
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5, // Less space for Reference
                                      child: Text(
                                          '${returns.invoiceNo ?? 'No Invoice'}',
                                          textAlign:
                                              TextAlign.left), // Reference
                                    ),
                                    Expanded(
                                      flex: 3, // More space for Amount
                                      child: Text(
                                          '${returns.grandTotal!.toStringAsFixed(2)}',
                                          textAlign: TextAlign.right), // Amount
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Total Row
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total: ${totalSum.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Text('No Returns Available'),

                    // Collection Section
                    SizedBox(
                      height: 20,
                    ),
                    Text('Collection',
                        style: TextStyle(fontWeight: FontWeight.w500)),

                    if (collections.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('SI NO'),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('SHOP NAME'),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('TYPE'),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Amount'),
                                ],
                              ),
                            ],
                          ),
                          // ListView for collections data
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: collections.length,
                            itemBuilder: (context, index) {
                              final collection = collections[index];
                              double totalAmountsss = double.tryParse(
                                      collection.totalAmount.toString()) ??
                                  0.0;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${index + 1}'), // SI NO
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${collection.customer?.map((customer) => customer.name).join(", ") ?? 'No Customer'}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${collection.collectionType ?? 'No Type'}'), // TYPE
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${collection.totalAmount.toString()}'), // Amount
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          // Total Row
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total: ${totalCollectionsFormatted}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Text('No Collections Available'),

                    // Expenses Section
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Expense',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    if (expenses.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 40, // Fixed width for SI NO
                                child: Text(
                                  'SI NO',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Flexible(
                                flex: 5, // Fixed width for SHOP NAME
                                child: Text(
                                  'EXPENSE NAME',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Flexible(
                                flex: 11, // Less space for Reference
                                child: Text(
                                  'Reference',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                flex: 3, // More space for Amount
                                child: Text(
                                  'Amount',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8), // Space between header and list

                          // ListView for expense data
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              final expense = expenses[index];
                              String expenseName =
                                  '${expense.expense?.map((exp) => exp.name).join(", ") ?? 'No Expense'}';

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0), // Padding between rows
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 20, // Fixed width for SI NO
                                      child: Text('${index + 1}',
                                          textAlign: TextAlign.left), // SI NO
                                    ),
                                    Flexible(
                                      flex: 6, // Fixed width for EXPENSE NAME
                                      child: Text(
                                        expenseName, // EXPENSE NAME
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5, // Less space for Reference
                                      child: Text(
                                          '${expense.description ?? 'No Reference'}',
                                          textAlign:
                                              TextAlign.left), // Reference
                                    ),
                                    Expanded(
                                      flex: 3, // More space for Amount
                                      child: Text(
                                          '${expense.amount.toString()}',
                                          textAlign: TextAlign.right), // Amount
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Total Row
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total: $totalExpenseFormated',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Text('No Expense Available'),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Net Cash Balance',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(netCashBalance.toStringAsFixed(2)),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No Data Available'));
          }
        },
      ),
    );
  }
}
