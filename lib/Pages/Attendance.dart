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
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import 'homepage.dart';

class Attendance extends StatefulWidget {
  static const routeName = "/Attendance";
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  Map<String, dynamic>? checkInDetails;
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
  String formattedDate =
      DateFormat('dd MMMM yyyy, EEEE').format(DateTime.now());
  late Future<ApiResponse> futureApiResponse;
  String _containerText = '';
  String _containerText1 = '';
  bool _isCheckedIn = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    futureApiResponse =
        fetchCheckInOutData(AppState().vanId!, AppState().storeId!);
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        formattedTime = DateFormat('hh:mm a').format(_currentTime);
      });
    });
  }

  void fetchData() async {
    try {
      final data = await fetchCheckInDetails();
      setState(() {
        checkInDetails = data['data'];
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _showDialog() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: _textFieldController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _containerText = _textFieldController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog1() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: _textFieldController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _containerText1 = _textFieldController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
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
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              Future<void> checkIn() async {
                final url = Uri.parse(
                    '${RestDatasource().BASE_URL}/api/check-in.store');
                final headers = {'Content-Type': 'application/json'};
                final body = jsonEncode({
                  'store_id': AppState().storeId,
                  'van_id': AppState().vanId,
                  'user_id': AppState().userId,
                  'last_odometer_in': snapshot.data!.data.lastOdometerIn,
                  'chek_in_time': formattedTime,
                  'check_in_odometer': _containerText,
                });

                final response =
                    await http.post(url, headers: headers, body: body);

                if (response.statusCode == 200) {
                  print('Check-in successful!');
                } else {
                  print('Failed to check-in: ${response.statusCode}');
                  print('Response body: ${response.body}');
                }
              }

              Future<void> _checkIn() async {
                await checkIn();
                setState(() {
                  fetchData();
                  _isCheckedIn = true;
                });
              }

              Future<void> checkout() async {
                final url = Uri.parse(
                    '${RestDatasource().BASE_URL}/api/check-out.store');
                final headers = {'Content-Type': 'application/json'};
                final body = jsonEncode({
                  'id': checkInDetails!['id'] ?? '',
                  'sheduled': AppState().storeId,
                  'visited': AppState().vanId,
                  'not_visied': AppState().userId,
                  'visit_pending': snapshot.data!.data.pending,
                  'check_out_time': formattedTime,
                  'check_out_odo_meter': _containerText1,
                });

                final response =
                    await http.post(url, headers: headers, body: body);

                if (response.statusCode == 200) {
                  if (mounted) {
                    CommonWidgets.showDialogueBox(
                            context: context,
                            title: "",
                            msg: "Data Inserted Successfully")
                        .then((value) =>
                            Navigator.pushNamed(context, HomeScreen.routeName));
                  }
                  print('Check-out successful!');
                } else {
                  print('Failed to check-in: ${response.statusCode}');
                  print('Response body: ${response.body}');
                }
              }

              Future<void> _checkOut() async {
                await checkout();
                setState(() {
                  _isCheckedIn = false;
                });
              }

              // int id = checkInDetails!['id'];
              checkInDetails == null
                  ? _isCheckedIn = false
                  : _isCheckedIn = true;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
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
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${AppState().name ?? ''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Van",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            Text(
                              " ${snapshot.data!.data.van}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 12),
                        child: Row(
                          children: [
                            Text(
                              "Last Odometer Reading ",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${snapshot.data!.data.lastOdometerIn} | ${snapshot.data!.data.lastOdometerOut}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 12),
                        child: Text(
                            "Scheduled ${snapshot.data!.data.sheduled} | Visited ${snapshot.data!.data.vistCustomer} | Not Visited ${snapshot.data!.data.nonVistCustomer} | Pending ${snapshot.data!.data.pending}",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text("Date"),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Text("Time"),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Text("Odometer"),
                      //         SizedBox(
                      //           height: 40,
                      //         ),
                      //         Text(""),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: [

                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Row(
                      //           children: [
                      //             Container(
                      //               width: 80,
                      //               height: 22,
                      //               decoration: BoxDecoration(
                      //                 color: _isCheckedIn
                      //                     ? Colors.grey.shade400
                      //                     : AppConfig.backgroundColor,
                      //                 borderRadius: BorderRadius.circular(2),
                      //                 border: Border.all(),
                      //               ),
                      //               child: Center(
                      //                   child: Text(_isCheckedIn
                      //                       ? checkInDetails == null
                      //                           ? ' '
                      //                           : '${checkInDetails!['chek_in_time']}'
                      //                       : formattedTime)),
                      //             ),
                      //             SizedBox(
                      //               width: 15,
                      //             ),
                      //             Container(
                      //               width: 80,
                      //               height: 22,
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(2),
                      //                 color: _isCheckedIn
                      //                     ? AppConfig.backgroundColor
                      //                     : Colors.grey.shade400,
                      //                 border: Border.all(
                      //                   style: BorderStyle.solid,
                      //                 ),
                      //               ),
                      //               child: Center(
                      //                   child: Text(
                      //                       _isCheckedIn ? formattedTime : '')),
                      //             ),
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Row(
                      //           children: [
                      //             GestureDetector(
                      //               onTap: () {
                      //                 _isCheckedIn ? null : _showDialog();
                      //               },
                      //               child: Container(
                      //                 width: 80,
                      //                 height: 22,
                      //                 decoration: BoxDecoration(
                      //                   color: _isCheckedIn
                      //                       ? Colors.grey.shade400
                      //                       : AppConfig.backgroundColor,
                      //                   borderRadius: BorderRadius.circular(2),
                      //                   border: Border.all(),
                      //                 ),
                      //                 child: Center(
                      //                     child: Text(_isCheckedIn
                      //                         ? checkInDetails == null
                      //                             ? ' '
                      //                             : '${checkInDetails!['check_in_odometer']}'
                      //                         : _containerText)),
                      //               ),
                      //             ),
                      //             SizedBox(
                      //               width: 15,
                      //             ),
                      //             GestureDetector(
                      //               onTap: () {
                      //                 _isCheckedIn ? _showDialog1() : null;
                      //               },
                      //               child: Container(
                      //                 width: 80,
                      //                 height: 22,
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(2),
                      //                   color: _isCheckedIn
                      //                       ? AppConfig.backgroundColor
                      //                       : Colors.grey.shade400,
                      //                   border: Border.all(
                      //                     style: BorderStyle.solid,
                      //                   ),
                      //                 ),
                      //                 child: Center(child: Text(_containerText1)),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Row(
                      //           children: [
                      //             ElevatedButton(
                      //               onPressed: _isCheckedIn ? null : _checkIn,
                      //               child: Text(
                      //                 'Check in',
                      //                 style: TextStyle(
                      //                     color: AppConfig.backgroundColor),
                      //               ),
                      //               style: ButtonStyle(
                      //                 backgroundColor:
                      //                     WidgetStateProperty.resolveWith<Color>(
                      //                   (Set<WidgetState> states) {
                      //                     if (states
                      //                         .contains(WidgetState.disabled)) {
                      //                       return Colors
                      //                           .grey; // Color when button is disabled
                      //                     }
                      //                     return AppConfig
                      //                         .colorPrimary; // Color when button is enabled
                      //                   },
                      //                 ),
                      //                 shape: WidgetStatePropertyAll(
                      //                     RoundedRectangleBorder(
                      //                         borderRadius:
                      //                             BorderRadius.circular(3))),
                      //                 padding: WidgetStateProperty.all(
                      //                     EdgeInsets.symmetric(
                      //                         horizontal: 8,
                      //                         vertical:
                      //                             4)), // Adjust padding as needed
                      //
                      //                 minimumSize: WidgetStateProperty.all(Size(
                      //                     80,
                      //                     22)), // Set minimum width and height
                      //               ),
                      //             ),
                      //             SizedBox(
                      //               width: 15,
                      //             ),
                      //             ElevatedButton(
                      //               onPressed: _isCheckedIn ? _checkOut : null,
                      //               child: Text(
                      //                 'Check out',
                      //                 style: TextStyle(
                      //                     color: AppConfig.backgroundColor),
                      //               ),
                      //               style: ButtonStyle(
                      //                 backgroundColor:
                      //                     WidgetStateProperty.resolveWith<Color>(
                      //                   (Set<WidgetState> states) {
                      //                     if (states
                      //                         .contains(WidgetState.disabled)) {
                      //                       return Colors
                      //                           .grey; // Color when button is disabled
                      //                     }
                      //                     return AppConfig
                      //                         .colorPrimary; // Color when button is enabled
                      //                   },
                      //                 ),
                      //                 shape: WidgetStatePropertyAll(
                      //                     RoundedRectangleBorder(
                      //                         borderRadius:
                      //                             BorderRadius.circular(3))),
                      //                 padding: WidgetStateProperty.all(
                      //                     EdgeInsets.symmetric(
                      //                         horizontal: 8,
                      //                         vertical:
                      //                             4)), // Adjust padding as needed
                      //
                      //                 minimumSize: WidgetStateProperty.all(Size(
                      //                     80,
                      //                     22)), // Set minimum width and height
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 310,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppConfig.colorPrimary),
                            child: Center(
                                child: Text(
                              "$formattedDate",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppConfig.backgroundColor),
                            )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _isCheckedIn
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade200,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Check-in'),
                                Text(
                                  _isCheckedIn
                                      ? checkInDetails == null
                                          ? ' '
                                          : '${checkInDetails!['chek_in_time']}'
                                      : formattedTime,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _isCheckedIn
                                  ? Colors.grey.shade200
                                  : Colors.grey.shade400,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Check-out'),
                                Text(
                                  _isCheckedIn ? formattedTime : '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _isCheckedIn ? null : _showDialog();
                            },
                            child: Container(
                              height: 100,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _isCheckedIn
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade200,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Odometer'),
                                  Container(
                                    width: 80,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: _isCheckedIn
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(2),
                                      border:
                                          _isCheckedIn ? null : Border.all(),
                                    ),
                                    child: Center(
                                        child: Text(
                                      _isCheckedIn
                                          ? checkInDetails == null
                                              ? ' '
                                              : '${checkInDetails!['check_in_odometer']}'
                                          : _containerText,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              _isCheckedIn ? _showDialog1() : null;
                            },
                            child: Container(
                              height: 100,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _isCheckedIn
                                    ? Colors.grey.shade200
                                    : Colors.grey.shade400,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Odometer'),
                                  Container(
                                    width: 80,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: _isCheckedIn
                                          ? AppConfig.backgroundColor
                                          : Colors.grey.shade400,
                                      border:
                                          _isCheckedIn ? Border.all() : null,
                                    ),
                                    child: Center(
                                        child: Text(
                                      _containerText1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _isCheckedIn ? null : _checkIn,
                            child: Text(
                              'Check in',
                              style:
                                  TextStyle(color: AppConfig.backgroundColor),
                            ),
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              fixedSize:
                                  const WidgetStatePropertyAll(Size(150, 0)),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Colors
                                        .grey; // Color when button is disabled
                                  }
                                  return AppConfig
                                      .colorPrimary; // Color when button is enabled
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                            onPressed: _isCheckedIn ? _checkOut : null,
                            child: Text(
                              'Check out',
                              style:
                                  TextStyle(color: AppConfig.backgroundColor),
                            ),
                            style: ButtonStyle(
                              fixedSize:
                                  const WidgetStatePropertyAll(Size(150, 0)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Colors
                                        .grey; // Color when button is disabled
                                  }
                                  return AppConfig
                                      .colorPrimary; // Color when button is enabled
                                },
                              ),

                              // Set minimum width and height
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

Future<ApiResponse> fetchCheckInOutData(int vanId, int storeId) async {
  final response = await http.get(Uri.parse(
      '${RestDatasource().BASE_URL}/api/get_today_check_in_and_out?van_id=$vanId&store_id=$storeId'));

  if (response.statusCode == 200) {
    return ApiResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

String apiUrl =
    '${RestDatasource().BASE_URL}/api/get_today_check_in_detail?van_id=${AppState().vanId}&store_id=${AppState().storeId}';

Future<Map<String, dynamic>> fetchCheckInDetails() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
