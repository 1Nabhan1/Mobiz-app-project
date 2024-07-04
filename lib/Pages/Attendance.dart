import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../Components/commonwidgets.dart';
import '../Models/appstate.dart';
import '../Models/attendance_model.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class Attendance extends StatefulWidget {
  static const routeName = "/Attendance";
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
  String formattedDate =
      DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
  late Future<ApiResponse> futureApiResponse;

  @override
  void initState() {
    super.initState();
    futureApiResponse = fetchCheckInOutData(9, 10);
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        formattedTime = DateFormat('hh:mm a').format(_currentTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

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
      body: Center(
        child: FutureBuilder<ApiResponse>(
          future: futureApiResponse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: AppConfig.buttonDeactiveColor.withOpacity(0.1),
                highlightColor: AppConfig.backButtonColor,
                child: Center(
                  child: Column(
                    children: [
                      CommonWidgets.loadingContainers(
                          height: SizeConfig.blockSizeVertical * 30,
                          width: SizeConfig.blockSizeHorizontal * 90),
                      CommonWidgets.loadingContainers(
                          height: SizeConfig.blockSizeVertical * 30,
                          width: SizeConfig.blockSizeHorizontal * 90),
                      // CommonWidgets.loadingContainers(
                      //     height: SizeConfig.blockSizeVertical * 10,
                      //     width: SizeConfig.blockSizeHorizontal * 90),
                      // CommonWidgets.loadingContainers(
                      //     height: SizeConfig.blockSizeVertical * 10,
                      //     width: SizeConfig.blockSizeHorizontal * 90),
                      // CommonWidgets.loadingContainers(
                      //     height: SizeConfig.blockSizeVertical * 10,
                      //     width: SizeConfig.blockSizeHorizontal * 90),
                      // CommonWidgets.loadingContainers(
                      //     height: SizeConfig.blockSizeVertical * 10,
                      //     width: SizeConfig.blockSizeHorizontal * 90),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              return Padding(
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
                    Text("Hello ${AppState().name ?? ''}"),
                    Row(
                      children: [
                        Text("Van"),
                        Text(
                          " ${snapshot.data!.data.van}",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Last Odometer Reading "),
                        Text(
                          "${snapshot.data!.data.lastOdometerIn} | ${snapshot.data!.data.lastOdometerOut}",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Text(
                        "Scheduled ${snapshot.data!.data.sheduled} | Visited ${snapshot.data!.data.vistCustomer} | Not Visited ${snapshot.data!.data.nonVistCustomer} | Pending ${snapshot.data!.data.pending}"),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Time"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Odometer"),
                            SizedBox(
                              height: 20,
                            ),
                            Text(""),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all()),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text("$formattedDate"),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text("$formattedTime"),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 80.0,
                                    minHeight: 25.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey.shade400,
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Center(child: Text("")),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(),
                                  ),
                                  child: Center(child: Text("423")),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 80.0,
                                    minHeight: 25.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey.shade400,
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Center(child: Text("")),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    checkIn();
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 80.0,
                                      minHeight: 25.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: AppConfig.colorPrimary,
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Check In",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                                // SizedBox(width: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 80.0,
                                      minHeight: 25.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Colors.grey.shade400,
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Check Out",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            } else {
              return Text('No data');
            }
          },
        ),
      ),
    );
  }
}

Future<void> checkIn() async {
  final url = Uri.parse('https://mobiz-api.yes45.in/api/check-in.store');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'in_date': '03/07/2024',
    'store_id': AppState().storeId,
    'van_id': AppState().vanId,
    'user_id': AppState().userId,
    'last_odometer_in': 100,
    'last_odo_meter_out': 120,
    'chek_in_time': '10.51 PM',
    'check_in_odometer': 120,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Check-in successful!');
  } else {
    print('Failed to check-in: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

Future<ApiResponse> fetchCheckInOutData(int vanId, int storeId) async {
  final response = await http.get(Uri.parse(
      'https://mobiz-api.yes45.in/api/get_today_check_in_and_out?van_id=$vanId&store_id=$storeId'));

  if (response.statusCode == 200) {
    return ApiResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}
