import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../Components/commonwidgets.dart';
import '../Models/DriverDetailsModel.dart';
import '../Models/appstate.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class DeliveryDetailsDriver extends StatefulWidget {
  static const routeName = "/ProductDetailsDriver";

  const DeliveryDetailsDriver({super.key});

  @override
  State<DeliveryDetailsDriver> createState() => _DeliveryDetailsDriverState();
}

class _DeliveryDetailsDriverState extends State<DeliveryDetailsDriver> {
  List<bool> isSelected = [true, false, false];
  void _onContainerTap(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        if (i == index) {
          isSelected[i] = true;
        } else {
          isSelected[i] = false;
        }
      }
      futureDeliveries = fetchDeliverstatus(txt[index].toLowerCase());
    });
  }

  List<bool> expandedStates = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureDeliveries = fetchDeliverstatus(txt[0].toLowerCase());
  }

  late Future<List<CustomerDelivery>> futureDeliveries;
  Future<List<CustomerDelivery>> fetchDeliverstatus(String status) async {
    final String uri =
        'http://68.183.92.8:3699/api/get_scheduled_delivery_by_driver_$status?store_id=${AppState().storeId}&user_id=${AppState().userId}';
    final response = await http.get(Uri.parse(uri));
    print(uri);
    if (response.statusCode == 200) {
      // print(AppState().storeId);
      // print(AppState().userId);

      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        final deliveries = List<CustomerDelivery>.from(jsonResponse['data']
            .map((delivery) => CustomerDelivery.fromJson(delivery)));

        // Reset expandedStates to match the length of the new deliveries
        setState(() {
          expandedStates = List<bool>.filled(deliveries.length, false);
        });

        return deliveries;
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  late String name;
  late String address;
  late String code;
  List<String> txt = ['Pending', 'Delivered', 'All'];
  @override
  Widget build(BuildContext context) {
    // if (ModalRoute.of(context)!.settings.arguments != null) {
    //   final Map<String, dynamic>? params =
    //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    //   name = params!['name'];
    //   address = params['address'];
    //   phone = params!['phone'];
    //   location = params['location'];
    //   whatsappNumber = params['whatsappNumber'];
    //   customerType = params!['customerType'];
    //   creditDays = params['days'];
    //   creditBalance = params['balance'];
    //   totalOutstanding = params['total'];
    //   trn = params['trn'];
    //   paymentTerms = params['paymentTerms'];
    //   provinceId = params['provinceId'];
    //   routeId = params['routeId'];
    //   creditLimit = params!['creditLimit'];
    //   email = params!['mail'];
    //   id = params['id'];
    //   code = params['code'];
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppConfig.backgroundColor,
          ),
        ),
        title: Text(
          'Delivery',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: () => _onContainerTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                        color: isSelected[index]
                            ? AppConfig.colorPrimary
                            : AppConfig.backgroundColor,
                        border: Border.all(
                            color: AppConfig.colorPrimary, width: 1.w)),
                    width: 100.w,
                    height: 30.h,
                    child: Center(
                        child: Text(
                      txt[index],
                      style: TextStyle(
                          color: isSelected[index]
                              ? AppConfig.backgroundColor
                              : AppConfig.colorPrimary,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              })),
          FutureBuilder<List<CustomerDelivery>>(
              future: futureDeliveries,
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
                  return Center(child: Text('No data'));
                } else {
                  if (expandedStates.isEmpty) {
                    expandedStates =
                        List<bool>.filled(snapshot.data!.length, false);
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final delivery = snapshot.data![index];
                            // final isSelected =
                            // selectedDeliveries.contains(delivery);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Tooltip(
                                            message: delivery.invoiceNo,
                                            child: Text(
                                              '${delivery.invoiceNo}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    AppConfig.textCaption3Size,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  expandedStates[index] =
                                                      !expandedStates[index];
                                                });
                                              },
                                              icon: Icon(
                                                  Icons.arrow_drop_down_circle))
                                        ],
                                      ),
                                      // const SizedBox(height: 8.0),
                                      // Column(
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.start,
                                      //   children: [
                                      //     Text(
                                      //       '${delivery.details[0].name}',
                                      //       style: TextStyle(
                                      //         fontSize:
                                      //             AppConfig.textCaption3Size,
                                      //         color: Colors.black54,
                                      //       ),
                                      //     ),
                                      //     const SizedBox(height: 4.0),
                                      //     Text(
                                      //       'Qty: ${delivery.details[0].quantity}',
                                      //       style: TextStyle(
                                      //         fontSize:
                                      //             AppConfig.textCaption3Size,
                                      //         color: Colors.black54,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      Visibility(
                                          visible: expandedStates[index],
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: delivery.details
                                                  .map((Details) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Prd: ${Details.name}',
                                                      style: TextStyle(
                                                        fontSize: AppConfig
                                                            .textCaption3Size,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Qty: ${Details.quantity}',
                                                      style: TextStyle(
                                                        fontSize: AppConfig
                                                            .textCaption3Size,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Divider(
                                                      color:
                                                          Colors.grey.shade300,
                                                    )
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}
