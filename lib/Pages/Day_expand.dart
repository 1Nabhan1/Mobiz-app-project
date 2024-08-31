import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import '../Components/commonwidgets.dart';
import '../Models/Day_close.dart';
import '../Models/Store_model.dart';
import '../Utilities/rest_ds.dart';
import '../confg/sizeconfig.dart';

class Dayexpanding extends StatefulWidget {
  final int id;
  final String invoiceNo;

  const Dayexpanding({Key? key, required this.id, required this.invoiceNo})
      : super(key: key);

  @override
  State<Dayexpanding> createState() => _DayexpandingState();
}

class _DayexpandingState extends State<Dayexpanding> {
  late Future<DataResponse> futureDayCloseData;

  @override
  void initState() {
    super.initState();
    futureDayCloseData = fetchDayCloseData(widget.id);
  }

  Future<DataResponse> fetchDayCloseData(int id) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_dayclose_by_id?van_id=${AppState().vanId}&store_id=${AppState().storeId}&id=$id'));

    if (response.statusCode == 200) {
      return DataResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> generatePdf(Data dayClose) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_store_detail?store_id=${AppState().storeId}'));
    if (response.statusCode == 200) {
      // Parse JSON response into StoreDetail object
      StoreDetail storeDetail =
          StoreDetail.fromJson(json.decode(response.body));

      final pdf = pw.Document();
      // double balance = opening;
      final String api =
          '${RestDatasource().Image_URL}/uploads/store/${storeDetail.logos}';
      final logoResponse = await http.get(Uri.parse(api));
      if (logoResponse.statusCode != 200) {
        // print(api);
        // print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
        throw Exception('Failed to load logo image');
      }
      final Uint8List logoBytes = logoResponse.bodyBytes;

      String addressText = storeDetail.address != null
          ? "Address: ${storeDetail.address}, "
          : "";
      String countryText =
          storeDetail.country != null ? "${storeDetail.country}" : "";

      String finalText = "";

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) => [
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Center(
                        child: pw.Image(
                          pw.MemoryImage(logoBytes),
                          height: 100,
                          width: 100,
                          fit: pw.BoxFit.cover,
                        ),
                      ),
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
                      pw.Text('Reports', style: pw.TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(color: PdfColors.grey, height: 1, thickness: 1),
                pw.SizedBox(height: 20),
                pw.Text('Hello ${AppState().name}',
                    style: pw.TextStyle(
                        fontSize: 21, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 7),
                pw.Text('Van: ${dayClose.vanId}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'Sales: ${dayClose.noOfSales} | ${dayClose.amountOfSales}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'Orders: ${dayClose.noOfOrder} | ${dayClose.amountOfOrder}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'Returns: ${dayClose.noOfReturns} | ${dayClose.amountOfReturns}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 10),
                pw.Text('Collection:', style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 5),
                pw.Text('Cash: ${dayClose.collectionCashAmount}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'Cheque: ${dayClose.collectionChequeAmount} | ${dayClose.collectionNoOfCheque}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 10),
                pw.Text('Last Day Balance:', style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 5),
                pw.Text('Cash: ${dayClose.lastDayBalanceAmount}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'Cheque: ${dayClose.lastDayBalanceNoOfCheque} | ${dayClose.lastDayBalanceChequeAmount}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 15),
                pw.Divider(color: PdfColors.grey, height: 1, thickness: 1),
                pw.SizedBox(height: 25),
                pw.Text('Cash Deposited: ${dayClose.cashDeposited}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text('Cash Handed Over: ${dayClose.cashHandOver}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'No of Cheque Deposited: ${dayClose.noOfChequeDeposited}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'Cheque Deposited Amount: ${dayClose.chequeDepositedAmount}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'No of Cheque Handed Over: ${dayClose.noOfChequeHandOver}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text(
                    'Cheque Handed Over Amount: ${dayClose.chequeHandOverAmount}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text('Balance Cash in Hand: ${dayClose.balanceCashInHand}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text('No of Cheque in Hand: ${dayClose.noOfChequeInHand}',
                    style: pw.TextStyle(fontSize: 15)),
                pw.SizedBox(height: 3),
                pw.Text('Cheque Amount in Hand: ${dayClose.chequeAmountInHand}',
                    style: pw.TextStyle(fontSize: 15)),
              ],
            ),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/day_close_report.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } else {
      throw Exception('Failed to load store details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppConfig.colorPrimary,
        title: Text(
          'Reports',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<DataResponse>(
        future: futureDayCloseData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            Data dayClose = snapshot.data!.data;
            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.print, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () => generatePdf(dayClose),
                            child:
                                Icon(Icons.document_scanner, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 0),
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
                                  text: ' ${dayClose.vanId}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Sales  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text:
                                      '${dayClose.noOfSales} | ${dayClose.amountOfSales}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Orders  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text:
                                      '${dayClose.noOfOrder} | ${dayClose.amountOfOrder}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Returns  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text:
                                      '${dayClose.noOfReturns} | ${dayClose.amountOfReturns}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text('Collection'),
                          Text(
                            'Cash ${dayClose.collectionCashAmount}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Cheque ${dayClose.collectionChequeAmount} | ${dayClose.collectionNoOfCheque}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text('Last Day Balance'),
                          Text(
                            'Cash ${dayClose.lastDayBalanceAmount}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Cheque ${dayClose.lastDayBalanceNoOfCheque} | ${dayClose.lastDayBalanceChequeAmount}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Expense  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.expense}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Cash Deposited  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.cashDeposited}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Cash Handed Over  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.cashHandOver}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'No of Cheque Deposited  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.noOfChequeDeposited}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Cheque Deposited Amount  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.chequeDepositedAmount}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'No of Cheque Handed Over  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.noOfChequeHandOver}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Cheque Handed Over Amount  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.chequeHandOverAmount}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Balance Cash in Hand  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.balanceCashInHand}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'No of Cheque in Hand  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.noOfChequeInHand}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Cheque Amount in Hand  ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${dayClose.chequeAmountInHand}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
