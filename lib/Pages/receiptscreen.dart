import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobizapp/Components/commonwidgets.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import '../Models/Store_model.dart';
import '../Models/receiptdatamodel.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class ReceiptScreen extends StatefulWidget {
  static const receiptScreen = "/Receipt";
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  bool _initDone = false;
  bool _noData = false;

  ReceiptsData receiptsData = ReceiptsData();

  @override
  void initState() {
    super.initState();
    _getRecentData();
  }

  Future<void> generatePdf(Data data) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_store_detail?store_id=${AppState().storeId}'));
    if (response.statusCode == 200) {
      // Parse JSON response into StoreDetail object
      StoreDetail storeDetail =
          StoreDetail.fromJson(json.decode(response.body));

      final pdf = pw.Document();
      final String api =
          '${RestDatasource().Image_URL}/uploads/store/${storeDetail.logos}';
      final logoResponse = await http.get(Uri.parse(api));
      if (logoResponse.statusCode != 200) {
        throw Exception('Failed to load logo image');
      }
      final Uint8List logoBytes = logoResponse.bodyBytes;

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
                      pw.SizedBox(height: 3),
                      pw.Text('${storeDetail.address ?? 'N/A'}'),
                      pw.SizedBox(height: 3),
                      pw.Text('TRN: ${storeDetail.trn ?? 'N/A'}'),
                      pw.SizedBox(height: 3),
                      pw.Text('RECEIPT VOUCHER',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(color: PdfColors.grey, height: 1, thickness: 1),
                pw.SizedBox(height: 20),
                // pw.Text(
                //   '${DateFormat('dd MMMM yyyy').format(DateTime.parse(data.inDate!))} ${data.inTime} | ${data.voucherNo}',
                // ),
                pw.SizedBox(height: 3),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text('Customer:'),
                            pw.Text(
                              (data.customer!.isNotEmpty)
                                  ? data.customer![0].code ?? ''
                                  : '',
                              style: pw.TextStyle(
                                fontSize: AppConfig.textCaption3Size,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(' | '),
                            pw.Text('${data.customer![0].name}')
                          ],
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text('Market: ${data.customer![0].address}'),
                        pw.SizedBox(height: 3),
                        pw.Text('TRN: ${data.customer![0].trn}'),
                        // pw.SizedBox(height: 3),
                        // pw.Text('TRN : ${data.customer![0].trn}'),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                            'Reference: ${data.sales![0].voucherNo ?? 'N/A'}'),
                        pw.Text('Date : ${data.sales![0].inDate}'),
                        pw.Text('Due Date: ${data.sales![0].inDate}'),
                      ],
                    )
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Divider(color: PdfColors.grey, height: 1, thickness: .5),
                pw.SizedBox(height: 10),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Collection Type:  ${data.collectionType}'),
                      pw.Text('Bank Name: ${data.bank}'),
                      pw.Text('Cheque No: ${data.chequeNo}'),
                      pw.Text('Cheque Date: ${data.chequeDate}'),
                      pw.Text('Amount: ${data.totalAmount}'),
                      // pw.Text('Amount in Words: ${data.totalAmount}'),
                    ]),
                pw.SizedBox(height: 10),
                pw.Divider(color: PdfColors.grey, height: 1, thickness: .5),
                // pw.Text('Sales Details', style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Column(
                  children: [
                    // Table with headings
                    pw.Table(
                      border: pw.TableBorder(
                        top: pw.BorderSide.none,
                        bottom: pw.BorderSide.none,
                        left: pw.BorderSide.none,
                        right: pw.BorderSide.none,
                        horizontalInside: pw.BorderSide.none,
                        verticalInside: pw.BorderSide.none,
                      ),
                      children: [
                        pw.TableRow(
                          verticalAlignment:
                              pw.TableCellVerticalAlignment.middle,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4.0),
                              child: pw.Text(
                                'SI NO',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: AppConfig.textCaption3Size,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4.0),
                              child: pw.Text(
                                'Reference No',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: AppConfig.textCaption3Size,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4.0),
                              child: pw.Text(
                                'Type',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: AppConfig.textCaption3Size,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4.0),
                              child: pw.Text(
                                'Amount',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: AppConfig.textCaption3Size,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Line below the header
                    pw.Divider(color: PdfColors.grey, height: 1, thickness: .5),

                    // Table with data
                    pw.Table(
                      border: pw.TableBorder(
                        top: pw.BorderSide.none,
                        bottom: pw.BorderSide.none,
                        left: pw.BorderSide.none,
                        right: pw.BorderSide.none,
                        horizontalInside: pw.BorderSide.none,
                        verticalInside: pw.BorderSide.none,
                      ),
                      children: [
                        ...data.sales!.asMap().entries.map((entry) {
                          final index =
                              entry.key + 1; // Serial number starts from 1
                          final sale = entry.value;
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  '$index',
                                  style: pw.TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  sale.invoiceNo ?? 'N/A',
                                  style: pw.TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  sale.invoiceType ?? 'N/A',
                                  style: pw.TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  sale.amount?.toString() ?? 'N/A',
                                  style: pw.TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                  // textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),

                // pw.SizedBox(height: 20),
                // pw.Divider(color: PdfColors.grey, height: 1, thickness: 1),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Van: ${data.vanId}'),
                        pw.SizedBox(height: 3),
                        pw.Text('Salesman: N/A'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/receipt_report.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } else {
      throw Exception('Failed to load store details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        title: const Text(
          'Receipts',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
        backgroundColor: AppConfig.colorPrimary,
      ),
      body: Column(
        children: [
          CommonWidgets.verticalSpace(1),
          (_initDone && !_noData)
              ? SizedBox(
                  height: SizeConfig.blockSizeVertical * 85,
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        CommonWidgets.verticalSpace(1),
                    itemCount: receiptsData.data?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final data = receiptsData.data![index];
                      return _productsCard(data);
                    },
                  ),
                )
              : (_noData && _initDone)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonWidgets.verticalSpace(3),
                        const Center(
                          child: Text('No Data'),
                        ),
                      ],
                    )
                  : Shimmer.fromColors(
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
                            CommonWidgets.loadingContainers(
                                height: SizeConfig.blockSizeVertical * 10,
                                width: SizeConfig.blockSizeHorizontal * 90),
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _productsCard(Data data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
        // width: SizeConfig.blockSizeHorizontal * 90,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 2,
                blurStyle: BlurStyle.inner,
                color: Colors.grey.shade200)
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          color: AppConfig.backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            trailing: SizedBox(
              width: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => generatePdf(data),
                      child: Icon(Icons.print, color: Colors.blueAccent)),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => generatePdf(data),
                    child: Icon(Icons.document_scanner, color: Colors.red),
                  ),
                ],
              ),
            ),
            backgroundColor: AppConfig.backgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // width: SizeConfig.blockSizeHorizontal * 70,
                      child: Text(
                        '${DateFormat('dd MMMM yyyy').format(DateTime.parse(data.inDate!))} ${data.inTime} | ${data.voucherNo}',
                        style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          (data.customer!.isNotEmpty)
                              ? data.customer![0].code ?? ''
                              : '',
                          style: TextStyle(
                              fontSize: AppConfig.textCaption3Size,
                              fontWeight: AppConfig.headLineWeight),
                        ),
                        Text(' | '),
                        Text(
                          overflow: TextOverflow.fade,
                          (data.customer!.isNotEmpty)
                              ? data.customer![0].name ?? ''
                              : '',
                          style: TextStyle(
                              fontSize: AppConfig.textCaption3Size,
                              fontWeight: AppConfig.headLineWeight),
                        ),
                      ],
                    ),
                    Text(
                      'Amount: ${data.totalAmount}',
                      style: TextStyle(
                        fontSize: AppConfig.textCaption3Size,
                      ),
                    ),
                    Text(
                      'Type:  ${data.collectionType}',
                      style: TextStyle(
                        fontSize: AppConfig.textCaption3Size,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            children: [
              Wrap(
                children: List.generate(data.sales?.length ?? 0, (index) {
                  final sale = data.sales![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        Text(
                          'Invoice No: ${sale.invoiceNo ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: AppConfig.textCaption3Size,
                          ),
                        ),
                        Text(
                          'Invoice Type: ${sale.invoiceType ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: AppConfig.textCaption3Size,
                          ),
                        ),
                        Text(
                          'Amount: ${sale.amount ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: AppConfig.textCaption3Size,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _getRecentData() async {
    RestDatasource api = RestDatasource();
    Map<String, dynamic> response = await api.getDetails(
        '/api/get_collection_report?store_id=${AppState().storeId}&van_id=${AppState().vanId}',
        AppState().token);

    receiptsData = ReceiptsData.fromJson(response);
    if (response['data'] != null) {
      setState(() {
        _initDone = true;
      });
    } else {
      setState(() {
        _initDone = true;
        _noData = true;
      });
    }
    print('Response Data $response');
  }
}
