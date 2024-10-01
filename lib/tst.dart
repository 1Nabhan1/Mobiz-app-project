// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CartPage extends StatelessWidget {
//   final List<Map<String, dynamic>> savedCartItems;
//
//   CartPage({required this.savedCartItems});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Saved Cart Items'),
//       ),
//       body: ListView.builder(
//         itemCount: savedCartItems.length,
//         itemBuilder: (context, index) {
//           final product = savedCartItems[index];
//           final quantity = double.tryParse(product['quantity']?.toString() ?? '0') ?? 0.0;
//           final amount = double.tryParse(product['amount']?.toString() ?? '0') ?? 0.0;
//           final total = quantity * amount;
//
//           return Card(
//             elevation: 1,
//             child: ListTile(
//               title: Text('${product['code']} | ${product['name']}'),
//               subtitle: Text(
//                 'Qty: ${product['quantity']} | Rate: ${product['amount']} | Total: ${total.toStringAsFixed(2)}',
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
