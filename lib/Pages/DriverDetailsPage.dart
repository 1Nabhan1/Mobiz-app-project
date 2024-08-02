import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:signature/signature.dart';

import '../Components/commonwidgets.dart';
import '../Models/DriverDetailsModel.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import 'homepage_Driver.dart';

class DriverDetails extends StatefulWidget {
  static const routeName = "/DriverDetails";
  const DriverDetails({super.key});

  @override
  State<DriverDetails> createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  late Future<ApiResponse> _futureData;

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  int? id;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<ApiResponse> fetchData() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_customer_delivery_by_driver?store_id=${AppState().storeId}&user_id=${AppState().userId}'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['id'];
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        title: const Text(
          'Driver Details',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
        backgroundColor: AppConfig.colorPrimary,
        actions: [],
      ),
      body: FutureBuilder<ApiResponse>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Failed to load data'));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final List<Data> data = snapshot.data!.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${data[0].customer[0].name} | ${data[0].customer[0].code} | ${data[0].customer[0].address}',
                    style: TextStyle(
                      fontSize: 15,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: data.map((item) {
                      void postDataToApi() async {
                        var url = Uri.parse(
                            '${RestDatasource().BASE_URL}/api/customer-delivery.store');
                        var data = {
                          'customer_id': id,
                          'store_id': '${AppState().storeId}',
                          'user_id': '${AppState().userId}',
                          'invoice_no': item.invoiceNo ?? '',
                          'goods_out_id': item.detail[0].goodsOutId,
                          'received_by': _nameController.text,
                          'signature': '',
                        };
                        var body = json.encode(data);

                        var response = await http.post(
                          url,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: body,
                        );

                        if (response.statusCode == 200) {
                          print('Post successful');
                          if (mounted) {
                            CommonWidgets.showDialogueBox(
                                context: context,
                                title: "Alert",
                                msg: "Created Successfully");
                            Navigator.of(context)
                                .pushReplacementNamed(HomepageDriver.routeName);
                          }
                          print(response.body);
                        } else {
                          print(
                              'Post failed with status: ${response.statusCode}');
                          print(response.body);
                        }
                      }

                      return Column(
                        children: [
                          Card(
                            elevation: 1,
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal * 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3)),
                                color: AppConfig.backgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Slightly increased padding for better spacing
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row for aligning invoiceNo and scheduleDate in a single line
                                    Row(
                                      children: [
                                        Tooltip(
                                          message: item.invoiceNo,
                                          child: SizedBox(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    70,
                                            child: Text(
                                              '${item.invoiceNo} | ${item.scheduleDate}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    AppConfig.textCaption3Size,
                                              ),
                                              overflow: TextOverflow
                                                  .ellipsis, // Prevents overflow issues
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height:
                                            5.0), // Added spacing between the rows for better visual separation
                                    // Details of the item
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' ${item.detail[0].name}',
                                          style: TextStyle(
                                            fontSize:
                                                AppConfig.textCaption3Size,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                3.0), // Added spacing between text elements
                                        Text(
                                          'Qty: ${item.detail[0].quantity}',
                                          style: TextStyle(
                                            fontSize:
                                                AppConfig.textCaption3Size,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Received in Good Condition',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text('Received By'),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .65,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      child: TextField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          border: InputBorder
                                              .none, // Removes the default underline border
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal:
                                                  10), // Adjust padding as needed
                                        ),
                                        style: TextStyle(
                                          fontSize:
                                              14, // Adjust font size as needed
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Signature'),
                                    SizedBox(
                                      width: 45,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .66,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .17,
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          child: Signature(
                                            controller: _signatureController,
                                            backgroundColor:
                                                AppConfig.backgroundColor,
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppConfig.colorPrimary),
                                            shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .zero, // Removes the circular border
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            _signatureController.clear();
                                          },
                                          child: Text(
                                            'Clear',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50.h,
                                        ),
                                        Center(
                                          child: Container(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    35,
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    5,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        AppConfig.colorPrimary),
                                                shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .zero, // Removes the circular border
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                // if (_signatureController.isNotEmpty) {
                                                //   final signature =
                                                //       await _signatureController.toPngBytes();
                                                //
                                                // }
                                                postDataToApi();
                                              },
                                              child: Text(
                                                'SAVE',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                // SizedBox(
                //   height: 20,
                // ),
                // Spacer(),
                //
                // SizedBox(
                //   height: 50,
                // )
              ],
            );
          }
        },
      ),
    );
  }
}
