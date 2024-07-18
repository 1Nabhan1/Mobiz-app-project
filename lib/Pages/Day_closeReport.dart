import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:shimmer/shimmer.dart';
import '../Components/commonwidgets.dart';
import '../Models/Day_close.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';
import 'Day_expand.dart';

class DaycloseReport extends StatefulWidget {
  static const routeName = "/DaycloseReport";

  const DaycloseReport({Key? key}) : super(key: key);

  @override
  State<DaycloseReport> createState() => _DaycloseReportState();
}

class _DaycloseReportState extends State<DaycloseReport> {
  late Future<DayCloseDataResponse> futureDayCloseData1;

  @override
  void initState() {
    super.initState();
    futureDayCloseData1 = fetchDayCloseData1();
  }

  Future<DayCloseDataResponse> fetchDayCloseData1() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_dayclose?van_id=${AppState().vanId}&store_id=${AppState().storeId}'));

    if (response.statusCode == 200) {
      return DayCloseDataResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data from API 1');
    }
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
          'Day Close Report',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<DayCloseDataResponse>(
              future: futureDayCloseData1,
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.waiting) {
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
                        ],
                      ),
                    ),
                  );
                } else if (snapshot1.hasError) {
                  return Center(
                      child: Text(
                          'Failed to load data from API Please try again later.'));
                } else if (!snapshot1.hasData || snapshot1.data!.data.isEmpty) {
                  return Center(child: Text('No data available from API'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot1.data!.data.length,
                    itemBuilder: (context, index) {
                      DayCloseData dayClose1 = snapshot1.data!.data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 2,
                          // margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Invoice ID: ${dayClose1.invoiceNo}'),
                              subtitle: Text('Date: ${dayClose1.inDate}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Dayexpanding(
                                      id: dayClose1.id,
                                      invoiceNo: dayClose1.invoiceNo,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
