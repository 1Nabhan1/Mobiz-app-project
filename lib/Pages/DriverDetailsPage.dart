import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import '../Components/commonwidgets.dart';
import '../Models/DriverDetailsModel.dart';
import '../Models/appstate.dart';
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

int? id;
String? name;
String? address;
String? code;

class _DriverDetailsState extends State<DriverDetails> {
  late Future<ApiResponse> _futureData;

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

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

  Future<File> _convertUiImageToFile(ui.Image signatureImage) async {
    // Convert ui.Image to ByteData
    ByteData? byteData =
        await signatureImage.toByteData(format: ui.ImageByteFormat.png);

    // Check if byteData is null
    if (byteData == null) {
      throw Exception("Failed to convert signature to image");
    }

    // Convert ByteData to Uint8List
    Uint8List imageData = byteData.buffer.asUint8List();

    // Get temporary directory
    final directory = await getTemporaryDirectory();

    // Create a file in the temporary directory
    final file = File('${directory.path}/signature.png');

    // Write the image data to the file
    await file.writeAsBytes(imageData);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      id = params!['id'];
      name = params['name'];
      address = params['address'];
      code = params['code'];
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
            return Shimmer.fromColors(
              baseColor: AppConfig.buttonDeactiveColor.withOpacity(0.1),
              highlightColor: AppConfig.backButtonColor,
              child: Center(
                child: Column(
                  children: [
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                    CommonWidgets.loadingContainers(
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 90),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Failed to load data'));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final List<Data> data = snapshot.data!.data;
            void postDataToApi() async {
              ui.Image? signatureImage = await _signatureController.toImage();

              if (signatureImage == null) {
                print("Failed to capture signature image");
                return;
              }

              File signatureFile;
              try {
                signatureFile = await _convertUiImageToFile(signatureImage);
              } catch (e) {
                print(e.toString());
                return;
              }

              var url = Uri.parse(
                  '${RestDatasource().BASE_URL}/api/customer-delivery.store');

              var request = http.MultipartRequest('POST', url);

              request.fields['customer_id'] = id.toString();
              request.fields['store_id'] = '${AppState().storeId}';
              request.fields['user_id'] = '${AppState().userId}';
              request.fields['invoice_no'] = '${data[0].invoiceNo ?? ''}';
              request.fields['goods_out_id'] =
                  '${data[0].detail[0].goodsOutId}';
              request.fields['received_by'] = _nameController.text;

              request.files.add(
                await http.MultipartFile.fromPath(
                  'signature',
                  signatureFile.path,
                  contentType: MediaType('image', 'png'),
                ),
              );

              var response = await request.send();

              if (response.statusCode == 200) {
                print('Post successful');
                // print(response.request);
                if (mounted) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Alert"),
                        content: Text("Created Successfully"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  HomepageDriver.routeName);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
                print(await response.stream.bytesToString());
              } else {
                print('Post failed with status: ${response.statusCode}');
                print(await response.stream.bytesToString());
              }
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '$name | $code | $address',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppConfig.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: item.invoiceNo,
                                  child: Text(
                                    '${item.invoiceNo} | ${item.scheduleDate}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppConfig.textCaption3Size,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.detail[0].name}',
                                      style: TextStyle(
                                        fontSize: AppConfig.textCaption3Size,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Qty: ${item.detail[0].quantity}',
                                      style: TextStyle(
                                        fontSize: AppConfig.textCaption3Size,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Received in Good Condition',
                          style: TextStyle(fontSize: 15),
                        ),
                        Row(
                          children: [
                            Text('Received By'),
                            SizedBox(width: 30),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide()),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 10)),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Signature'),
                            SizedBox(width: 53),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  child: Signature(
                                    width:
                                        MediaQuery.of(context).size.width * .64,
                                    height: MediaQuery.of(context).size.height *
                                        .17,
                                    controller: _signatureController,
                                    backgroundColor: AppConfig.backgroundColor,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        AppConfig.colorPrimary),
                                  ),
                                  onPressed: () {
                                    _signatureController.clear();
                                  },
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppConfig.colorPrimary),
                          fixedSize: WidgetStateProperty.all(Size(150, 20)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          postDataToApi();
                        },
                        child: Text(
                          'SAVE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
