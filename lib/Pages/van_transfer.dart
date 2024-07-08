import 'package:flutter/material.dart';

import '../confg/appconfig.dart';

class VanTransfer extends StatefulWidget {
  static const routeName = "/VanTransfer";

  const VanTransfer({super.key});

  @override
  State<VanTransfer> createState() => _VanTransferState();
}

class _VanTransferState extends State<VanTransfer> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(appBar: AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppConfig.colorPrimary,
      title: const Text(
        'Van Transfer Request',
        style: TextStyle(color: AppConfig.backgroundColor),
      ),
    ),);
  }
}
