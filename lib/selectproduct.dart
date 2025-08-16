import 'dart:io';
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as btp;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;

class PrinterTest extends StatefulWidget {
  @override
  _PrinterTestState createState() => _PrinterTestState();
}

class _PrinterTestState extends State<PrinterTest> {
  // Android Printer
  btp.BlueThermalPrinter androidPrinter = btp.BlueThermalPrinter.instance;
  List<btp.BluetoothDevice> _androidDevices = [];
  btp.BluetoothDevice? _selectedAndroidDevice;

  // iOS BLE
  List<ble.BluetoothDevice> _iosDevices = [];
  ble.BluetoothDevice? _selectedIosDevice;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _loadSelectedAndroidDevice();
      _getAndroidDevices();
    } else if (Platform.isIOS) {
      _getIosDevices();
    }
  }

  // Load selected device for Android
  void _loadSelectedAndroidDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDeviceAddress = prefs.getString('selected_device_address');

    if (savedDeviceAddress != null && savedDeviceAddress.isNotEmpty) {
      List<btp.BluetoothDevice> devices = await androidPrinter.getBondedDevices();
      btp.BluetoothDevice? deviceToSelect;

      for (btp.BluetoothDevice device in devices) {
        if (device.address == savedDeviceAddress) {
          deviceToSelect = device;
          break;
        }
      }

      setState(() {
        _androidDevices = devices;
        _selectedAndroidDevice = deviceToSelect;
      });
    }
  }

  void _getAndroidDevices() async {
    List<btp.BluetoothDevice> devices = await androidPrinter.getBondedDevices();
    setState(() {
      _androidDevices = devices;
    });
  }

  void _getIosDevices() async {
    _iosDevices.clear();
    setState(() {});
    await ble.FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    ble.FlutterBluePlus.scanResults.listen((List<ble.ScanResult> results) {
      setState(() {
        _iosDevices = results.map((r) => r.device).toList();
      });
    });
  }


  // Select device
  void _onDeviceSelected(dynamic device) async {
    if (device is btp.BluetoothDevice) {
      // Android device selection
      setState(() {
        _selectedAndroidDevice = device;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_device_address', device.address ?? '');
    } else if (device is ble.BluetoothDevice) {
      // iOS device selection
      setState(() {
        _selectedIosDevice = device;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected device: ${device.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth Devices')),
      body: Platform.isAndroid
          ? _androidDevices.isEmpty
          ? Center(child: Text('No Bluetooth devices found'))
          : ListView.builder(
        itemCount: _androidDevices.length,
        itemBuilder: (context, index) {
          final device = _androidDevices[index];
          return ListTile(
            title: Text(device.name ?? 'Unnamed Device'),
            trailing: _selectedAndroidDevice == device
                ? Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => _onDeviceSelected(device),
          );
        },
      )
          : _iosDevices.isEmpty
          ? Center(child: Text('No BLE printers found'))
          : ListView.builder(
        itemCount: _iosDevices.length,
        itemBuilder: (context, index) {
          final device = _iosDevices[index];
          return ListTile(
            title: Text(device.name ?? 'Unnamed BLE Device'),
            trailing: _selectedIosDevice == device
                ? Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => _onDeviceSelected(device),
          );
        },
      ),
    );
  }
}
