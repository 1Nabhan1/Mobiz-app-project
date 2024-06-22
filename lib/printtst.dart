// import 'package:flutter/services.dart' as flutter_services;
// import 'package:printing/printing.dart';
// import 'package:printing/src/fonts/manifest.dart' as printing_manifest;
//
// class PrinterService {
//   Future<void> printReceipt(NetworkPrinter printer, String text) async {
//     final profile = await CapabilityProfile.load();
//
//     final PosPrintResult res = await printer.connect('192.168.1.109', port: 8899);
//
//     if (res == PosPrintResult.success) {
//       printer.text(text);
//       printer.cut();
//       printer.disconnect();
//     }
//   }
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PrinterPage(),
//     );
//   }
// }
//
// class PrinterPage extends StatelessWidget {
//   final PrinterService _printerService = PrinterService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Printer Example'),
//       ),
//       body: Center(
//         child: IconButton(
//           icon: Icon(Icons.print),
//           onPressed: () async {
//             final profile = await CapabilityProfile.load();
//             final printer = NetworkPrinter(PaperSize.mm80, profile);
//
//             // Using the printer instance directly
//             await _printerService.printReceipt(printer, 'Sample Text to Print');
//           },
//         ),
//       ),
//     );
//   }
// }
//
//
