import 'package:flutter/material.dart';
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

  void _print() async {
    if (_connected) {
      printer.printNewLine();
      printer.printCustom("Hello, Bluetooth Printer!", 3, 1);
      printer.printNewLine();
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
