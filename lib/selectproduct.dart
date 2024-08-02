import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterTest extends StatefulWidget {
  @override
  _PrinterTestState createState() => _PrinterTestState();
}

class _PrinterTestState extends State<PrinterTest> {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _loadSelectedDevice();
    _getBluetoothDevices();
  }

  void _loadSelectedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDeviceAddress = prefs.getString('selected_device_address');

    if (savedDeviceAddress != null && savedDeviceAddress.isNotEmpty) {
      List<BluetoothDevice> devices = await printer.getBondedDevices();
      BluetoothDevice? deviceToSelect;

      for (BluetoothDevice device in devices) {
        if (device.address == savedDeviceAddress) {
          deviceToSelect = device;
          break;
        }
      }

      setState(() {
        _devices = devices;
        _selectedDevice = deviceToSelect;
      });
    }
  }

  void _getBluetoothDevices() async {
    List<BluetoothDevice> devices = await printer.getBondedDevices();
    setState(() {
      _devices = devices;
    });
  }

  void _onDeviceSelected(BluetoothDevice device) async {
    setState(() {
      _selectedDevice = device;
    });

    // Save the selected device's address to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_device_address', device.address ?? '');

    // Optionally show a snackbar or other UI feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected device saved: ${device.address}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: _devices.isEmpty
          ? Center(child: Text('No devices found'))
          : ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return ListTile(
            title: Text(device.name ?? 'Unnamed Device'),
            trailing: _selectedDevice == device
                ? Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => _onDeviceSelected(device),
          );
        },
      ),
    );
  }
}