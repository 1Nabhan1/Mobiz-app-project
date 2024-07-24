import 'dart:convert';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

import '../Models/invoicedata.dart' as Invoice;
import '../Models/pdfgenerate.dart';
import '../Models/productquantirydetails.dart' as Qty;
import '../Models/salesdata.dart';
import '../Models/vansaleproduct.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import '../Components/commonwidgets.dart';

class SaleInvoiceScrreen extends StatefulWidget {
  static const routeName = "/SalreInvoice";
  const SaleInvoiceScrreen({super.key});

  @override
  State<SaleInvoiceScrreen> createState() => _SaleInvoiceScrreenState();
}

class _SaleInvoiceScrreenState extends State<SaleInvoiceScrreen> {
  final TextEditingController _searchData = TextEditingController();
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _connected = false;
  VanSaleProducts products = VanSaleProducts();
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  bool _initDone = false;
  bool _noData = false;
  final String _defaultDeviceAddress = "00:13:7B:84:E9:89";
  List<int> selectedItems = [];
  List<Map<String, dynamic>> items = [];
  bool _search = false;
  int? customerId;

  int? id;
  String? name;

  Qty.ProductQuantityDetails qunatityData = Qty.ProductQuantityDetails();
  List<Qty.ProductQuantityDetails> quantity = [];
  @override
  void initState() {
    super.initState();
    _getProducts();
    _initPrinter();
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

  void _getBluetoothDevices() async {
    List<BluetoothDevice> devices = await printer.getBondedDevices();
    BluetoothDevice? defaultDevice;

    for (BluetoothDevice device in devices) {
      if (device.address == _defaultDeviceAddress) {
        defaultDevice = device;
        break;
      }
    }
    setState(() {
      _devices = devices;
      _selectedDevice = defaultDevice;
    });
  }

  Future<void> _connect() async {
    if (_selectedDevice != null) {
      await printer.connect(_selectedDevice!);
      setState(() {
        _connected = true;
      });
    }
  }

  // void _print() async {
  //   if (_connected) {
  //     Invoice.InvoiceData invoice = Invoice.InvoiceData();
  //     printer.printNewLine();
  //     printer.printCustom(_createPdf(invoice, false).toString(), 3, 1);
  //     printer.printNewLine();
  //     printer.paperCut();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Printer not connected')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['customerId'];
      name = params['name'];
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        title: const Text(
          'Sales Invoice',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
        backgroundColor: AppConfig.colorPrimary,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonWidgets.verticalSpace(1),
              (_initDone && !_noData)
                  ? SizedBox(
                      height: SizeConfig.blockSizeVertical * 85,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            CommonWidgets.verticalSpace(1),
                        itemCount: products.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            _productsCard(products.data![index], index),
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
                            ])
                      : Shimmer.fromColors(
                          baseColor:
                              AppConfig.buttonDeactiveColor.withOpacity(0.1),
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
        ),
      ),
    );
  }

  Widget _productsCard(Data data, int index) {
    return Card(
      elevation: 1,
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 90,
        decoration: BoxDecoration(
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
            trailing: SizedBox.shrink(),
            backgroundColor: AppConfig.backgroundColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: data.invoiceNo!,
                  child: SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 70,
                    child: Text(
                      '${data.invoiceNo!} | ${DateFormat('dd MMMM yyyy').format(DateTime.parse(data.inDate!))} ${data.inTime}',
                      style: TextStyle(
                        fontSize: AppConfig.textCaption3Size,
                      ),
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
                      (data.customer!.isNotEmpty)
                          ? data.customer![0].name ?? ''
                          : '',
                      style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                          fontWeight: AppConfig.headLineWeight),
                    ),
                  ],
                ),
                (data.detail!.isNotEmpty)
                    // ? Text(
                    //     'Type: ${data.detail![0].productType}',
                    //     style: TextStyle(
                    //       fontSize: AppConfig.textCaption3Size,
                    //     ),
                    //   )

                    ? Text(
                        'Total: ${data.total}',
                        style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                        ),
                      )
                    : Text(
                        'Type:  ',
                        style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                        ),
                      ),
                Text(
                  'Discount(%): ${data.discount}',
                  style: TextStyle(
                    fontSize: AppConfig.textCaption3Size,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 90,
                  child: Row(
                    children: [
                      Text(
                        'Round Off: ${data.roundOff ?? ''}',
                        style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => _getInvoiceData(data.id!, false),
                        child: const Icon(
                          Icons.print,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      CommonWidgets.horizontalSpace(2),
                      InkWell(
                        onTap: () => _getInvoiceData(data.id!, false),
                        child: const Icon(
                          Icons.document_scanner,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Total Tax: ${data.totalTax ?? ''}',
                  style: TextStyle(
                    fontSize: AppConfig.textCaption3Size,
                  ),
                ),
                Text(
                  'Grand Total: ${data.grandTotal}',
                  style: TextStyle(
                    fontSize: AppConfig.textCaption3Size,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets.verticalSpace(1),
                    Divider(
                        color: AppConfig.buttonDeactiveColor.withOpacity(0.4)),
                    for (int i = 0; i < data.detail!.length; i++)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 85,
                            child: Text(
                              ('${data.detail![i].code ?? ''} | ${data.detail![i].name ?? ''}')
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: AppConfig.textCaption3Size,
                                  fontWeight: AppConfig.headLineWeight),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 85,
                            child: Row(
                              children: [
                                Text(
                                  data.detail![i].productType ?? '',
                                  style: TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                ),
                                const Text(' | '),
                                Text(
                                  data.detail![i].unit ?? '',
                                  style: TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                ),
                                const Text(' | '),
                                Text(
                                  'Qty: ${data.detail![i].quantity}',
                                  style: TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                ),
                                const Text(' | '),
                                Text(
                                  'Rate: ${data.detail![i].mrp}',
                                  style: TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                ),
                                const Text(' | '),
                                Text(
                                  'Amount: ${data.detail![i].amount?.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: AppConfig.textCaption3Size,
                                  ),
                                )
                              ],
                            ),
                          ),
                          CommonWidgets.verticalSpace(1),
                          (i == data.detail!.length - 1)
                              ? Container()
                              : Divider(
                                  color: AppConfig.buttonDeactiveColor
                                      .withOpacity(0.4)),
                        ],
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getProducts() async {
    RestDatasource api = RestDatasource();
    dynamic resJson = await api.getDetails(
        '/api/vansale.index?store_id=${AppState().storeId}&van_id=${AppState().vanId}',
        AppState().token); //

    if (resJson['data'] != null) {
      products = VanSaleProducts.fromJson(resJson);
      setState(() {
        _initDone = true;
      });
    } else {
      setState(() {
        _noData = true;
        _initDone = true;
      });
    }
  }

  void _print(Invoice.InvoiceData invoice, bool isPrint) async {
    if (_connected) {
      // Example data
      String imageUrl =
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRQ0HqT9dk3DeLLbBHebie1wSK7HYWCudOCw&s";
      String imageData = await _getImageData(imageUrl);
      printer.printImage(imageData);
      String name = "${invoice.data!.store![0].name}";
      String phoneNumber = "${invoice.data!.store![0].contactNumber}";
      String address = "${invoice.data!.store![0].address}";

      // Print image (replace with your image printing logic)
      // printer.printImage(imagePath);

      // Print name
      printer.printNewLine();
      printer.printCustom("Name: $name", 3, 1);

      // Print phone number
      printer.printNewLine();
      printer.printCustom("Phone Number: $phoneNumber", 3, 1);

      // Print gender
      printer.printNewLine();
      printer.printCustom("address: $address", 3, 1);

      // Cut the paper
      printer.paperCut();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Printer not connected')),
      );
    }
  }

  Future<void> _createPdf(Invoice.InvoiceData invoice, bool isPrint) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Load the image.

    final Uint8List imageData = await _readImageData(
        invoice.data!.store![0].logo); //invoice.data!.store![0].logo
    print(invoice.data!.store![0].logo);
    if (imageData.isNotEmpty) {
      final PdfBitmap image = PdfBitmap(imageData);

      // Draw the image.
      final Rect imageRect = Rect.fromCenter(
        center: Offset(pageSize.width / 2, 50),
        width: pageSize.width * 0.2, // Adjust width as per your requirement
        height: pageSize.height * 0.1, // Adjust height as per your requirement
      );
      page.graphics.drawImage(image, imageRect);
    }

    //content
    // page.graphics.drawString(
    //     'TAX INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 30));

    //heading
    final String head = '${invoice.data!.store![0].name}';
    // Define the text and font
    final double pageWidth = page.getClientSize().width;

    final PdfFont headfont = PdfStandardFont(
      PdfFontFamily.helvetica,
      25,
    );
    final Size headtextSize = headfont.measureString(head);

    final double headxPosition = (pageWidth - headtextSize.width) / 2.0;
    final double headyPosition = 90;
    page.graphics.drawString(
      head,
      headfont,
      bounds: Rect.fromLTWH(headxPosition, headyPosition, headtextSize.width,
          headtextSize.height),
    );

    final String addresss = '${invoice.data!.store![0].address ?? 'null'}';
    final PdfFont addressfont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    final Size addresstextSize = addressfont.measureString(addresss);
    final double addressxPosition = (pageWidth - addresstextSize.width) / 2.0;
    final double addressyPosition = 120;

    page.graphics.drawString(
      addresss,
      addressfont,
      bounds: Rect.fromLTWH(addressxPosition, addressyPosition,
          addresstextSize.width, addresstextSize.height),
    );

    final String trn = 'TRN:${invoice.data!.customer![0].trn ?? '  null'}';
    final PdfFont trnfont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    final Size trntextSize = trnfont.measureString(trn);
    final double trnxPosition = (pageWidth - trntextSize.width) / 2.1;
    final double trnyPosition = 135;

    page.graphics.drawString(
      trn,
      trnfont,
      bounds: Rect.fromLTWH(
          trnxPosition, trnyPosition, trntextSize.width, trntextSize.height),
    );

    final String text = 'TAX INVOICE';

    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 15);

    // Calculate the width of the text
    final Size textSize = font.measureString(text);

    // Calculate the center position for the text
    final double xPosition = (pageWidth - textSize.width) / 2;
    final double yPosition =
        150; // Adjust this as needed for vertical positioning

    // Draw the centered text
    page.graphics.drawString(
      text,
      font,
      bounds:
          Rect.fromLTWH(xPosition, yPosition, textSize.width, textSize.height),
    );

    // Draw a line below the text
    final double lineYPosition =
        yPosition + textSize.height + 10; // Adjust the gap as needed
    page.graphics.drawLine(
      PdfPen(PdfColor(0, 0, 0)), // Black pen
      Offset(0, lineYPosition),
      Offset(pageWidth, lineYPosition),
    );

    String address = '''
  Customer: ${invoice.data!.customer![0].code} | ${invoice.data!.customer![0].name}
  Email: ${invoice.data!.customer![0].email}
  Contact No:  ${invoice.data!.customer![0].contactNumber}
  TRN:  ${invoice.data!.customer![0].trn ?? ''}
  ''';

    String invoiceDetails = '''
  Invoice No: ${invoice.data!.invoiceNo!}
  Date: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(invoice.data!.inDate!))}
  Due Date: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(invoice.data!.inDate!))}
  ''';

    page.graphics.drawString(
      address,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(0, 200, pageSize.width / 2, 100),
    );

    page.graphics.drawString(
      invoiceDetails,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(pageSize.width / 2, 200, pageSize.width / 2, 100),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.right,
      ),
    );

    // Draw a horizontal line.
    page.graphics.drawLine(
      PdfPen(PdfColor(0, 0, 0)),
      const Offset(0, 290),
      Offset(pageSize.width, 290),
    );

    // Create a table without grid lines.
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 8);
    // Set column widths.
    grid.columns[0].width = 30; // Sl.No
    grid.columns[1].width = 180; // Product
    grid.columns[2].width = 60; // Unit
    grid.columns[3].width = 60; // Rate
    grid.columns[4].width = 40; // Qty
    grid.columns[5].width = 40; // Foc
    grid.columns[6].width = 50; // Vat
    grid.columns[7].width = 60;

    // Add headers.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Sl.No';
    headerRow.cells[1].value = 'Product';
    headerRow.cells[2].value = 'Unit';
    headerRow.cells[3].value = 'Rate';
    headerRow.cells[4].value = 'Qty';
    headerRow.cells[5].value = 'Foc';
    headerRow.cells[6].value = 'Vat';
    headerRow.cells[7].value = 'Amount';

    for (int k = 0; k < invoice.data!.detail!.length; k++) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = '${k + 1}';
      row.cells[1].value = '${invoice.data!.detail![k].name}';
      row.cells[2].value = '${invoice.data!.detail![k].unit}';
      row.cells[3].value = '${invoice.data!.detail![k].mrp}';
      row.cells[4].value = '${invoice.data!.detail![k].quantity}';
      row.cells[5].value =
          (invoice.data!.detail![k].productType!.toLowerCase() == "foc")
              ? '1'
              : '0';
      row.cells[6].value = '${invoice.data!.detail![k].taxAmt}';
      row.cells[7].value = '${invoice.data!.detail![k].amount?.toStringAsFixed(2)}';
    }

    // Define no border style
    final PdfBorders noBorder = PdfBorders(
      left: PdfPen(PdfColor(255, 255, 255), width: 0),
      top: PdfPen(PdfColor(255, 255, 255), width: 0),
      right: PdfPen(PdfColor(255, 255, 255), width: 0),
      bottom: PdfPen(PdfColor(255, 255, 255), width: 0),
    );

    // Remove borders from all header cells
    for (int j = 0; j < grid.headers.count; j++) {
      for (int k = 0; k < grid.headers[j].cells.count; k++) {
        grid.headers[j].cells[k].style.borders = noBorder;
      }
    }

    // Remove borders from all body cells
    for (int i = 0; i < grid.rows.count; i++) {
      for (int j = 0; j < grid.columns.count; j++) {
        grid.rows[i].cells[j].style.borders = noBorder;
      }
    }

    // Draw the table.
    final PdfLayoutResult result = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 300, pageSize.width, pageSize.height - 180),
    )!;

    //   // Calculate the Y position for the line after the first row
    // final double firstRowHeight = grid.headers[0].height + grid.rows[0].height;

    // // Draw a line after the first row of the grid
    // page.graphics.drawLine(
    //   PdfPen(PdfColor(0, 0, 0), width: 1),
    //   Offset(0, result.bounds.top + firstRowHeight),
    //   Offset(pageSize.width, result.bounds.top + firstRowHeight),
    // );
    // Check if the table extends to the next page
    PdfPage lastPage = result.page;
    double tableBottom = result.bounds.bottom;

    if (tableBottom >= pageSize.height) {
      // Add a new page
      lastPage = document.pages.add();
      tableBottom = 0;
    }

    // Draw a horizontal line after the table.
    lastPage.graphics.drawLine(
      PdfPen(PdfColor(0, 0, 0)),
      Offset(0, tableBottom + 15),
      Offset(pageSize.width, tableBottom + 15),
    );

    // Draw invoice details at the bottom right.
    String bottomInvoiceDetails = '''
  ${num.parse(invoice.data!.roundOff.toString()) != 0 ? 'Discount: ${invoice.data!.discount}' : '\t'}
  Total: ${invoice.data!.total}
  Tax: ${invoice.data!.totalTax}
  ${num.parse(invoice.data!.roundOff.toString()) != 0 ? 'Round off: ${invoice.data!.roundOff}\nGrand Total: ${invoice.data!.grandTotal}' : 'Grand Total: ${invoice.data!.grandTotal}'} 
  
 
  ''';

    lastPage.graphics.drawString(
      bottomInvoiceDetails,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(
        pageSize.width / 2,
        tableBottom + 20,
        pageSize.width / 2,
        100,
      ),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.right,
      ),
    );

