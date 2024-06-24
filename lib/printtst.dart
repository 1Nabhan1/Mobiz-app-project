import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class PrinterExample extends StatefulWidget {
  @override
  _PrinterExampleState createState() => _PrinterExampleState();
}

class _PrinterExampleState extends State<PrinterExample> {
  String macAddress =
      'DC:1D:30:00:1D:87'; // Replace with your printer's Bluetooth MAC address
  BluetoothDevice? printerDevice;
  bool isPrinting = false;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothCharacteristic? writeCharacteristic;

  @override
  void initState() {
    super.initState();
    connectToPrinter();
  }

  void connectToPrinter() {
    flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
      if (scanResult.device.id.id == macAddress) {
        print('Found printer: ${scanResult.device.name}');
        printerDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () {
      if (printerDevice == null) {
        print('Printer not found');
        // Handle printer not found scenario
      }
    });
  }

  void connectToDevice() async {
    if (printerDevice != null) {
      await printerDevice!.connect();
      print('Connected to printer: ${printerDevice!.name}');
      discoverServices();
    }
  }

  void discoverServices() async {
    try {
      List<BluetoothService> services = await printerDevice!.discoverServices();
      services.forEach((service) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase() ==
              "0000FFE1-0000-1000-8000-00805F9B34FB") {
            writeCharacteristic = characteristic;
          }
        });
      });
    } catch (e) {
      print('Failed to discover services: $e');
    }
  }

  Future<void> sendPrintData(String data) async {
    if (writeCharacteristic != null) {
      try {
        List<int> bytes = utf8.encode(data);
        await writeCharacteristic!.write(bytes, withoutResponse: true);
        print('Data sent to printer: $data');
      } catch (e) {
        print('Failed to send data: $e');
      }
    } else {
      print('Characteristic not found');
    }
  }

  void printReceipt() {
    setState(() {
      isPrinting = true;
    });

    // Example receipt content
    String content = '''
    Sample Store
    123 Sample St
    Sample City, ST 12345
    www.samplestore.com
    --------------------------------
    SALE
    Chicken Sandwich          \$5.00
    French Fries              \$2.00
    Iced Tea                  \$1.50
    --------------------------------
    Total                   \$8.50
    Thank you for your visit!
    ''';

    // Send data to printer
    sendPrintData(content).then((_) {
      setState(() {
        isPrinting = false;
      });
    });
  }

  @override
  void dispose() {
    printerDevice?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: isPrinting ? null : printReceipt,
              child: Text('Print Receipt'),
            ),
            if (isPrinting) SizedBox(height: 20),
            if (isPrinting) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
