import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/main.dart';
import 'package:mobizapp/selectproduct.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert'; // For jsonDecode
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Components/commonwidgets.dart';
import 'Pages/All Due/OverdueCustomerPage.dart';
import 'Pages/TestInvoice.dart';
import 'Pages/homeorder.dart';
import 'Pages/loginpage.dart';
import 'Pages/receiptscreen.dart';
import 'Utilities/sharepref.dart';
import 'confg/appconfig.dart';
import 'confg/sizeconfig.dart';

class SalesData {
  final int id;
  final String name;
  final double sales;

  SalesData({required this.id, required this.name, required this.sales});

  factory SalesData.fromJson(List<dynamic> json) {
    return SalesData(
      id: json.isNotEmpty && json[0] is int ? json[0] : 0,
      name: json.length > 1 && json[1] is String ? json[1] : 'Unknown',
      sales: json.length > 2 && json[2] is num
          ? (json[2] as num).toDouble()
          : 0.0, // Ensure sales is parsed correctly
    );
  }
}

class DashboardData {
  final double todayOrderTotal;
  final double monthOrderTotal;
  final double todaySalesTotal;
  final double monthSalesTotal;
  final double todayCollectionTotal;
  final double monthCollectionTotal;
  final List<SalesData> todaySalesGraph;
  final List<SalesData> monthSalesGraph;
  final List<SalesData> todaySalesOrderGraph;
  final List<SalesData> monthSalesOrderGraph;