// in word
    String textData =
        'Amount in Words: ${NumberToWord().convert('en-in', invoice.data!.grandTotal!.toInt()).toUpperCase()}';

// Adjust the vertical position for the van details
    double vanDetailsTop = tableBottom + 20 + 100 + 10;

// Construct the van details string.
    String bottomVanDetails = '''
Van: ${invoice.data!.van![0].name}
Salesman: ${invoice.data!.user![0].name}
''';

// Draw the word text above the van details
    lastPage.graphics.drawString(
      textData,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(
        0,
        vanDetailsTop -
            30, // Adjust vertical position to be above the van details
        pageSize.width,
        100,
      ),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
    );
// Draw van details at the bottom left.
    lastPage.graphics.drawString(
      bottomVanDetails,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(
        0,
        vanDetailsTop,
        pageSize.width / 2,
        100,
      ),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
      ),
    );
    List<int> bytes = await document.save();
    document.dispose();

    String file = await saveAndLaunchFile(
        bytes, '${invoice.data!.invoiceNo!}.pdf', isPrint);
  }

  Future<String> _getImageData(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    Uint8List bytes = response.bodyBytes;
    return base64Encode(bytes);
  }

  Future<Uint8List> _readImageData(String? image) async {
    // print(image);
    // print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
    try {
      final response = await http
          .get(Uri.parse('${RestDatasource().Image_URL}/uploads/store/$image'));

      print('Response Data $response');

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      // Log the error and return an empty Uint8List
      print('Error loading image: $e');
      return Uint8List(0);
    }
  }

  Future<void> _getInvoiceData(int id, bool isPrint) async {
    Invoice.InvoiceData invoice = Invoice.InvoiceData();
    RestDatasource api = RestDatasource();
    dynamic response =
        await api.getDetails('/api/get_sales_invoice?id=$id', AppState().token);

    if (response['data'] != null) {
      invoice = Invoice.InvoiceData.fromJson(response);
      _createPdf(invoice, isPrint);
    }
    if (_selectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Default device not found')),
      );
      return;
    }
    if (!_connected) {
      await _connect();
    }
    _print(invoice, isPrint);
  }
  // void _connectAndPrint() async {
  //   if (_selectedDevice == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Default device not found')),
  //     );
  //     return;
  //   }
  //   if (!_connected) {
  //     await _connect();
  //   }
  //   _print();
  // }
}
