// Future<void> generatePdf(Data data) async {
//   final response = await http.get(Uri.parse(
//       '${RestDatasource().BASE_URL}/api/get_store_detail?store_id=${AppState().storeId}'));
//   if (response.statusCode == 200) {
//     // Parse JSON response into StoreDetail object
//     StoreDetail storeDetail =
//     StoreDetail.fromJson(json.decode(response.body));
//
//     final pdf = pw.Document();
//     final String api =
//         '${RestDatasource().Image_URL}/uploads/store/${storeDetail.logos}';
//     final logoResponse = await http.get(Uri.parse(api));
//     if (logoResponse.statusCode != 200) {
//       throw Exception('Failed to load logo image');
//     }
//     final Uint8List logoBytes = logoResponse.bodyBytes;
//
//     pdf.addPage(
//       pw.MultiPage(
//         build: (pw.Context context) => [
//           pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Center(
//                 child: pw.Column(
//                   children: [
//                     pw.Image(
//                       pw.MemoryImage(logoBytes),
//                       height: 100,
//                       width: 100,
//                       fit: pw.BoxFit.cover,
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       storeDetail.name,
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 3),
//                     pw.Text('${storeDetail.address ?? 'N/A'}'),
//                     pw.SizedBox(height: 3),
//                     pw.Text('TRN: ${storeDetail.trn ?? 'N/A'}'),
//                     pw.SizedBox(height: 3),
//                     pw.Text(
//                       'RECEIPT VOUCHER',
//                       style: pw.TextStyle(
//                         fontSize: 16,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Divider(color: PdfColors.grey, height: 1, thickness: 1),
//               pw.SizedBox(height: 20),
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text('Customer:',
//                           style:
//                           pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                       pw.Text(
//                         (data.customer!.isNotEmpty)
//                             ? data.customer![0].code ?? ''
//                             : '',
//                         style: pw.TextStyle(
//                           fontSize: AppConfig.textCaption3Size,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                       pw.SizedBox(height: 3),
//                       pw.Text('${data.customer![0].name}'),
//                       pw.SizedBox(height: 3),
//                       pw.Text('Market: ${data.customer![0].address}'),
//                       pw.SizedBox(height: 3),
//                       pw.Text('TRN: ${data.customer![0].trn}'),
//                     ],
//                   ),
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text(
//                         'Reference: ${data.sales![0].voucherNo ?? 'N/A'}',
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                       ),
//                       pw.Text('Date: ${data.sales![0].inDate}'),
//                       pw.Text('Due Date: ${data.sales![0].inDate}'),
//                     ],
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 10),
//               pw.Divider(color: PdfColors.grey, height: 1, thickness: .5),
//               pw.SizedBox(height: 10),
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text('Collection Type: ${data.collectionType}'),
//                   pw.Text('Bank Name: ${data.bank}'),
//                   pw.Text('Cheque No: ${data.chequeNo}'),
//                   pw.Text('Cheque Date: ${data.chequeDate}'),
//                   pw.Text('Amount: ${data.totalAmount}'),
//                 ],
//               ),
//               pw.SizedBox(height: 10),
//               pw.SizedBox(height: 10),
//               // Use Flexible, Wrap, or other suitable widget to handle table pagination correctly
//               pw.Flexible(
//                 child: pw.Table(
//                   border: pw.TableBorder(
//                     top: pw.BorderSide.none,
//                     bottom: pw.BorderSide.none,
//                     left: pw.BorderSide.none,
//                     right: pw.BorderSide.none,
//                     horizontalInside: pw.BorderSide.none,
//                     verticalInside: pw.BorderSide.none,
//                   ),
//                   columnWidths: {
//                     0: pw.FractionColumnWidth(0.1),
//                     1: pw.FractionColumnWidth(0.3),
//                     2: pw.FractionColumnWidth(0.3),
//                     3: pw.FractionColumnWidth(0.3),
//                   },
//                   children: [
//                     pw.TableRow(
//                       decoration: pw.BoxDecoration(
//                           border: pw.Border.symmetric(
//                               horizontal:
//                               pw.BorderSide(color: PdfColors.grey))),
//                       children: [
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(8.0),
//                           child: pw.Text(
//                             'SI NO',
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: AppConfig.textCaption3Size,
//                             ),
//                           ),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(8.0),
//                           child: pw.Text(
//                             'Reference No',
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: AppConfig.textCaption3Size,
//                             ),
//                           ),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(8.0),
//                           child: pw.Text(
//                             'Type',
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: AppConfig.textCaption3Size,
//                             ),
//                           ),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(8.0),
//                           child: pw.Text(
//                             'Amount',
//                             style: pw.TextStyle(
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: AppConfig.textCaption3Size,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // pw.Divider(color: PdfColors.grey, height: 1, thickness: .5),
//                     ...data.sales!.asMap().entries.map((entry) {
//                       final index = entry.key + 1;
//                       final sale = entry.value;
//                       return pw.TableRow(
//                         children: [
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text(
//                               '$index',
//                               style: pw.TextStyle(
//                                   fontSize: AppConfig.textCaption3Size),
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text(
//                               sale.invoiceNo ?? 'N/A',
//                               style: pw.TextStyle(
//                                   fontSize: AppConfig.textCaption3Size),
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text(
//                               sale.invoiceType ?? 'N/A',
//                               style: pw.TextStyle(
//                                   fontSize: AppConfig.textCaption3Size),
//                             ),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text(
//                               sale.amount?.toString() ?? 'N/A',
//                               style: pw.TextStyle(
//                                   fontSize: AppConfig.textCaption3Size),
//                             ),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text('Van: ${data.vanId}'),
//               pw.SizedBox(width: 20),
//               pw.Text('Salesman: N/A'),
//             ],
//           ),
//         ],
//       ),
//     );
//
//     final output = await getTemporaryDirectory();
//     final file = File('${output.path}/receipt_report.pdf');
//     await file.writeAsBytes(await pdf.save());
//     await OpenFile.open(file.path);
//   } else {
//     throw Exception('Failed to load store details');
//   }
// }
