import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mobizapp/Components/commonwidgets.dart';
import 'package:mobizapp/Pages/Attendance.dart';
import 'package:mobizapp/Pages/DayClose.dart';
import 'package:mobizapp/Pages/ExpensesPage.dart';
import 'package:mobizapp/Pages/Stock/StockName_RequestScreen.dart';
import 'package:mobizapp/Pages/VIsitsPage.dart';
import 'package:mobizapp/Pages/customerscreen.dart';
import 'package:mobizapp/Pages/loginpage.dart';
import 'package:mobizapp/Pages/productspage.dart';
import 'package:mobizapp/Pages/receiptscreen.dart';
import 'package:mobizapp/Pages/selectProducts.dart';
import 'package:mobizapp/Pages/newvanstockrequests.dart';
import 'package:mobizapp/Pages/van_transfer.dart';
import 'package:mobizapp/Pages/vanstockdata.dart';
import 'package:mobizapp/Pages/vanstockrequest.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/Utilities/sharepref.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:mobizapp/confg/sizeconfig.dart';
import 'package:mobizapp/Water.dart';
import 'package:mobizapp/Models/VanStockDataModel.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/appstate.dart';
import '../Models/userDetails.dart';
import '../selectproduct.dart';
import 'Cheque/Cheque_Colection.dart';
import 'Schedule_page.dart';
import 'VanTransfer_option.dart';
import 'homeorder.dart';
import 'homereturn.dart';
import 'offLoadRequest.dart';
import 'saleinvoices.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> savedCartItems = [];
  bool _restrict = false;
  String _appVersion = 'Loading...';
  bool performLogout() {
    try {
      SharedPref().clear();
      AppState().loginState = "";
      return true;
    } catch (e) {
      print('Logout failed: $e');
      return false;
    }
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void initState() {
    _getUserDetails();
    super.initState();
    _fetchAppVersion();
  }

  Future<void> _fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Map<String, double> dataMap = {
    "60.0": 60,
    "80.0": 80,
  };

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        backgroundColor: AppConfig.colorPrimary,
        titleSpacing: 0,
        title: RichText(
          text: TextSpan(
            text: 'Hello ',
            style: TextStyle(
                color: AppConfig.backgroundColor,
                fontSize: AppConfig.textSubtitle3Size),
            children: <TextSpan>[
              TextSpan(
                text: '${AppState().name}',
                style: TextStyle(
                    color: AppConfig.backgroundColor,
                    fontSize: AppConfig.textSubtitle3Size),
              ),
            ],
          ),
        ),
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
                        width: 70)
                    // Image.asset(
                    //   'Assets/Images/profile.png',
                    //   fit: BoxFit.contain,
                    // ),
                    ),
                // CommonWidgets.verticalSpace(3),
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
                  leading: Icon(Icons.print),
                  title: const Text('Printer'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrinterTest(),
                        ));
                  },
                ),

                // ListTile(
                //   leading: Icon(Icons.print),
                //   title: const Text('Cart'),
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => CartPage(savedCartItems: [],),
                //         ));
                //   },
                // ),

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
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        child: PageView(
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          CommonWidgets.verticalSpace(2),
                          Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'Assets/Images/main logo.png',
                                    fit: BoxFit.cover,
                                    width: SizeConfig.blockSizeHorizontal * 18,
                                    height: SizeConfig.blockSizeVertical * 8,
                                  ),
                                ]),
                          ),
                          CommonWidgets.verticalSpace(4),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.715,
                            child: PageView(
                              children: [
                                Container(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (_restrict) {
                                                    CommonWidgets.showDialogueBox(
                                                        context: context,
                                                        title: "Alert",
                                                        msg:
                                                            "Van not allocated to this user");
                                                  } else {
                                                    Navigator.pushNamed(
                                                        context,
                                                        VanStockScreen
                                                            .routeName);
                                                  }
                                                },
                                                child: _iconButtons(
                                                    icon: Icons.directions_bus,
                                                    title: 'Van Stock'),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    if (_restrict) {
                                                      CommonWidgets.showDialogueBox(
                                                          context: context,
                                                          title: "Alert",
                                                          msg:
                                                              "Van not allocated to this user");
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          CustomersDataScreen
                                                              .routeName);
                                                    }
                                                  },
                                                  child: _iconButtons(
                                                      icon: Icons.people,
                                                      title: 'Customer')),
                                              GestureDetector(
                                                onTap: () {
                                                  if (_restrict) {
                                                    CommonWidgets.showDialogueBox(
                                                        context: context,
                                                        title: "Alert",
                                                        msg:
                                                            "Van not allocated to this user");
                                                  } else {
                                                    Navigator.pushNamed(
                                                        context,
                                                        ProductsScreen
                                                            .routeName);
                                                  }
                                                },
                                                child: _iconButtons(
                                                    icon: Icons.shopping_cart,
                                                    title: 'Product'),
                                              )
                                            ]),
                                        CommonWidgets.verticalSpace(2),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(Expensespage
                                                          .routeName);
                                                },
                                                child: _iconButtons(
                                                    icon: Icons.menu_book,
                                                    title: 'Expense')),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    Tststs.routeName);
                                              },
                                              child: _iconButtons(
                                                  icon: Icons.water_drop,
                                                  title: 'Coupon'),
                                            ),
                                            InkWell(
                                              onTap: () => Navigator.pushNamed(
                                                  context,
                                                  SaleInvoiceScrreen.routeName),
                                              child: _iconButtons(
                                                  icon: Icons.document_scanner,
                                                  title: 'Invoice'),
                                            )
                                          ],
                                        ),
                                        CommonWidgets.verticalSpace(2),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    Navigator.pushNamed(
                                                        context,
                                                        ReceiptScreen
                                                            .receiptScreen),
                                                child: _iconButtons(
                                                    icon: Icons.receipt,
                                                    title: 'Receipt'),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        HomereturnScreen
                                                            .routeName);
                                                  },
                                                  child: _iconButtons(
                                                      icon: Icons.inventory,
                                                      title: 'Return')),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(SchedulePage
                                                          .routeName);
                                                },
                                                child: _iconButtons(
                                                    icon: Icons.calendar_today,
                                                    title: 'Schedule'),
                                              ),
                                            ]),
                                        CommonWidgets.verticalSpace(2),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          Attendance.routeName);
                                                },
                                                child: _iconButtons(
                                                    icon: Icons.groups,
                                                    title: 'Attendance')),
                                            GestureDetector(
                                              onTap: () {
                                                if (_restrict) {
                                                  CommonWidgets.showDialogueBox(
                                                      context: context,
                                                      title: "Alert",
                                                      msg:
                                                          "Van not allocated to this user");
                                                } else {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          VanStockRequestsScreen
                                                              .routeName);
                                                }
                                              },
                                              child: _iconButtons(
                                                  icon: Icons.question_answer,
                                                  title: 'Van Stock Request'),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    OffLoadRequestScreen
                                                        .routeName);
                                              },
                                              child: _iconButtons(
                                                icon: Icons.receipt_long,
                                                title: 'Off Load Request',
                                              ),
                                            )
                                          ],
                                        ),
                                        CommonWidgets.verticalSpace(2),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          Visitspage.routeName);
                                                },
                                                child: _iconButtons(
                                                    icon: Icons.handshake,
                                                    title: 'Visit')),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    VantransferOption
                                                        .routeName);
                                              },
                                              child: _iconButtons(
                                                  image:
                                                      'Assets/Images/van stock.png',
                                                  title: 'Transfer'),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    Dayclose.routeName);
                                              },
                                              child: _iconButtons(
                                                  image:
                                                      'Assets/Images/day close.png',
                                                  title: 'Day Close'),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      HomeorderScreen
                                                          .routeName);
                                                },
                                                child: _iconButtons(
                                                    icon: Icons.local_mall,
                                                    title: 'Order')),

                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    StockName_RequestScreen
                                                        .routeName);
                                              },
                                              child: _iconButtons(
                                                icon: Icons.receipt_long,
                                                title: 'Stoke Take',
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    ChequeCollectionPage
                                                        .routeName);
                                              },
                                              child: _iconButtons(
                                                icon: Icons.credit_card_sharp,
                                                title: 'Cheque Collection',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: SizeConfig.blockSizeVertical * 32.5,
                    //   width: SizeConfig.screenWidth,
                    //   decoration: BoxDecoration(
                    //     color: AppConfig.colorPrimary,
                    //     borderRadius: BorderRadius.only(
                    //       bottomLeft: const Radius.circular(0),
                    //       bottomRight: const Radius.circular(0),
                    //       topRight: Radius.elliptical(
                    //         MediaQuery.of(context).size.width,
                    //         60.0,
                    //       ),
                    //       topLeft: Radius.elliptical(
                    //         MediaQuery.of(context).size.width,
                    //         60.0,
                    //       ),
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       CommonWidgets.verticalSpace(3),
                    //       Stack(
                    //         clipBehavior: Clip.none,
                    //         children: [
                    //           Text(
                    //             'Mobiz',
                    //             style: TextStyle(
                    //                 fontSize: AppConfig.headLineSize * 2,
                    //                 color: AppConfig.backgroundColor,
                    //                 fontWeight: AppConfig.headLineWeight),
                    //           ),
                    //           Positioned(
                    //             top: SizeConfig.blockSizeVertical * 5,
                    //             left: 18,
                    //             child: Text(
                    //               'Sales',
                    //               style: TextStyle(
                    //                 fontSize: AppConfig.headLineSize * 1.5,
                    //                 color: AppConfig.backgroundColor,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       CommonWidgets.verticalSpace(3),
                    //       Image.asset(
                    //         'Assets/Images/logo.png',
                    //         fit: BoxFit.contain,
                    //         width: SizeConfig.blockSizeHorizontal * 30,
                    //         height: SizeConfig.blockSizeVertical * 20,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppConfig.colorPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        currentDate, // Show the current date
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 190,
                                  width: 190,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppConfig.colorPrimary,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'TODAY\'S SCHEDULE',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CircularPercentIndicator(
                                        radius: 50.0, // Size of the circle
                                        lineWidth:
                                            10.0, // Width of the circle's stroke
                                        percent: 2 /
                                            70, // Progress percentage (2 out of 70)
                                        center: Text(
                                          "2/70", // Text inside the circle
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white),
                                        ),
                                        progressColor: Colors
                                            .green, // Color of the progress line
                                        backgroundColor: Colors
                                            .blueAccent, // Background color of the circle
                                        circularStrokeCap: CircularStrokeCap
                                            .round, // Rounded edges of the stroke
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 190,
                                  width: 190,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppConfig.colorPrimary,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'EMERGENCY\'S SCHEDULE',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CircularPercentIndicator(
                                        radius: 50.0, // Size of the circle
                                        lineWidth:
                                            10.0, // Width of the circle's stroke
                                        percent: 0 /
                                            70, // Progress percentage (2 out of 70)
                                        center: Text(
                                          "0/0", // Text inside the circle
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white),
                                        ),
                                        progressColor: Colors
                                            .green, // Color of the progress line
                                        backgroundColor: Colors
                                            .blueAccent, // Background color of the circle
                                        circularStrokeCap: CircularStrokeCap
                                            .round, // Rounded edges of the stroke
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 127,
                                  decoration: BoxDecoration(
                                      color: AppConfig.colorPrimary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'COUPON SALE',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 70,
                                  width: 127,
                                  decoration: BoxDecoration(
                                      color: AppConfig.colorPrimary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'USED COUPONS',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 70,
                                  width: 127,
                                  decoration: BoxDecoration(
                                      color: AppConfig.colorPrimary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'EXPENSES',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 127,
                                  decoration: BoxDecoration(
                                      color: AppConfig.colorPrimary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'FILLED BOTTLE',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text('65',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 70,
                                  width: 127,
                                  decoration: BoxDecoration(
                                      color: AppConfig.colorPrimary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'EMPTY BOTTLE',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text('35',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 70,
                                  width: 127,
                                  decoration: BoxDecoration(
                                      color: AppConfig.colorPrimary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'CASH IN HAND',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text('80.0',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppConfig.colorPrimary,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.indigo.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                'CASH SALES', // Show the current date
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 200,
                                              width: 200,
                                              child: PieChart(
                                                dataMap: dataMap,
                                                colorList: [
                                                  Colors.green.shade300,
                                                  Colors.blue
                                                ], // Colors for the pie sections
                                                chartRadius:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .5,
                                                centerText:
                                                    "", // Optional center text
                                                chartValuesOptions:
                                                    ChartValuesOptions(
                                                  showChartValues: true,
                                                  showChartValuesInPercentage:
                                                      false,
                                                  showChartValuesOutside: false,
                                                  chartValueStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                ringStrokeWidth: 30,
                                                legendOptions: LegendOptions(
                                                    showLegends: false),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(height: 10,),
                                          Text(
                                            'CREDIT SALES',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius:
                                                    10, // Size of the circle
                                                backgroundColor: Colors
                                                    .greenAccent, // Green color for "Amount Pending"
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'AMOUNT PENDING',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 15), // Space between rows

                                          // Amount Collected
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius:
                                                    10, // Size of the circle
                                                backgroundColor: Colors
                                                    .blue, // Blue color for "Amount Collected"
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'AMOUNT COLLECTED',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: 15), // Space between rows

                                          // Total Sales
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius:
                                                    10, // Size of the circle
                                                backgroundColor: Colors
                                                    .white, // White color for "Total Sales"
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Total Sales: 140.0',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Total sales amount: 140.0',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButtons({IconData? icon, required String title, String? image}) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 25,
      height: SizeConfig.blockSizeVertical * 12.5,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: AppConfig.colorPrimary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: AppConfig.backgroundColor,
              size: 40,
            )
          else if (image != null)
            Image.asset(
              image,
              width: 50,
              height: 40,
              fit: BoxFit.contain,
            ),
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 18,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppConfig.backgroundColor,
                    fontSize: AppConfig.textCaption3Size),
              ),
            ),
          )
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

  Future<void> _getUserDetails() async {
    RestDatasource api = RestDatasource();
    UserDetailsModel userData = UserDetailsModel();
    String subUrl = "/api/get_user_detail?user_id=${AppState().userId}";
    dynamic resJson = await api.getDetails(subUrl, AppState().token);
    if (resJson['data'] != null) {
      userData = UserDetailsModel.fromJson(resJson);
      AppState().vanId = userData.data![0].vanId;
      AppState().routeId = userData.data![0].routeId;
      // print('userData.data![0].vanId');
      // print(userData.data![0].vanId);
    } else {
      if (mounted) {
        _restrict = true;
        CommonWidgets.showDialogueBox(
            context: context,
            title: "Alert",
            msg: "Van not allocated to this user");
      }
    }
  }
}