  DashboardData({
    required this.todayOrderTotal,
    required this.monthOrderTotal,
    required this.todaySalesTotal,
    required this.monthSalesTotal,
    required this.todayCollectionTotal,
    required this.monthCollectionTotal,
    required this.todaySalesGraph,
    required this.monthSalesGraph,
    required this.todaySalesOrderGraph,
    required this.monthSalesOrderGraph,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    List<SalesData> parseSalesData(String key) {
      if (json.containsKey(key) && json[key] is List) {
        return (json[key] as List)
            .map((data) => SalesData.fromJson(data))
            .toList();
      }
      return [];
    }

    return DashboardData(
      todayOrderTotal: (json['today_order_total'] is num)
          ? (json['today_order_total'] as num).toDouble()
          : 0.0,
      monthOrderTotal: (json['month_order_total'] is num)
          ? (json['month_order_total'] as num).toDouble()
          : 0.0,
      todaySalesTotal: (json['today_sales_total'] is num)
          ? (json['today_sales_total'] as num).toDouble()
          : 0.0,
      monthSalesTotal: (json['month_sales_total'] is num)
          ? (json['month_sales_total'] as num).toDouble()
          : 0.0,
      todayCollectionTotal: (json['today_collection_total'] is num)
          ? (json['today_collection_total'] as num).toDouble()
          : 0.0,
      monthCollectionTotal: (json['month_collection_total'] is num)
          ? (json['month_collection_total'] as num).toDouble()
          : 0.0,
      todaySalesGraph: parseSalesData('today_sales_graph'),
      monthSalesGraph: parseSalesData('month_sales_graph'),
      todaySalesOrderGraph: parseSalesData('today_sales_order_graph'),
      monthSalesOrderGraph: parseSalesData('month_sales_order_graph'),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  static const routeName = "/dashboard";

  const DashboardScreen({super.key});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late Future<DashboardData> dashboardData;
  late TabController _tabController1;
  late TabController _tabController2;
  String _appVersion = 'Loading...';
  bool isDailySelected = true;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    dashboardData = fetchDashboardData();
    _tabController1 = TabController(length: 2, vsync: this);
    _tabController1.addListener(() {
      setState(() {});
    });

    _tabController2 = TabController(length: 2, vsync: this);
    _tabController2.addListener(() {
      setState(() {});
    });
    _fetchAppVersion();
  }

  @override
  void dispose() {
    _tabController1.dispose();
    _tabController2.dispose();
    super.dispose();
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<DashboardData> fetchDashboardData() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/manager_dashboard?store_id=${AppState().storeId}'));

    if (response.statusCode == 200) {
      print(response.request);
      print(response.body);
      final jsonData = jsonDecode(response.body);
      return DashboardData.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> onRefreshHandler() async {
    setState(() {
      dashboardData = fetchDashboardData();
    });
  }

  Future<void> _fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  void onTimePeriodChanged(bool isDaily) {
    setState(() {
      isDailySelected = isDaily;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        title: Text(
          "Hello ${AppState().name}",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: SizedBox(
        width: SizeConfig.blockSizeHorizontal * 50,
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              children: [
                CommonWidgets.verticalSpace(8),
                CircleAvatar(
                    radius: 70.0,
                    backgroundColor: Colors.transparent,
                    child: Lottie.asset(
                        'Assets/Images/Animation - 1722081243637.json',
                        fit: BoxFit.cover,
                        width: 70)),
                ListTile(
                  leading: Icon(Icons.drive_file_rename_outline),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    print(AppState().routeId);
                    print(AppState().vanId);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.call),
                  title: const Text('Contact Us'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                  onTap: () {
                    conformation(context);
                    clearSharedPreferences();
                  },
                ),
                const Divider(),
                Text('v$_appVersion'),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: onRefreshHandler,
        child: FutureBuilder<DashboardData>(
          future: dashboardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: 12,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisExtent: 120,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 30,
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var data = snapshot.data!;
              final todaySalesOrderGraph = data.todaySalesOrderGraph;
              final monthSalesOrderGraph = data.monthSalesOrderGraph;
              String formatToMillion(double number) {
                // if (number >= 1000000) {
                //   double million = number / 1000000;
                //   return NumberFormat('0.0').format(million) + 'M';
                // } else {
                return NumberFormat('#,##0.00').format(number);
                // }
              }

              final PageController _pageController = PageController();

              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 2,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal! * 3),
                        child: Column(
                          children: [
                            SizedBox(
                        height: MediaQuery.of(context).size.height *.37,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: 2, // Three pages for your three rows
                                itemBuilder: (context, pageIndex) {
                                  return Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // if (pageIndex == 0) ...[
                                          Column(
                                            children: [
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     GestureDetector(
                                              //       onTap: () {
                                              //         Navigator.pushNamed(
                                              //             context,
                                              //             HomeorderScreen
                                              //                 .routeName);
                                              //       },
                                              //       child: buildCard(
                                              //           'Today\'s Order',
                                              //           formatToMillion(
                                              //               data.todayOrderTotal)),
                                              //     ),
                                              //     GestureDetector(
                                              //       onTap: () {
                                              //         Navigator.pushNamed(
                                              //             context,
                                              //             HomeorderScreen
                                              //                 .routeName);
                                              //       },
                                              //       child: buildCard(
                                              //           'This Month Order',
                                              //           formatToMillion(
                                              //               data.monthOrderTotal)),
                                              //     ),
                                              //   ],
                                              // ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          SaleInvoiceScrreen
                                                              .routeName);
                                                    },
                                                    child: buildCard(
                                                        'Today\'s Sale',
                                                        formatToMillion(
                                                            data.todaySalesTotal)
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          SaleInvoiceScrreen
                                                              .routeName);
                                                    },
                                                    child: buildCard(
                                                        'This Month Sale',
                                                        formatToMillion(
                                                            data.monthSalesTotal)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: SizeConfig.safeBlockVertical! * 2,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          ReceiptScreen
                                                              .receiptScreen);
                                                    },
                                                    child: colorCard(
                                                        'Today\'s Collection',
                                                        formatToMillion(data
                                                            .todayCollectionTotal)),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          ReceiptScreen
                                                              .receiptScreen);
                                                    },
                                                    child: colorCard(
                                                        'This Month Collection',
                                                        formatToMillion(data
                                                            .monthCollectionTotal)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: SizeConfig.safeBlockVertical! * 2,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    // onTap: () {
                                                    //   Navigator.pushNamed(
                                                    //       context,
                                                    //       ReceiptScreen
                                                    //           .receiptScreen);
                                                    // },
                                                    child: buildCard(
                                                        'PDC',
                                                        // formatToMillion(0.0)
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          OverdueCustomerPage
                                                              .routeName);
                                                    },
                                                    child: buildCard(
                                                        'All Dues',
                                                        // formatToMillion(0.0)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: SizeConfig.safeBlockVertical! * 2,
                                              ),
                                            ],
                                          ),
                                        // ] else if (pageIndex == 1) ...[
                                        //   Column(
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       GestureDetector(
                                        //         onTap: () {
                                        //           Navigator.pushNamed(
                                        //               context,
                                        //               OverdueCustomerPage
                                        //                   .routeName);
                                        //         },
                                        //         child: Container(
                                        //           height: SizeConfig.safeBlockVertical! * 11,
                                        //           width: SizeConfig.blockSizeHorizontal * 46,
                                        //           decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.circular(5),
                                        //             color: AppConfig.colorPrimary,
                                        //           ),
                                        //           child: Column(
                                        //             mainAxisAlignment: MainAxisAlignment.center,
                                        //             children: [
                                        //               Text("All Due", style: TextStyle(color: Colors.white)),
                                        //             ],
                                        //           ),
                                        //         )
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ]
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 3,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     InkWell(
                                //       onTap: () {
                                //         setState(() {
                                //           selectedIndex = 0;
                                //         });
                                //       },
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           border:
                                //               Border.all(color: Colors.black),
                                //           color: selectedIndex == 0
                                //               ? AppConfig
                                //                   .colorPrimary // Background color when selected
                                //               : AppConfig
                                //                   .backButtonColor, // Background color when not selected
                                //           borderRadius: BorderRadius.circular(
                                //               10), // Rounded corners
                                //         ),
                                //         width: 100, // Custom width
                                //         height: 30,
                                //         child: Center(
                                //           child: Text(
                                //             'Sales',
                                //             style: TextStyle(
                                //               color: selectedIndex == 0
                                //                   ? Colors.white
                                //                   : Colors
                                //                       .black, // Text color based on selection
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(width: 10),
                                //     InkWell(
                                //       onTap: () {
                                //         setState(() {
                                //           selectedIndex =
                                //               1; // Set index to 1 for 'Sales Order'
                                //         });
                                //       },
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           border:
                                //               Border.all(color: Colors.black),
                                //           color: selectedIndex == 1
                                //               ? AppConfig
                                //                   .colorPrimary // Background color when selected
                                //               : AppConfig
                                //                   .backButtonColor, // Background color when not selected
                                //           borderRadius: BorderRadius.circular(
                                //               10), // Rounded corners
                                //         ),
                                //         width: 100, // Custom width
                                //         height: 30,
                                //         child: Center(
                                //           child: Text(
                                //             'Sales Order',
                                //             style: TextStyle(
                                //               color: selectedIndex == 1
                                //                   ? Colors.white
                                //                   : Colors
                                //                       .black, // Text color based on selection
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(height: 10),
                                IndexedStack(
                                  index: selectedIndex,
                                  children: [
                                    SfCartesianChart(
                                      primaryXAxis: const CategoryAxis(
                                        arrangeByIndex: true,
                                        edgeLabelPlacement:
                                            EdgeLabelPlacement.shift,
                                      ),
                                      zoomPanBehavior: ZoomPanBehavior(
                                          enablePanning: true,
                                          zoomMode: ZoomMode.x),
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      trackballBehavior: TrackballBehavior(
                                        enable: true,
                                        activationMode:
                                            ActivationMode.singleTap,
                                        tooltipSettings:
                                            const InteractiveTooltip(
                                          enable: true,
                                          color: Colors.black,
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        builder: (BuildContext context,
                                            TrackballDetails details) {
                                          final int index = details.pointIndex!;
                                          final SalesData salesData =
                                              isDailySelected
                                                  ? data.todaySalesGraph[index]
                                                  : data.monthSalesGraph[index];
                                          return Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              salesData.name,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        },
                                      ),
                                      series: <CartesianSeries>[
                                        StackedColumnSeries<SalesData, String>(
                                          dataSource: isDailySelected
                                              ? data.todaySalesGraph
                                              : data.monthSalesGraph,
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.name.length > 3
                                                  ? sales.name.substring(0, 3)
                                                  : sales.name,
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.sales,
                                          name: 'Sales',
                                          // color: Colors.blue,
                                          enableTooltip: true,
                                          // dataLabelSettings: DataLabelSettings(
                                          //   isVisible: true,
                                          //   textStyle: TextStyle(color: Colors.black,
                                          //   ),
                                          // ),
                                        ),
                                      ],
                                    ),
                                    SfCartesianChart(
                                      primaryXAxis: CategoryAxis(
                                        labelRotation: 0,
                                        edgeLabelPlacement:
                                            EdgeLabelPlacement.shift,
                                        arrangeByIndex: true,
                                        interval:
                                            1, // Ensures each label appears properly
                                        // enableScrolling: true, // ✅ Enables horizontal scrolling
                                      ),
                                      primaryYAxis: NumericAxis(
                                        labelStyle: TextStyle(
                                          color: Colors
                                              .black, // ✅ Make Y-axis numbers black
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      zoomPanBehavior: ZoomPanBehavior(
                                        enablePanning:
                                            true, // ✅ Allows dragging (panning)
                                        enablePinching:
                                            true, // ✅ Allows pinch zooming
                                      ),
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      trackballBehavior: TrackballBehavior(
                                        enable: true,
                                        activationMode:
                                            ActivationMode.singleTap,
                                        tooltipSettings:
                                            const InteractiveTooltip(
                                          enable: true,
                                          color: Colors.black,
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        builder: (BuildContext context,
                                            TrackballDetails details) {
                                          final int index = details.pointIndex!;
                                          final SalesData salesData =
                                              isDailySelected
                                                  ? data.todaySalesOrderGraph[
                                                      index]
                                                  : data.monthSalesOrderGraph[
                                                      index];
                                          return Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              salesData.name,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        },
                                      ),
                                      series: <CartesianSeries>[
                                        StackedColumnSeries<SalesData, String>(
                                          dataSource: isDailySelected
                                              ? todaySalesOrderGraph
                                              : monthSalesOrderGraph,
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.name.length > 3
                                                  ? sales.name.substring(0, 3)
                                                  : sales.name,
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.sales,
                                          name: 'Sales Order',
                                          enableTooltip:
                                              true, // ✅ Show tooltip with full name
                                          // dataLabelSettings: DataLabelSettings(
                                          //   isVisible: true,
                                          //   textStyle: TextStyle(
                                          //     color: Colors.black, // ✅ Change data label color to black
                                          //   ),
                                          // ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () => onTimePeriodChanged(
                                          true), // Set to daily
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          color: (!isDailySelected)
                                              ? AppConfig.backButtonColor
                                              : AppConfig
                                                  .colorPrimary, // Background color
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                        ),
                                        width: 100, // Custom width
                                        height: 30, // Custom height
                                        child: Center(
                                          child: Text(
                                            'Daily',
                                            style: TextStyle(
                                              color: (!isDailySelected)
                                                  ? AppConfig.textBlack
                                                  : AppConfig
                                                      .backButtonColor, // Text color
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () => onTimePeriodChanged(
                                          false), // Set to daily
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          color: (isDailySelected)
                                              ? AppConfig.backButtonColor
                                              : AppConfig
                                                  .colorPrimary, // Background color
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                        ),
                                        width: 100, // Custom width
                                        height: 30, // Custom height
                                        child: Center(
                                          child: Text(
                                            'Monthly',
                                            style: TextStyle(
                                              color: (isDailySelected)
                                                  ? AppConfig.textBlack
                                                  : AppConfig
                                                      .backButtonColor, // Text color
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 4,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('No Data Available'));
            }
          },
        ),
      ),
    );
  }

  Widget buildCard(String title, [String? amount]) {
    return Container(
      height: SizeConfig.safeBlockVertical! * 11,
      width: SizeConfig.blockSizeHorizontal * 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppConfig.colorPrimary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          if (amount != null) ...[
            SizedBox(height: 8),
            Text(
              "$amount",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppConfig.textCaptionSize,
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget colorCard(String title, String amount) {
    return Container(
      height: SizeConfig.safeBlockVertical! * 11,
      width: SizeConfig.blockSizeHorizontal * 46,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Color(0xFF06aedf)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          SizedBox(height: 8),
          Text(
            "$amount",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  conformation(BuildContext context) {
    Widget confirmButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: SizeConfig.safeBlockHorizontal! * 30,
            height: SizeConfig.safeBlockVertical! * 5,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                color: AppConfig.colorSuccess),
            child: Center(
              child: Text(
                'CANCEL',
                style: TextStyle(
                    fontFamily: 'helvetica',
                    letterSpacing: 1,
                    fontSize: AppConfig.captionSize,
                    color: AppConfig.backButtonColor),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            SharedPref().clear();
            AppState().loginState = "";
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          },
          child: Container(
            width: SizeConfig.safeBlockHorizontal! * 30,
            height: SizeConfig.safeBlockVertical! * 5,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                color: AppConfig.colorPrimary),
            child: Center(
              child: Text(
                'LOG OUT',
                style: TextStyle(
                    fontFamily: 'helvetica',
                    letterSpacing: 1,
                    fontSize: AppConfig.captionSize,
                    color: AppConfig.backgroundColor),
              ),
            ),
          ),
        ),
      ],
    );
    // set up the AlertDialog
    Dialog alert = Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonWidgets.verticalSpace(2),
            Text(
              "Confirm",
              style: TextStyle(
                  fontSize: AppConfig.headLineSize, fontFamily: 'helvetica'),
            ),
            CommonWidgets.verticalSpace(2),
            Text(
              "Are you sure you want to Logout?",
              style: TextStyle(fontSize: AppConfig.captionSize * 1.2),
              textAlign: TextAlign.center,
            ),
            CommonWidgets.verticalSpace(2),
            confirmButtons,
            CommonWidgets.verticalSpace(2),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
