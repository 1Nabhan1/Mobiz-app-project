import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/customerdetailscreen.dart';
import 'package:shimmer/shimmer.dart';
import '../Components/commonwidgets.dart';
import '../Models/visit_reason_model.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import 'customerscreen.dart';
import 'homepage.dart';

class CustomerVisit extends StatefulWidget {
  static const routeName = "/Visiit";

  const CustomerVisit({super.key});

  @override
  State<CustomerVisit> createState() => _CustomerVisitState();
}

class _CustomerVisitState extends State<CustomerVisit> {
  bool isSelected = true;
  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
      futureVisitReason = fetchVisitReasons();
    });
  }

  TextEditingController remark = TextEditingController();
  late Future<VisitReasonResponse> futureVisitReason;
  VisitReason? selectedVisitReason;
  String? name;
  String? code;
  String? payment;
  String? address;
  String? phone;
  String? email;
  int? id;

  @override
  void initState() {
    super.initState();
    futureVisitReason = fetchVisitReasons();
    selectedVisitReason = null;
    // selectedVisitReason?.id = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      name = params!['name'];
      code = params['code'];
      payment = params['paymentTerms'];
      address = params['address'];
      phone = params['phone'];
      email = params['email'];
      id = params['id'];
    }
    return SafeArea(
      child: Scaffold(
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
            'Visit',
            style: TextStyle(color: AppConfig.backgroundColor),
          ),
        ),
        body: FutureBuilder<VisitReasonResponse>(
          future: futureVisitReason,
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
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Text(
                        "$code | $name | $payment\n$email\n$address\n$phone",
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!isSelected) {
                              setState(() {
                                selectedVisitReason = null;
                              });

                              toggleSelection();
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 100.0,
                              minHeight: 25.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: isSelected
                                  ? AppConfig.colorPrimary
                                  : Colors.transparent,
                              border: Border.all(
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Visit",
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              toggleSelection();
                              setState(() {
                                selectedVisitReason = null;
                              });
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 100.0,
                              minHeight: 25.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: !isSelected
                                  ? AppConfig.colorPrimary
                                  : Colors.transparent,
                              border: Border.all(
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Non Visit",
                                style: TextStyle(
                                  color:
                                      !isSelected ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Reason"),
                          Container(
                            height: MediaQuery.of(context).size.height * .03,
                            width: MediaQuery.of(context).size.width * .72,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all()),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<VisitReason>(
                                  isExpanded: true,
                                  hint: Text('Select Reason'),
                                  value: selectedVisitReason,
                                  onChanged: (VisitReason? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedVisitReason = newValue;
                                      });
                                    }
                                  },
                                  items: snapshot.data!.data
                                      .map((VisitReason visitReason) {
                                    return DropdownMenuItem<VisitReason>(
                                      value: visitReason,
                                      child: Center(
                                        child: Text(visitReason.reason ??
                                            'No reason provided'),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Remarks"),
                          SizedBox(
                            child: TextFormField(
                              controller: remark,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  hintText: 'Enter here',
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.w300),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide())),
                            ),
                            // height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width * .72,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppConfig.colorPrimary),
                          shape:
                              WidgetStateProperty.all(BeveledRectangleBorder()),
                          minimumSize: WidgetStateProperty.all(Size(70, 30)),
                        ),
                        onPressed: () {
                          // print(selectedVisitReason?.reason);
                          postData();
                        },
                        child: SizedBox(
                          width: 60,
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  void postData() async {
    var url = Uri.parse('https://mobiz-api.yes45.in/api/customervisit.store');
    var response = await http.post(url, body: {
      'van_id': AppState().vanId.toString(),
      'store_id': AppState().storeId.toString(),
      'visit_type': selectedVisitReason?.reason.toString(),
      'reason_id': selectedVisitReason?.id.toString(),
      // selectedVisitReason?.id.toString(),
      'description': remark.text,
      'customer_id': id.toString()
    });

    if (response.statusCode == 200) {
      if (mounted) {
        CommonWidgets.showDialogueBox(
                context: context, title: "", msg: "Data Inserted Successfully")
            .then((value) =>
                Navigator.pushReplacementNamed(context, HomeScreen.routeName));
      }
      print('Request successful');
      print('Response: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  static String visitReasonUrl =
      'https://mobiz-api.yes45.in/api/get_visit_reason?store_id=${AppState().storeId}';
  static String nonVisitReasonUrl =
      'https://mobiz-api.yes45.in/api/get_non_visit_reason?store_id=${AppState().storeId}';

  Future<VisitReasonResponse> fetchVisitReasons() async {
    final String url = isSelected ? visitReasonUrl : nonVisitReasonUrl;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return VisitReasonResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load visit reasons');
    }
  }
}
