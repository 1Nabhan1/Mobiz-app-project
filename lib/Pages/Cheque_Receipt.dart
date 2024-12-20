import 'dart:convert';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/Cheque/Cheque_Colection.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:mobizapp/confg/sizeconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Store_model.dart';

class ChequeReceipt extends StatefulWidget {
  static const routeName = "/Cheque receipt";

  const ChequeReceipt({super.key});

  @override
  State<ChequeReceipt> createState() => _ChequeReceiptState();
}

class _ChequeReceiptState extends State<ChequeReceipt> {
  List<Data> chequeList = [];
  bool isLoading = true;
  bool _connected = false;
  BluetoothDevice? _selectedDevice;
  List<BluetoothDevice> _devices = [];
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    fetchChequeCollection();
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

  Future<void> _connect() async {
    if (_selectedDevice != null) {
      await printer.connect(_selectedDevice!);
      setState(() {
        _connected = true;
      });
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
  }

  Future<void> fetchChequeCollection() async {
    String url = '${RestDatasource().BASE_URL}/api/cheque_collection_index?store_id=${AppState().storeId}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.request);
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          chequeList = (jsonData['data'] as List)
              .map((item) => Data.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Cheque Receipt",
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, ChequeCollectionPage.routeName);
              },
              child: Icon(Icons.add, size: SizeConfig.blockSizeVertical * 4),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chequeList.isEmpty
          ? const Center(child: Text('No data available'))
          : ListView.builder(
        itemCount: chequeList.length,
        itemBuilder: (context, index) {
          final data = chequeList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 2,
                    blurStyle: BlurStyle.inner,
                    color: Colors.grey.shade200,
                  ),
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                color: AppConfig.backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                trailing: SizedBox(
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                      onTap: () => _print(data),
                        child: const Icon(Icons.print, color: Colors.blueAccent),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        // onTap: () => generatePdf(data),
                        child: const Icon(Icons.document_scanner, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.chequeDate,
                          style: TextStyle(
                            fontSize: AppConfig.textCaption3Size,
                          ),
                        ),
                        Text(
                          "Receipt No: ${data.invoiceNo}",
                          style: TextStyle(
                            fontSize: AppConfig.textCaption3Size,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              data.bank,
                              style: TextStyle(
                                fontSize: AppConfig.textCaption3Size,
                                fontWeight: AppConfig.headLineWeight,
                              ),
                            ),
                            const Text(' | '),
                            Text(
                              "${data.chequeNo}",
                              style: TextStyle(
                                fontSize: AppConfig.textCaption3Size,
                                fontWeight: AppConfig.headLineWeight,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Amount: ${data.amount}',
                          style: TextStyle(
                            fontSize: AppConfig.textCaption3Size,
                          ),
                        ),
                        Row(
                          children: [
                            Text('Status: ',
                                style: TextStyle(
                                  fontSize: AppConfig.textCaption3Size,
                                )),
                            Text(
                              data.status == 1
                                  ? 'Pending'
                                  : data.status == 0
                                  ? 'Cancelled'
                                  : 'Completed',
                              style: TextStyle(
                                fontSize: AppConfig.textCaption3Size,
                                color: data.status == 1
                                    ? Colors.orange
                                    : data.status == 0
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: AppConfig.headLineWeight,
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void _print(Data data) async {
    if (_connected) {
      // Print Store Details Header
      // String logoUrl =`
      //     '${RestDatasource().Image_URL}/uploads/store/${storeDetail.logos}';
      // if (logoUrl.isNotEmpty) {
      //   final response = await http.get(Uri.parse(logoUrl));
      //   if (response.statusCode == 200) {
      //     Uint8List imageBytes = response.bodyBytes;
      //
      //     // Decode image and convert to monochrome bitmap if needed
      //     img.Image originalImage = img.decodeImage(imageBytes)!;
      //     img.Image monoLogo = img.grayscale(originalImage);
      //
      //     // Encode the image to the required format (e.g., PNG)
      //     Uint8List logoBytes = Uint8List.fromList(img.encodePng(monoLogo));
      //
      //     // Print the logo image
      //     printer.printImageBytes(logoBytes);
      //   } else {
      //     print('Failed to load image: ${response.statusCode}');
      //   }
      // }
      final response = await http.get(Uri.parse(
          '${RestDatasource().BASE_URL}/api/get_store_detail?store_id=${AppState().storeId}'));
      if (response.statusCode == 200) {
        // Parse JSON response into StoreDetail object
        StoreDetail storeDetail =
        StoreDetail.fromJson(json.decode(response.body));
        final String api =
            '${RestDatasource().Image_URL}/uploads/store/${storeDetail.logos}';
        final logoResponse = await http.get(Uri.parse(api));
        if (logoResponse.statusCode != 200) {
          throw Exception('Failed to load logo image');
        }

        void printAlignedText(String leftText, String rightText) {
          const int maxLineLength = 68;
          int leftTextLength = leftText.length;
          int rightTextLength = rightText.length;

          // Calculate padding to ensure rightText is right-aligned
          int spaceLength = maxLineLength - (leftTextLength + rightTextLength);
          String spaces = ' ' * spaceLength;

          printer.printCustom('$leftText$spaces$rightText', 1,
              0); // Print with left-aligned text
        }

        String logoUrl =
            'http://68.183.92.8:3697/uploads/store/${storeDetail.logos}';
        if (logoUrl.isNotEmpty) {
          final response = await http.get(Uri.parse(logoUrl));
          if (response.statusCode == 200) {
            Uint8List imageBytes = response.bodyBytes;

            // Decode image and convert to monochrome bitmap if needed
            img.Image originalImage = img.decodeImage(imageBytes)!;
            img.Image monoLogo = img.grayscale(originalImage);

            // Encode the image to the required format (e.g., PNG)
            Uint8List logoBytes = Uint8List.fromList(img.encodePng(monoLogo));

            // Print the logo image
            printer.printImageBytes(logoBytes);
          } else {
            print('Failed to load image: ${response.statusCode}');
          }
        }

        printer.printNewLine();
        String companyName =
            '${storeDetail.name}';
        printer.printCustom(companyName, 3, 1);
        printer.printNewLine();

        // printer.printCustom("TRN: ${storeDetail.trn ?? "N/A"}", 1, 1);
        printer.printCustom("CHEQUE RECEIPT", 3, 1);
        printer.printNewLine();
        printer.printCustom("-" * 72, 1, 1);

        // Print Customer Details
        // if (data != null && data.customer!.isNotEmpty) {
          printAlignedText('Customer: ${storeDetail.name}','');
          // printer.printLeftRight('Customer: ${data.customer![0].name}', '', 1);
          printAlignedText(
            // 'Market:  ${data.customer![0].address}',
              '',
              'Date: ${data.chequeDate}');
          // printer.printLeftRight('Market: ${data.customer![0].address}', '', 1);
          // printAlignedText('TRN: ${data.customer![0].trn}',
          //     'Due Date: ${data.sales![0].inDate}');
          // printer.printLeftRight('TRN: ${data.customer![0].trn}', '', 1);
        // }
        printer.printNewLine();
        printer.printCustom("-" * 72, 1, 1); // Centered

        // Print Sales Details
        // printer.printLeftRight(
        //     'Reference:', '${data.sales![0].voucherNo ?? 'N/A'}', 1);
        // printer.printLeftRight('Date:', '${data.sales![0].inDate}', 1);
        // printer.printLeftRight('Due Date:', '${data.sales![0].inDate}', 1);
        // printer.printNewLine();

        // Collection Information
        if (data.collectionType == 'Cheque') {
          printAlignedText('Collection Type: Cheque', 'Cheque No: ${data.chequeNo}');
          printAlignedText('Bank Name: ${data.bank}', 'Cheque Date: ${data.chequeDate}');
          // printAlignedText('Cheque No: ${data.chequeNo}', ' ');
          // printAlignedText('Cheque Date: ${data.chequeDate}', ' ');
        } else if (data.collectionType == 'Cash') {
          // Optional: Print something specific for cash or leave it out
          printAlignedText('Collection Type: Cash', ' '); // Uncomment if needed
        }
        printAlignedText('Amount: ${data.amount}', ' ');
        // printer.printLeftRight('Collection Type:', '${data.collectionType}', 1);
        // printer.printLeftRight('Bank Name:', '${data.bank}', 1);
        // printer.printLeftRight('Cheque No:', '${data.chequeNo}', 1);
        // printer.printLeftRight('Cheque Date:', '${data.chequeDate}', 1);
        // printer.printLeftRight('Amount:', '${data.totalAmount}', 1);
        printer.printNewLine();
        // printer.printCustom("-" * 72, 1, 1);
        // const int columnWidth0 = 4;
        // const int columnWidth1 = 14; // S.No
        // const int columnWidth2 = 20; // Product Description
        // const int columnWidth3 = 14; // Unit
        // const int columnWidth4 = 5;
        // String line;
        // String headers = "${''.padRight(columnWidth0)}"
        //     "${'SI.NO'.padRight(columnWidth1)}"
        //     " ${'Reference NO'.padRight(columnWidth2)}"
        //     " ${'Type'.padRight(columnWidth3)}"
        //     "${'Amount'.padRight(columnWidth4)}";
        // printer.printCustom(headers, 1, 0);
        // printer.printCustom("-" * 72, 1, 1);
        // Sales List Header
        // printer.printCustom('SI NO   Reference No   Type   Amount', 1, 0);
        // printer.printCustom('---------------------------', 1, 0);

        // Iterate and print each sales item

        // String formatInvoiceType(String? invoiceType) {
        //   if (invoiceType == null)
        //     return 'N/A'; // Return N/A if invoiceType is null
        //
        //   // Capitalize the first letter and check for specific cases
        //   switch (invoiceType.toLowerCase()) {
        //     case 'salesreturn':
        //       return 'Sales Return';
        //     case 'payment_voucher':
        //       return 'Payment';
        //     default:
        //       return invoiceType[0].toUpperCase() +
        //           invoiceType.substring(1).toLowerCase();
        //   }
        // }

        // for (var i = 0; i < data.sales!.length; i++) {
        //   var sale = data.sales![i];
        //   line = "${('').padRight(columnWidth0)}"
        //       "${(i + 1).toString().padRight(columnWidth1)}"
        //       " ${sale.invoiceNo?.padRight(columnWidth2) ?? 'N/A'.padRight(columnWidth2)}"
        //       "${formatInvoiceType(sale.invoiceType)?.padRight(columnWidth3) ?? 'N/A'.padRight(columnWidth3)}"
        //       "${sale.amount?.padRight(columnWidth4) ?? 'N/A'.padRight(columnWidth4)}";
        //   printer.printCustom(line, 1, 0);
        // }
        // printer.printNewLine();
        printer.printCustom("-" * 72, 1, 1);
        // if (data.roundoff != null && double.parse(data.roundoff!) != 0) {
        //   printAlignedText('',
        //       'Round Off: ${double.parse(data.roundoff!).toStringAsFixed(2)}');
        // }
        // printAlignedText('', 'Total: ${data.totalAmount}');
        printAlignedText("Van: ${data.vanId}", "");
        printAlignedText("Salesman: ${data.user.name}", "");
        // printer.printLeftRight('Van:', '${data.vanId}', 1);
        // printer.printLeftRight('Salesman:', 'N/A', 1);
        printer.printNewLine();

        printer.paperCut();
      } // Cut paper after printing
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Printer not connected')),
      );
    }
    if (!_connected) {
      await _connect();
    }
  }
}


class Data {
  final int id;
  final String? invoiceNo; // Nullable
  final String inDate;
  final String inTime;
  final int customerGroupId;
  final String collectionType;
  final double amount; // Updated to double
  final String chequeDate;
  final String bank;
  final String? chequeNo; // Nullable
  final String? description; // Nullable
  final int vanId;
  final int userId;
  final int storeId;
  final int dayClose;
  final int status;
  final String createdAt;
  final String updatedAt;
  final Store store; // Assuming only one store is present
  final User user; // Assuming only one user is present

  Data({
    required this.id,
    this.invoiceNo, // Nullable
    required this.inDate,
    required this.inTime,
    required this.customerGroupId,
    required this.collectionType,
    required this.amount,
    required this.chequeDate,
    required this.bank,
    this.chequeNo, // Nullable
    this.description, // Nullable
    required this.vanId,
    required this.userId,
    required this.storeId,
    required this.dayClose,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.store,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      invoiceNo: json['invoice_no'], // Nullable
      inDate: json['in_date'],
      inTime: json['in_time'],
      customerGroupId: json['customer_group_id'],
      collectionType: json['collection_type'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0, // Parsing to double
      chequeDate: json['cheque_date'],
      bank: json['bank'],
      chequeNo: json['cheque_no'], // Nullable
      description: json['description'], // Nullable
      vanId: json['van_id'],
      userId: json['user_id'],
      storeId: json['store_id'],
      dayClose: json['day_close'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      store: Store.fromJson(json['store'][0]), // Assuming only one store is present
      user: User.fromJson(json['user'][0]), // Assuming only one user is present
    );
  }
}

class Store {
  final int id;
  final String code;
  final String name;
  final int companyId;
  final String logo;
  final String emirate;
  final String country;
  final String contactNumber;
  final String? whatsappNumber; // Nullable
  final String email;
  final String username;
  final String password;
  final int noOfUsers;
  final String subscriptionEndDate;
  final String? description; // Nullable
  final String? currency; // Nullable
  final String? vatPercentage; // Nullable
  final String? trn;
  final int status;
  final String createdAt;
  final String updatedAt;

  Store({
    required this.id,
    required this.code,
    required this.name,
    required this.companyId,
    required this.logo,
    required this.emirate,
    required this.country,
    required this.contactNumber,
    this.whatsappNumber, // Nullable
    required this.email,
    required this.username,
    required this.password,
    required this.noOfUsers,
    required this.subscriptionEndDate,
    this.description, // Nullable
    this.currency, // Nullable
    this.vatPercentage, // Nullable
    this.trn, // Nullable
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      companyId: json['comapny_id'],
      logo: json['logo'],
      emirate: json['emirate'],
      country: json['country'],
      contactNumber: json['contact_number'],
      whatsappNumber: json['whatsapp_number'], // Nullable
      email: json['email'],
      username: json['username'],
      password: json['password'],
      noOfUsers: json['no_of_users'],
      subscriptionEndDate: json['suscription_end_date'],
      description: json['description'], // Nullable
      currency: json['currency'], // Nullable
      vatPercentage: json['vat_percentage'], // Nullable
      trn: json['trn'], // Nullable
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final bool isSuperAdmin;
  final bool isShopAdmin;
  final bool isStaff;
  final int departmentId;
  final int designationId;
  final int storeId;
  final int rolId;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.isSuperAdmin,
    required this.isShopAdmin,
    required this.isStaff,
    required this.departmentId,
    required this.designationId,
    required this.storeId,
    required this.rolId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return false;
    }

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      isSuperAdmin: parseBool(json['is_super_admin']),
      isShopAdmin: parseBool(json['is_shop_admin']),
      isStaff: parseBool(json['is_staff']),
      departmentId: json['department_id'],
      designationId: json['designation_id'],
      storeId: json['store_id'],
      rolId: json['rol_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}



