// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:image/image.dart' as img;
//
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
// import 'package:mobizapp/Models/appstate.dart';
// import 'package:number_to_words/number_to_words.dart';
// import 'package:printing/printing.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:shimmer/shimmer.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:http/http.dart' as http;
//
// import '../Models/invoicedata.dart' as Invoice;
// import '../Models/pdfgenerate.dart';
// import '../Models/productquantirydetails.dart' as Qty;
// import '../Models/salesdata.dart';
// import '../Models/vansaleproduct.dart';
// import '../Utilities/rest_ds.dart';
// import '../confg/appconfig.dart';
// import '../confg/sizeconfig.dart';
// import '../Components/commonwidgets.dart';
//
// class SaleInvoiceScrreen extends StatefulWidget {
//   static const routeName = "/SalreInvoice";
//   const SaleInvoiceScrreen({super.key});
//
//   @override
//   State<SaleInvoiceScrreen> createState() => _SaleInvoiceScrreenState();
// }
//
// class _SaleInvoiceScrreenState extends State<SaleInvoiceScrreen> {
//   final TextEditingController _searchData = TextEditingController();
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _selectedDevice;
//   bool _connected = false;
//   VanSaleProducts products = VanSaleProducts();
//   BlueThermalPrinter printer = BlueThermalPrinter.instance;
//   bool _initDone = false;
//   bool _noData = false;
//
//   List<int> selectedItems = [];
//   List<Map<String, dynamic>> items = [];
//   bool _search = false;
//   int? customerId;
//
//   int? id;
//   String? name;
//
//   Qty.ProductQuantityDetails qunatityData = Qty.ProductQuantityDetails();
//   List<Qty.ProductQuantityDetails> quantity = [];
//   @override
//   void initState() {
//     super.initState();
//     _getProducts();
//     _initPrinter();
//   }
//
//   void _initPrinter() async {
//     bool? isConnected = await printer.isConnected;
//     if (isConnected!) {
//       setState(() {
//         _connected = true;
//       });
//     }
//     _getBluetoothDevices();
//   }
//
//   void _getBluetoothDevices() async {
//     List<BluetoothDevice> devices = await printer.getBondedDevices();
//     BluetoothDevice? defaultDevice;
//     final prefs = await SharedPreferences.getInstance();
//     final savedDeviceAddress = prefs.getString('selected_device_address');
//     for (BluetoothDevice device in devices) {
//       if (device.address == savedDeviceAddress) {
//         defaultDevice = device;
//         break;
//       }
//     }
//     setState(() {
//       _devices = devices;
//       _selectedDevice = defaultDevice;
//     });
//   }
//
//   Future<void> _connect() async {
//     if (_selectedDevice != null) {
//       await printer.connect(_selectedDevice!);
//       setState(() {
//         _connected = true;
//       });
//     }
//   }
//
//   // void _print() async {
//   //   if (_connected) {
//   //     Invoice.InvoiceData invoice = Invoice.InvoiceData();
//   //     printer.printNewLine();
//   //     printer.printCustom(_createPdf(invoice, false).toString(), 3, 1);
//   //     printer.printNewLine();
//   //     printer.paperCut();
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Printer not connected')),
//   //     );
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     if (ModalRoute.of(context)!.settings.arguments != null) {
//       final Map<String, dynamic>? params =
//           ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
//       id = params!['customerId'];
//       name = params['name'];
//     }
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
//         title: const Text(
//           'Sales Invoice',
//           style: TextStyle(color: AppConfig.backgroundColor),
//         ),
//         backgroundColor: AppConfig.colorPrimary,
//         actions: [],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               CommonWidgets.verticalSpace(1),
//               (_initDone && !_noData)
//                   ? SizedBox(
//                       height: SizeConfig.blockSizeVertical * 85,
//                       child: ListView.separated(
//                         separatorBuilder: (BuildContext context, int index) =>
//                             CommonWidgets.verticalSpace(1),
//                         itemCount: products.data!.length,
//                         shrinkWrap: true,
//                         itemBuilder: (context, index) =>
//                             _productsCard(products.data![index], index),
//                       ),
//                     )
//                   : (_noData && _initDone)
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                               CommonWidgets.verticalSpace(3),
//                               const Center(
//                                 child: Text('No Data'),
//                               ),
//                             ])
//                       : Shimmer.fromColors(
//                           baseColor:
//                               AppConfig.buttonDeactiveColor.withOpacity(0.1),
//                           highlightColor: AppConfig.backButtonColor,
//                           child: Center(
//                             child: Column(
//                               children: [
//                                 CommonWidgets.loadingContainers(
//                                     height: SizeConfig.blockSizeVertical * 10,
//                                     width: SizeConfig.blockSizeHorizontal * 90),
//                                 CommonWidgets.loadingContainers(
//                                     height: SizeConfig.blockSizeVertical * 10,
//                                     width: SizeConfig.blockSizeHorizontal * 90),
//                                 CommonWidgets.loadingContainers(
//                                     height: SizeConfig.blockSizeVertical * 10,
//                                     width: SizeConfig.blockSizeHorizontal * 90),
//                                 CommonWidgets.loadingContainers(
//                                     height: SizeConfig.blockSizeVertical * 10,
//                                     width: SizeConfig.blockSizeHorizontal * 90),
//                                 CommonWidgets.loadingContainers(
//                                     height: SizeConfig.blockSizeVertical * 10,
//                                     width: SizeConfig.blockSizeHorizontal * 90),
//                                 CommonWidgets.loadingContainers(
//                                     height: SizeConfig.blockSizeVertical * 10,
//                                     width: SizeConfig.blockSizeHorizontal * 90),
//                               ],
//                             ),
//                           ),
//                         ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _productsCard(Data data, int index) {
//     return Card(
//       elevation: 1,
//       child: Container(
//         width: SizeConfig.blockSizeHorizontal * 90,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.withOpacity(0.3)),
//           color: AppConfig.backgroundColor,
//           borderRadius: const BorderRadius.all(
//             Radius.circular(10),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: ExpansionTile(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             trailing: SizedBox.shrink(),
//             backgroundColor: AppConfig.backgroundColor,
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Tooltip(
//                   message: data.invoiceNo!,
//                   child: SizedBox(
//                     width: SizeConfig.blockSizeHorizontal * 70,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${data.invoiceNo!} | ${DateFormat('dd MMMM yyyy').format(DateTime.parse(data.inDate!))} ${data.inTime}',
//                           style: TextStyle(
//                             fontSize: AppConfig.textCaption3Size,
//                           ),
//                         ),
//                         SizedBox(width: 14,),
//                         Text(
//                           data.status == 0
//                               ? "Cancelled"
//                               : data.status == 1
//                               ? "Confirmed"
//                               : "",
//                           style: TextStyle(
//                             fontSize: AppConfig.textCaption3Size,
//                             fontWeight: AppConfig.headLineWeight,
//                             color: data.status == 0
//                                 ? Colors.red  // Color for Cancelled
//                                 : data.status == 1
//                                 ? Colors.green  // Color for Confirmed
//                                 : Colors.grey,  // Default color for unknown status
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       (data.customer!.isNotEmpty)
//                           ? data.customer![0].code ?? ''
//                           : '',
//                       style: TextStyle(
//                           fontSize: AppConfig.textCaption3Size,
//                           fontWeight: AppConfig.headLineWeight),
//                     ),
//                     Text(' | '),
//                     Text(
//                       (data.customer!.isNotEmpty)
//                           ? data.customer![0].name ?? ''
//                           : '',
//                       style: TextStyle(
//                           fontSize: AppConfig.textCaption3Size,
//                           fontWeight: AppConfig.headLineWeight),
//                     ),
//                   ],
//                 ),
//                 (data.detail!.isNotEmpty)
//                     // ? Text(
//                     //     'Type: ${data.detail![0].productType}',
//                     //     style: TextStyle(
//                     //       fontSize: AppConfig.textCaption3Size,
//                     //     ),
//                     //   )
//
//                     ? Text(
//                         'Total: ${data.total?.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: AppConfig.textCaption3Size,
//                         ),
//                       )
//                     : Text(
//                         'Type:  ',
//                         style: TextStyle(
//                           fontSize: AppConfig.textCaption3Size,
//                         ),
//                       ),
//                 data.discount_type == '0'
//                     ? Text(
//                         'Discount : ${data.discount?.toStringAsFixed(2)}',
//                         style: TextStyle(
//                           fontSize: AppConfig.textCaption3Size,
//                         ),
//                       )
//                     : data.discount_type == '1'
//                         ? Text(
//                             'Discount(%): ${data.discount?.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: AppConfig.textCaption3Size,
//                             ),
//                           )
//                         : SizedBox.shrink(),
//                 Row(
//                   children: [
//                     Text(
//                       'Round off:${double.parse(data.roundOff ?? '').toStringAsFixed(2)}',
//                       style: TextStyle(
//                         fontSize: AppConfig.textCaption3Size,
//                       ),
//                     ),
//                     const Spacer(),
//                     InkWell(
//                       onTap: () => _getInvoiceDataprint(data.id!, false),
//                       child: const Icon(
//                         Icons.print,
//                         color: Colors.blue,
//                         size: 30,
//                       ),
//                     ),
//                     CommonWidgets.horizontalSpace(2),
//                     InkWell(
//                       onTap: () => _getInvoiceData(data.id!, false),
//                       child: const Icon(
//                         Icons.document_scanner,
//                         color: Colors.red,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   'Total Vat: ${(data.totalTax?.toStringAsFixed(2)) ?? ''}',
//                   style: TextStyle(
//                     fontSize: AppConfig.textCaption3Size,
//                   ),
//                 ),
//                 Text(
//                   'Grand Total: ${data.grandTotal?.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontSize: AppConfig.textCaption3Size,
//                   ),
//                 ),
//               ],
//             ),
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CommonWidgets.verticalSpace(1),
//                     Divider(
//                         color: AppConfig.buttonDeactiveColor.withOpacity(0.4)),
//                     for (int i = 0; i < data.detail!.length; i++)
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: SizeConfig.blockSizeHorizontal * 85,
//                             child: Text(
//                               ('${data.detail![i].code ?? ''} | ${data.detail![i].name ?? ''}')
//                                   .toUpperCase(),
//                               style: TextStyle(
//                                   fontSize: AppConfig.textCaption3Size,
//                                   fontWeight: AppConfig.headLineWeight),
//                             ),
//                           ),
//                           SizedBox(
//                             width: SizeConfig.blockSizeHorizontal * 85,
//                             child: Row(
//                               children: [
//                                 Text(
//                                   data.detail![i].productType ?? '',
//                                   style: TextStyle(
//                                     fontSize: AppConfig.textCaption3Size,
//                                   ),
//                                 ),
//                                 const Text(' | '),
//                                 Text(
//                                   data.detail![i].unit ?? '',
//                                   style: TextStyle(
//                                     fontSize: AppConfig.textCaption3Size,
//                                   ),
//                                 ),
//                                 const Text(' | '),
//                                 Text(
//                                   'Qty: ${data.detail![i].quantity}',
//                                   style: TextStyle(
//                                     fontSize: AppConfig.textCaption3Size,
//                                   ),
//                                 ),
//                                 const Text(' | '),
//                                 Text(
//                                   'Rate: ${data.detail![i].mrp}',
//                                   style: TextStyle(
//                                     fontSize: AppConfig.textCaption3Size,
//                                   ),
//                                 ),
//                                 const Text(' | '),
//                                 Text(
//                                   'Amount: ${data.detail![i].taxable?.toStringAsFixed(2)}',
//                                   style: TextStyle(
//                                     fontSize: AppConfig.textCaption3Size,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           CommonWidgets.verticalSpace(1),
//                           (i == data.detail!.length - 1)
//                               ? Container()
//                               : Divider(
//                                   color: AppConfig.buttonDeactiveColor
//                                       .withOpacity(0.4)),
//                         ],
//                       ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _getProducts() async {
//     RestDatasource api = RestDatasource();
//     dynamic resJson = await api.getDetails(
//         '/api/vansale.index?store_id=${AppState().storeId}&van_id=${AppState().vanId}&user_id=${AppState().userId}',
//         AppState().token); //
//
//     if (resJson['data'] != null) {
//       products = VanSaleProducts.fromJson(resJson);
//       setState(() {
//         _initDone = true;
//       });
//     } else {
//       setState(() {
//         _noData = true;
//         _initDone = true;
//       });
//     }
//   }
//
//   void _print(Invoice.InvoiceData invoice, bool isPrint) async {
//     if (_connected) {
//       String cusAddress= invoice.data!.customer![0].address ?? 'N/A';
//       String companyName = invoice.data!.store![0].name ?? 'N/A';
//       String companyAddress = invoice.data!.store![0].address ?? 'N/A';
//       String companyMail = invoice.data!.store![0].email??'N/A';
//       String companyTRN = "TRN: ${invoice.data!.store![0].trn ?? 'N/A'}";
//       String billtype = "Tax Invoice";
//       String customerName = "${invoice.data!.customer![0].name}";
//       List<String> nameWords = customerName.split(' ');
//       String firstLine = customerName;
//       String secondLine = "";
//       if (nameWords.length > 7) {
//         firstLine = nameWords.sublist(0, 7).join(' ');
//         secondLine = nameWords.sublist(7).join(' ');
//       }
//       String customerEmail = invoice.data!.customer![0].email ?? 'N/A';
//       String customerContact =
//           invoice.data!.customer![0].contactNumber ?? 'N/A';
//       String customerTRN = invoice.data!.customer![0].trn ?? '';
//       String invoiceNumber = invoice.data!.invoiceNo ?? 'N/A';
//       String invoiceDate = DateFormat('dd MMMM yyyy')
//           .format(DateTime.parse(invoice.data!.inDate!));
//       String dueDate = DateFormat('dd MMMM yyyy')
//           .format(DateTime.parse(invoice.data!.inDate!));
//       String Total = invoice.data!.total?.toStringAsFixed(2)??'0.00';
//       String tax = invoice.data!.totalTax?.toStringAsFixed(2) ?? '0.00';
//       String grandTotal =
//           invoice.data!.grandTotal?.toStringAsFixed(2) ?? '0.00';
//       final remarks = invoice.data?.remarks;
//       String Discount;
//       if (invoice.data!.discount != null &&
//           double.tryParse(invoice.data!.discount!.toString()) != null &&
//           double.parse(invoice.data!.discount!.toString()) > 0) {
//
//         Discount = "Discount: ${double.parse(invoice.data!.discount!.toString()).toStringAsFixed(2)}";
//       } else {
//         Discount = '';
//       }
//       String amountInWords =
//           "Amount in Words: AED ${NumberToWord().convert('en-in', invoice.data!.grandTotal?.toInt() ?? 0).toUpperCase()} ONLY";
//       String van = invoice.data!.van![0].name ?? 'N/A';
//       String salesman = invoice.data!.user![0].name ?? 'N/A';
//
//       void printAlignedText(String leftText, String rightText) {
//         const int maxLineLength =
//             68; // Adjust the maximum line length as per your printer's character limit
//         int leftTextLength = leftText.length;
//         int rightTextLength = rightText.length;
//
//         // Calculate padding to ensure rightText is right-aligned
//         int spaceLength = maxLineLength - (leftTextLength + rightTextLength);
//         String spaces = ' ' * spaceLength;
//
//         printer.printCustom(
//             '$leftText$spaces$rightText', 1, 0); // Print with left-aligned text
//       }
//
//       String logoUrl =
//           'http://68.183.92.8:3697/uploads/store/${invoice.data!.store![0].logo}';
//       if (logoUrl.isNotEmpty) {
//         final response = await http.get(Uri.parse(logoUrl));
//         if (response.statusCode == 200) {
//           Uint8List imageBytes = response.bodyBytes;
//
//           // Decode image and convert to monochrome bitmap if needed
//           img.Image originalImage = img.decodeImage(imageBytes)!;
//           img.Image monoLogo = img.grayscale(originalImage);
//
//           // Encode the image to the required format (e.g., PNG)
//           Uint8List logoBytes = Uint8List.fromList(img.encodePng(monoLogo));
//
//           // Print the logo image
//           printer.printImageBytes(logoBytes);
//         } else {
//           print('Failed to load image: ${response.statusCode}');
//         }
//       }
//       // Print company details
//       printer.printNewLine();
//       printer.printCustom(companyName, 3, 1); // Centered
//       printer.printCustom(companyAddress, 1, 1); // Centered
//       printer.printCustom(companyMail, 1, 1);
//       printer.printCustom(companyTRN, 1, 1); // Centered
//       printer.printCustom(billtype, 1, 1); // Centered
//       printer.printNewLine();
//
//       printer.printCustom("-" * 72, 1, 1); // Centered
//       printAlignedText("Invoice No: ${invoiceNumber}","Date: ${invoiceDate}");
//       printAlignedText("","${remarks != null? remarks:''}");
//       // printer.printCustom("Invoice No: ${invoiceNumber} | Date: ${invoiceDate}", 1, 1);
//       printer.printNewLine();
//       // Print customer details
//       printAlignedText("Customer: $firstLine","");
//
//       if (secondLine.isNotEmpty) {
//         printAlignedText("         $secondLine", "");
//       }
//       printAlignedText("$cusAddress", " ");
//       // printAlignedText("Email: $customerEmail", "");
//       printAlignedText("Contact No: $customerContact", "");
//       printAlignedText("TRN: $customerTRN", " ");
//       printer.printNewLine();
//
//       // Print horizontal line
//       printer.printCustom("-" * 70, 1, 1); // Centered
//
//       // Define column widths for table
//       const int columnWidth1 = 5; // S.No
//       const int columnWidth2 = 22; // Product Description
//       const int columnWidth3 = 5; // Unit
//       const int columnWidth4 = 4; // Qty
//       const int columnWidth5 = 7; // Type
//       const int columnWidth6 = 8; // Rate
//       const int columnWidth7 = 8; // Total
//       // const int columnWidth8 = 4; // Tax
//       const int columnWidth9 = 6; // Amount
//
//       // Print table headers
//       String headers = "${'S.No'.padRight(columnWidth1)}"
//           " ${'Product'.padRight(columnWidth2)}"
//           " ${'Unit'.padRight(columnWidth3)}"
//           "${'Qty'.padRight(columnWidth4)}"
//           "${'Type'.padRight(columnWidth5)}"
//           "${'Rate'.padRight(columnWidth6)}"
//           "${'Amount'.padRight(columnWidth7)}"
//           // "${'Vat'.padRight(columnWidth8)}"
//           " ${'Total'.padLeft(columnWidth9)}";
//       printer.printCustom(headers, 1, 0); // Left aligned
//
//       // Function to split text into lines of a given width
//       List<String> splitText(String text, int width) {
//         List<String> lines = [];
//         while (text.length > width) {
//           lines.add(text.substring(0, width));
//           text = text.substring(width);
//         }
//         lines.add(text); // Add remaining part
//         return lines;
//       }
//
//       // Print all product details
//       for (int i = 0; i < invoice.data!.detail!.length; i++) {
//         String productDescription = invoice.data!.detail![i].name ?? 'N/A';
//         String productUnit = invoice.data!.detail![i].unit ?? 'N/A';
//         String productQty = invoice.data!.detail![i].quantity?.toString() ?? '0';
//         String productType= invoice.data!.detail![i].productType?.toString()??'0';
//         String productRate = invoice.data!.detail![i].mrp?.toStringAsFixed(2) ?? '0.00';
//         String productTotal = invoice.data!.detail![i].taxable?.toStringAsFixed(2) ?? '0.00';
//         // String productTax = tax.toString();
//         String productAmount =invoice.data!.detail![i].amount?.toStringAsFixed(2)??'0.00';
//             // (invoice.data!.detail![i].mrp! * invoice.data!.detail![i].quantity!)
//             //     .toStringAsFixed(2);
//
//         // Split the product description if it exceeds the column width
//         List<String> descriptionLines =
//             splitText(productDescription, columnWidth2);
//
//         for (int j = 0; j < descriptionLines.length; j++) {
//           String line;
//           if (j == 0) {
//             // For the first line, include all columns
//             line = "${(i + 1).toString().padRight(columnWidth1)}"
//                 "${descriptionLines[j].padRight(columnWidth2)}"
//                 "  ${productUnit.padRight(columnWidth3)}"
//                 "${productQty.padRight(columnWidth4)}"
//                 "${productType.padRight(columnWidth5)}"
//                 "${productRate.padRight(columnWidth6)}"
//                 "${productTotal.padRight(columnWidth7)}"
//                 // "${productTax.padRight(columnWidth8)}"
//                 "${productAmount.padLeft(columnWidth9)}";
//           } else {
//             // For subsequent lines, only include the description, leaving other columns blank
//             line = "${''.padRight(columnWidth1)}"
//                 "${descriptionLines[j].padRight(columnWidth2)}"
//                 "${''.padRight(columnWidth3)}"
//                 "${''.padRight(columnWidth4)}"
//                 "${''.padRight(columnWidth5)}"
//                 "${''.padRight(columnWidth6)}"
//                 "${''.padRight(columnWidth7)}";
//                 // "${''.padRight(columnWidth8)}";
//                 "${''.padRight(columnWidth9)}";
//           }
//           printer.printCustom(line, 1, 0); // Left aligned
//         }
//       }
//       printer.printCustom("-" * 70, 1, 1); // Centered
//
//       // Print totals
//       if (Discount.isNotEmpty) {
//         print(Discount);
//         printAlignedText("Van: $van", "$Discount");
//       } else {
//         printAlignedText("Van: $van", ""); // Skip printing Total
//       }
//       printAlignedText("Salesman: $salesman", "Total: $Total");
//       printer.printCustom("Vat: $tax", 1, 2);
//       printer.printCustom("Grand Total: $grandTotal", 1, 2); // Right aligned
//       printer.printNewLine();
//       printer.printCustom(amountInWords, 1, 0); // Centered
//
//       // Cut the paper
//       printer.paperCut();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Printer not connected')),
//       );
//     }
//   }
//
//   Future<String> _getImageData(String url) async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         return response.bodyBytes.toString();
//       } else {
//         print("Failed to load image: ${response.statusCode}");
//         return '';
//       }
//     } catch (e) {
//       print("Error fetching image: $e");
//       return '';
//     }
//   }
//
//   Future<void> _createPdf(Invoice.InvoiceData invoice, bool isPrint) async {
//     PdfDocument document = PdfDocument();
//     final page = document.pages.add();
//     final Size pageSize = page.getClientSize();
//
//     // Load the image.
//
//     final Uint8List imageData = await _readImageData(
//         invoice.data!.store![0].logo); //invoice.data!.store![0].logo
//     print(invoice.data!.store![0].logo);
//     if (imageData.isNotEmpty) {
//       final PdfBitmap image = PdfBitmap(imageData);
//
//       // Draw the image.
//       final Rect imageRect = Rect.fromCenter(
//         center: Offset(pageSize.width / 2, 50),
//         width: pageSize.width * 0.2, // Adjust width as per your requirement
//         height: pageSize.height * 0.1, // Adjust height as per your requirement
//       );
//       page.graphics.drawImage(image, imageRect);
//     }
//
//     //content
//     // page.graphics.drawString(
//     //     'TAX INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 30));
//
//     //heading
//     final String head = '${invoice.data!.store![0].name}';
//     // Define the text and font
//     final double pageWidth = page.getClientSize().width;
//
//     final PdfFont headfont = PdfStandardFont(
//       PdfFontFamily.helvetica,
//       25,
//     );
//     final Size headtextSize = headfont.measureString(head);
//
//     final double headxPosition = (pageWidth - headtextSize.width) / 2.0;
//     final double headyPosition = 90;
//     page.graphics.drawString(
//       head,
//       headfont,
//       bounds: Rect.fromLTWH(headxPosition, headyPosition, headtextSize.width,
//           headtextSize.height),
//     );
//
//     final String addresss = '${invoice.data!.store![0].address ?? 'N/A'}';
//     final PdfFont addressfont = PdfStandardFont(PdfFontFamily.helvetica, 12);
//
//     final Size addresstextSize = addressfont.measureString(addresss);
//     final double addressxPosition = (pageWidth - addresstextSize.width) / 2.0;
//     final double addressyPosition = 120;
//
//     page.graphics.drawString(
//       addresss,
//       addressfont,
//       bounds: Rect.fromLTWH(addressxPosition, addressyPosition,
//           addresstextSize.width, addresstextSize.height),
//     );
//
//     final String email = '${invoice.data!.store![0].email ?? 'N/A'}';
//     final PdfFont emailfont = PdfStandardFont(PdfFontFamily.helvetica, 12);
//     final Size emailtextSize= emailfont.measureString(email);
//     final double emailxPosition = (pageWidth - emailtextSize.width) / 2.0;
//     final double emailyposition = 135;
//     page.graphics.drawString(
//       email,
//       emailfont,
//       bounds: Rect.fromLTWH(emailxPosition, emailyposition,
//           emailtextSize.width, emailtextSize.height),
//     );
//
//     final String trn = 'TRN:${invoice.data!.store![0].trn ?? 'N/A'}';
//     final PdfFont trnfont = PdfStandardFont(PdfFontFamily.helvetica, 12);
//
//     final Size trntextSize = trnfont.measureString(trn);
//     final double trnxPosition = (pageWidth - trntextSize.width) / 2.1;
//     final double trnyPosition = 150;
//
//     page.graphics.drawString(
//       trn,
//       trnfont,
//       bounds: Rect.fromLTWH(
//           trnxPosition, trnyPosition, trntextSize.width, trntextSize.height),
//     );
//
//     final String text = 'TAX INVOICE';
//
//     final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 15);
//
//     // Calculate the width of the text
//     final Size textSize = font.measureString(text);
//
//     // Calculate the center position for the text
//     final double xPosition = (pageWidth - textSize.width) / 2;
//     final double yPosition =
//         165; // Adjust this as needed for vertical positioning
//
//     // Draw the centered text
//     page.graphics.drawString(
//       text,
//       font,
//       bounds:
//           Rect.fromLTWH(xPosition, yPosition, textSize.width, textSize.height),
//     );
//
//     // Draw a line below the text
//     final remarks = invoice.data?.remarks;
//     final double lineYPosition =
//         yPosition + textSize.height + 10; // Adjust the gap as needed
//     page.graphics.drawLine(
//       PdfPen(PdfColor(0, 0, 0)), // Black pen
//       Offset(0, lineYPosition),
//       Offset(pageWidth, lineYPosition),
//     );
//
//     String address = '''
//   Customer: ${invoice.data!.customer![0].code} | ${invoice.data!.customer![0].name}
//   Email: ${invoice.data!.customer![0].email}
//   Contact No:  ${invoice.data!.customer![0].contactNumber}
//   TRN:  ${invoice.data!.customer![0].trn ?? ''}
//   ''';
//
//     String invoiceDetails = '''
//   Invoice No: ${invoice.data!.invoiceNo!}
//   Date: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(invoice.data!.inDate!))}
//   Due Date: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(invoice.data!.inDate!))}
//   ${remarks != null? remarks:''}
//   ''';
//
//     page.graphics.drawString(
//       address,
//       PdfStandardFont(PdfFontFamily.helvetica, 12),
//       bounds: Rect.fromLTWH(0, 200, pageSize.width / 0, 100),
//     );
//
//     page.graphics.drawString(
//       invoiceDetails,
//       PdfStandardFont(PdfFontFamily.helvetica, 12),
//       bounds: Rect.fromLTWH(pageSize.width / 2, 200, pageSize.width / 2, 100),
//       format: PdfStringFormat(
//         alignment: PdfTextAlignment.right,
//       ),
//     );
//
//     // Draw a horizontal line.
//     page.graphics.drawLine(
//       PdfPen(PdfColor(0, 0, 0)),
//       const Offset(0, 290),
//       Offset(pageSize.width, 290),
//     );
//
//     // Create a table without grid lines.
//     final PdfGrid grid = PdfGrid();
//     grid.columns.add(count: 9);
//     // Set column widths.
//     grid.columns[0].width = 30; // Sl.No
//     grid.columns[1].width = 180; // Product
//     grid.columns[2].width = 40; // Unit
//     grid.columns[3].width = 40; // Rate
//     grid.columns[4].width = 50; // Qty
//     grid.columns[5].width = 50;
//     grid.columns[6].width = 40;
//     grid.columns[7].width = 50; // Vat
//     grid.columns[8].width = 100;
//
//     // Add headers.
//     final PdfGridRow headerRow = grid.headers.add(1)[0];
//     headerRow.cells[0].value = 'Sl.No';
//     headerRow.cells[1].value = 'Product';
//     headerRow.cells[2].value = 'Unit';
//     headerRow.cells[3].value = 'Qty';
//     headerRow.cells[4].value = 'Type';
//     headerRow.cells[5].value = 'Rate';
//     headerRow.cells[6].value = 'Total';
//     headerRow.cells[7].value = 'Vat';
//     headerRow.cells[8].value = 'Amount';
//
//     for (int k = 0; k < invoice.data!.detail!.length; k++) {
//       final PdfGridRow row = grid.rows.add();
//       row.cells[0].value = '${k + 1}';
//       row.cells[1].value = '${invoice.data!.detail![k].name}';
//       row.cells[2].value = '${invoice.data!.detail![k].unit}';
//       row.cells[3].value = '${invoice.data!.detail![k].quantity}';
//       row.cells[4].value =
//       (invoice.data!.detail![k].productType!.toLowerCase() == "foc" ||
//           invoice.data!.detail![k].productType!.toLowerCase() == "FOC" ||
//           invoice.data!.detail![k].productType!.toLowerCase() == "Change")
//           ? 'Normal' : 'Normal';
//       row.cells[5].value =
//       '${invoice.data!.detail![k].mrp?.toStringAsFixed(2)}';
//       row.cells[6].value =
//       '${invoice.data!.detail![k].taxable?.toStringAsFixed(2)}';
//       row.cells[7].value =
//           '${invoice.data!.detail![k].taxAmt?.toStringAsFixed(2)}';
//       row.cells[8].value =
//           '${invoice.data!.detail![k].amount?.toStringAsFixed(2)}';
//     }
//
//     // Define no border style
//     final PdfBorders noBorder = PdfBorders(
//       left: PdfPen(PdfColor(255, 255, 255), width: 0),
//       top: PdfPen(PdfColor(255, 255, 255), width: 0),
//       right: PdfPen(PdfColor(255, 255, 255), width: 0),
//       bottom: PdfPen(PdfColor(255, 255, 255), width: 0),
//     );
//
//     // Remove borders from all header cells
//     for (int j = 0; j < grid.headers.count; j++) {
//       for (int k = 0; k < grid.headers[j].cells.count; k++) {
//         grid.headers[j].cells[k].style.borders = noBorder;
//       }
//     }
//
//     // Remove borders from all body cells
//     for (int i = 0; i < grid.rows.count; i++) {
//       for (int j = 0; j < grid.columns.count; j++) {
//         grid.rows[i].cells[j].style.borders = noBorder;
//       }
//     }
//
//     // Draw the table.
//     final PdfLayoutResult result = grid.draw(
//       page: page,
//       bounds: Rect.fromLTWH(0, 300, pageSize.width, pageSize.height - 180),
//     )!;
//
//     //   // Calculate the Y position for the line after the first row
//     // final double firstRowHeight = grid.headers[0].height + grid.rows[0].height;
//
//     // // Draw a line after the first row of the grid
//     // page.graphics.drawLine(
//     //   PdfPen(PdfColor(0, 0, 0), width: 1),
//     //   Offset(0, result.bounds.top + firstRowHeight),
//     //   Offset(pageSize.width, result.bounds.top + firstRowHeight),
//     // );
//     // Check if the table extends to the next page
//     PdfPage lastPage = result.page;
//     double tableBottom = result.bounds.bottom;
//
//     if (tableBottom >= pageSize.height) {
//       // Add a new page
//       lastPage = document.pages.add();
//       tableBottom = 0;
//     }
//
//     // Draw a horizontal line after the table.
//     lastPage.graphics.drawLine(
//       PdfPen(PdfColor(0, 0, 0)),
//       Offset(0, tableBottom + 15),
//       Offset(pageSize.width, tableBottom + 15),
//     );
//
//     // Draw invoice details at the bottom right.
//
//     // ${num.parse(invoice.data!.roundOff.toString()) != 0 ? 'Discount: ${invoice.data!.discount?.toStringAsFixed(2)}' : '\t'}
//
//     String bottomInvoiceDetails = '''
//     ${invoice.data!.discount != null && invoice.data!.discount! > 0 ? 'Discount: ${invoice.data!.discount!.toStringAsFixed(2)}' : '\t'}
//   Total: ${invoice.data!.total ?? ''}
//   Vat: ${invoice.data!.totalTax?.toStringAsFixed(2)}
//   ${'${invoice.data!.roundOff}' != 0 ? 'Round off:${double.parse(invoice.data!.roundOff ?? '').toStringAsFixed(2)}\nGrand Total: ${invoice.data!.grandTotal?.toStringAsFixed(2)}' : 'Grand Total: ${invoice.data!.grandTotal}'}
//
//
//   ''';
//     print('invoice.data!.discounted_amount');
//     print(invoice.data!.discounted_amount);
//
//     lastPage.graphics.drawString(
//       bottomInvoiceDetails,
//       PdfStandardFont(PdfFontFamily.helvetica, 12),
//       bounds: Rect.fromLTWH(
//         pageSize.width / 2,
//         tableBottom + 20,
//         pageSize.width / 2,
//         100,
//       ),
//       format: PdfStringFormat(
//         alignment: PdfTextAlignment.right,
//       ),
//     );
//
// // in word
//     String textData =
//         'Amount in Words: AED ${NumberToWord().convert('en-in', invoice.data!.grandTotal!.toInt()).toUpperCase()} ONLY';
//
// // Adjust the vertical position for the van details
//     double vanDetailsTop = tableBottom + 20 + 100 + 10;
//
// // Construct the van details string.
//     String bottomVanDetails = '''
// Van: ${invoice.data!.van![0].name}
// Salesman: ${invoice.data!.user![0].name}
// ''';
//
// // Draw the word text above the van details
//     lastPage.graphics.drawString(
//       textData,
//       PdfStandardFont(PdfFontFamily.helvetica, 12),
//       bounds: Rect.fromLTWH(
//         0,
//         vanDetailsTop -
//             17, // Adjust vertical position to be above the van details
//         pageSize.width,
//         100,
//       ),
//       format: PdfStringFormat(
//         alignment: PdfTextAlignment.left,
//       ),
//     );
// // Draw van details at the bottom left.
//     lastPage.graphics.drawString(
//       bottomVanDetails,
//       PdfStandardFont(PdfFontFamily.helvetica, 12),
//       bounds: Rect.fromLTWH(
//         0,
//         vanDetailsTop,
//         pageSize.width / 2,
//         100,
//       ),
//       format: PdfStringFormat(
//         alignment: PdfTextAlignment.left,
//       ),
//     );
//     List<int> bytes = await document.save();
//     document.dispose();
//
//     String file = await saveAndLaunchFile(
//         bytes, '${invoice.data!.invoiceNo!}.pdf', isPrint);
//   }
//
//   // Future<String> _getImageData(String imageUrl) async {
//   //   http.Response response = await http.get(Uri.parse(imageUrl));
//   //   Uint8List bytes = response.bodyBytes;
//   //   return base64Encode(bytes);
//   // }
//
//   Future<Uint8List> _readImageData(String? image) async {
//     // print(image);
//     // print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
//     try {
//       final response = await http
//           .get(Uri.parse('${RestDatasource().Image_URL}/uploads/store/$image'));
//
//       print('Response Data $response');
//
//       if (response.statusCode == 200) {
//         return response.bodyBytes;
//       } else {
//         throw Exception('Failed to load image');
//       }
//     } catch (e) {
//       // Log the error and return an empty Uint8List
//       print('Error loading image: $e');
//       return Uint8List(0);
//     }
//   }
//
//   Future<void> _getInvoiceData(int id, bool isPrint) async {
//     Invoice.InvoiceData invoice = Invoice.InvoiceData();
//     RestDatasource api = RestDatasource();
//     dynamic response =
//         await api.getDetails('/api/get_sales_invoice?id=$id', AppState().token);
//     if (response['data'] != null) {
//       print("DDDDDD${id}");
//       invoice = Invoice.InvoiceData.fromJson(response);
//       _createPdf(invoice, isPrint);
//     }
//     // if (_selectedDevice == null) {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     SnackBar(content: Text('Default device not found')),
//     //   );
//     //   return;
//     // }
//     // if (!_connected) {
//     //   await _connect();
//     // }
//     // _print(invoice, isPrint);
//   }
//
//   Future<void> _getInvoiceDataprint(int id, bool isPrint) async {
//     Invoice.InvoiceData invoice = Invoice.InvoiceData();
//     RestDatasource api = RestDatasource();
//     dynamic response =
//         await api.getDetails('/api/get_sales_invoice?id=$id', AppState().token);
//
//     if (response['data'] != null) {
//       invoice = Invoice.InvoiceData.fromJson(response);
//       // _createPdf(invoice, isPrint);
//     }
//     if (_selectedDevice == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Default device not found')),
//       );
//       return;
//     }
//     if (!_connected) {
//       await _connect();
//     }
//     _print(invoice, isPrint);
//   }
// // void _connectAndPrint() async {
// //   if (_selectedDevice == null) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('Default device not found')),
// //     );
// //     return;
// //   }
// //   if (!_connected) {
// //     await _connect();
// //   }
// //   _print();
// // }
// }
