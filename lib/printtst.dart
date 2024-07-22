import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class PrinterTest extends StatefulWidget {
  @override
  _PrinterTestState createState() => _PrinterTestState();
}

class _PrinterTestState extends State<PrinterTest> {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _connected = false;

  // Default Bluetooth device address
  final String _defaultDeviceAddress = "00:13:7B:84:E9:89";

  @override
  void initState() {
    super.initState();
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

  void _disconnect() async {
    await printer.disconnect();
    setState(() {
      _connected = false;
    });
  }

  Future<String> _getImageData(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    Uint8List bytes = response.bodyBytes;
    return base64Encode(bytes);
  }

  void _print() async {
    if (_connected) {
      // Example data
      String companyName = "Testing Company";
      String companyAddress = "null";
      String companyTRN = "TRN: hhd672653ugdb";
      String customerName = "null | fresh Store";
      String customerEmail = "freshst@gmail.com";
      String customerContact = "215128758";
      String customerTRN = "hhd672653ugdb";
      String invoiceNumber = "SI0037";
      String invoiceDate = "03 July 2024";
      String dueDate = "03 July 2024";
      String productDescription =
          "Samsung Galaxy S24 Ultra 5G AI Smartphone (Titanium Gray, 12GB, 512GB Storage)";
      String productRate = "100";
      String productQty = "1";
      String productTotal = "100";
      String tax = "10";
      String grandTotal = "110";
      String amountInWords = "ONE HUNDRED TEN";
      String van = "VAN10";
      String salesman = "tcsalex";

      // Print company logo
      String imageUrl =
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRQ0HqT9dk3DeLLbBHebie1wSK7HYWCudOCw&s";
      String imageData = await _getImageData(imageUrl);
      printer.printImage(imageData);

      // Print company details
      printer.printNewLine();
      printer.printCustom(companyName, 3, 1);
      printer.printCustom(companyAddress, 1, 1);
      printer.printCustom(companyTRN, 1, 1);
      printer.printNewLine();
      printer.printCustom(
          "------------------------------------------------", 1, 0);
      // Print customer details
      printer.printCustom("Customer: $customerName", 1, 0);
      printer.printCustom("Email: $customerEmail", 1, 0);
      printer.printCustom("Contact No: $customerContact", 1, 0);
      printer.printCustom("TRN: $customerTRN", 1, 0);
      printer.printNewLine();

      // Print invoice details
      printer.printCustom("Invoice No: $invoiceNumber", 1, 2);
      printer.printCustom("Date: $invoiceDate", 1, 2);
      printer.printCustom("Due Date: $dueDate", 1, 2);
      printer.printNewLine();
      printer.printCustom(
          "------------------------------------------------", 1, 0);
      // Print product details
      printer.printCustom("S.No  Product Unit  Rate  Qty  Tax  Amount", 1, 0);
      printer.printCustom(
          "1     $productDescription PCS   $productRate   $productQty   $tax   $productTotal",
          1,
          0);
      printer.printCustom(
          "------------------------------------------------", 1, 0);
      // printer.printCustom("Unit  Rate  Qty  Tax  Amount", 1, 0);
      // printer.printCustom(
      //     "PCS   $productRate   $productQty   $tax   $productTotal", 1, 0);
      printer.printNewLine();

      // Print totals
      printer.printCustom("Total: $productTotal", 1, 2);
      printer.printCustom("Tax: $tax", 1, 2);
      printer.printCustom("Grand Total: $grandTotal", 1, 2);
      printer.printNewLine();

      // Print amount in words
      printer.printCustom("Amount in Words: $amountInWords", 1, 0);
      printer.printNewLine();

      // Print van and salesman details
      printer.printCustom("Van: $van", 1, 0);
      printer.printCustom("Salesman: $salesman", 1, 0);
      printer.printNewLine();

      // Cut the paper
      printer.paperCut();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Printer not connected')),
      );
    }
  }

  void _connectAndPrint() async {
    if (_selectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Default device not found')),
      );
      return;
    }
    if (!_connected) {
      await _connect();
    }
    _print();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Printer Demo'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _connectAndPrint,
            child: Text('Connect and Print using Default Device'),
          ),
        ],
      ),
    );
  }
}
