import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../confg/appconfig.dart';
import 'homepage.dart';

class ErrorHandlingScreen extends StatefulWidget {
  static const routeName = "/ErrorHandlingScreen";

  const ErrorHandlingScreen({super.key});

  @override
  State<ErrorHandlingScreen> createState() => _ErrorHandlingScreenState();
}

class _ErrorHandlingScreenState extends State<ErrorHandlingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      Duration(seconds: 1),
      () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}
