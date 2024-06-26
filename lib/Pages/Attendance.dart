import 'package:flutter/material.dart';

import '../confg/appconfig.dart';

class Attendance extends StatefulWidget {
  static const routeName = "/Attendance";
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: AppBar(
      leading: GestureDetector(onTap: () {
        Navigator.pop(context);
      },
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppConfig.colorPrimary,
      title: Text(
        'Attendance',
        style: TextStyle(color: AppConfig.backgroundColor),
      ),
    ),);
  }
}
