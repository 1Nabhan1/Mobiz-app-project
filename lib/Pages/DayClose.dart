import 'package:flutter/material.dart';

import '../confg/appconfig.dart';

class Dayclose extends StatefulWidget {
  static const routeName = "/Dayclose";
  const Dayclose({super.key});

  @override
  State<Dayclose> createState() => _DaycloseState();
}

class _DaycloseState extends State<Dayclose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConfig.colorPrimary,
        title: Text(
          'Day close',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello Sales'),
                RichText(
                  text: TextSpan(
                      text: 'Van  ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'DXB12345',
                            style: TextStyle(color: Colors.grey))
                      ]),
                ),
                Text('Scheduled 10 | Visited 5 | Not Visited 1 | Pending 4'),
                RichText(
                  text: TextSpan(
                      text: 'Sales  ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: '4 | 1800.50',
                            style: TextStyle(color: Colors.grey))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Orders  ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: ' 2 | 100.50',
                            style: TextStyle(color: Colors.grey))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Returns  ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: '1 | 34.50',
                            style: TextStyle(color: Colors.grey))
                      ]),
                ),
                Text('Collection'),
                Text(
                  'Cash 150.00',
                  style: TextStyle(color: Colors.grey),
                ),
                Text('Cheque 4 | 1300.50',
                    style: TextStyle(color: Colors.grey)),
                Text('Last Day Balance'),
                Text('Cash 12.00', style: TextStyle(color: Colors.grey)),
                Text('Cheque 1 | 100.00', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
          )
        ],
      ),
    );
  }
}
