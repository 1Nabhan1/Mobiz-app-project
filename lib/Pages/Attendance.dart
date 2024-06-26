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
          'Attendance',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 180,
                height: 180,
                child: Image.network(
                    'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg'),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("Hello Sales"),
            Row(
              children: [
                Text("Van "),
                Text(
                  "DXB12345",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Row(
              children: [
                Text("Last Odometer Reading "),
                Text(
                  "45000 | 45600",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            Text("Scheduled 10 | Visited 5 | Not Visited 1 | Pending 4"),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Date"),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),border: Border.all()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text("27 Jan 2024, Wednesday"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text("Time"),
                ),
                SizedBox(width: 40,),
                IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text("08:00 AM"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 80.0,
                      minHeight: 25.0,
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                      color: Colors.grey.shade400,
                      border: Border.all(
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(child: Text("")),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text("Odometer"),
                ),
                SizedBox(width: 10,),
                IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("456022"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 80.0,
                      minHeight: 25.0,
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                      color: Colors.grey.shade400,
                      border: Border.all(
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(child: Text("")),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 90),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 80.0,
                      minHeight: 25.0,
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                      color:AppConfig.colorPrimary,
                      border: Border.all(
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(child: Text("Check In",style: TextStyle(color: Colors.white),)),
                  ),
                  // SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 80.0,
                        minHeight: 25.0,
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                        color: Colors.grey.shade400,
                        border: Border.all(
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(child: Text("Check Out",style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


