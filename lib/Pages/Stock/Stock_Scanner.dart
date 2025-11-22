import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isLoading = false;
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  Future<void> fetchProduct({
    required String productId,
    required String unit,
    String? batch,
    String? expiry,
  }) async {
    setState(() => isLoading = true);

    final url = Uri.parse(
      "http://68.183.92.8:3699/api/scan-qr?product_id=$productId&unit=$unit",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == true) {
          data["batch"] = batch ?? "";
          data["expiry"] = expiry ?? "";
          Navigator.pop(context, data,); // ✅ Return scanned data to previous page
        } else {
          _showError("Invalid product QR code");
        }
      } else {
        _showError("Failed: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) async {
    _cameraController.stop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    _cameraController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR / Barcode")),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: MobileScanner(
              controller: _cameraController,
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;
                  if (code == null) continue;

                  print("🔹 Scanned QR/Barcode: $code");

                  // ✅ Parse the format: product_id=10213;unit=149;batch=1;expiry=2025-09-30
                  final parts = code.split(';');
                  final Map<String, String> dataMap = {};

                  for (var part in parts) {
                    final keyValue = part.split('=');
                    if (keyValue.length == 2) {
                      dataMap[keyValue[0].trim()] = keyValue[1].trim();
                    }
                  }

                  final productId = dataMap['product_id'];
                  final unit = dataMap['unit'];
                  final batch = dataMap['batch'];
                  final expiry = dataMap['expiry'];

                  if (productId != null && unit != null) {
                    _cameraController.stop();
                    await fetchProduct(
                      productId: productId,
                      unit: unit,
                      batch: batch,
                      expiry: expiry,
                    );
                    break;
                  } else {
                    _showError("Invalid QR format");
                  }
                }
              },
            ),
          ),
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            const Expanded(
              child: Center(child: Text("Scan a QR code to fetch product")),
            ),
        ],
      ),
    );
  }
}
