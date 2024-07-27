import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:mobizapp/Components/commonwidgets.dart';
import 'package:mobizapp/Pages/Attendance.dart';
import 'package:mobizapp/Pages/DayClose.dart';
import 'package:mobizapp/Pages/ExpensesPage.dart';
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
import 'package:mobizapp/printtst.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../Models/appstate.dart';
import '../Models/userDetails.dart';
import 'Schedule_page.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {},
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
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                  onTap: () {
                    conformation(context);
                  },
                ),
                const Divider(),
                Text('v$_appVersion'),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_restrict) {
                              CommonWidgets.showDialogueBox(
                                  context: context,
                                  title: "Alert",
                                  msg: "Van not allocated to this user");
                            } else {
                              Navigator.pushNamed(
                                  context, VanStockScreen.routeName);
                            }
                          },
                          child: _iconButtons(
                              icon: Icons.directions_bus, title: 'Van Stock'),
                        ),
                        GestureDetector(
                            onTap: () {
                              if (_restrict) {
                                CommonWidgets.showDialogueBox(
                                    context: context,
                                    title: "Alert",
                                    msg: "Van not allocated to this user");
                              } else {
                                Navigator.pushNamed(
                                    context, CustomersDataScreen.routeName);
                              }
                            },
                            child: _iconButtons(
                                icon: Icons.people, title: 'Customer')),
                        GestureDetector(
                          onTap: () {
                            if (_restrict) {
                              CommonWidgets.showDialogueBox(
                                  context: context,
                                  title: "Alert",
                                  msg: "Van not allocated to this user");
                            } else {
                              Navigator.pushNamed(
                                  context, ProductsScreen.routeName);
                            }
                          },
                          child: _iconButtons(
                              icon: Icons.shopping_cart, title: 'Product'),
                        )
                      ]),
                  CommonWidgets.verticalSpace(2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Expensespage.routeName);
                          },
                          child: _iconButtons(
                              icon: Icons.menu_book, title: 'Expense')),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, HomeorderScreen.routeName);
                          },
                          child: _iconButtons(
                              icon: Icons.local_mall, title: 'Order')),
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, SaleInvoiceScrreen.routeName),
                        child: _iconButtons(
                            icon: Icons.document_scanner, title: 'Invoice'),
                      )
                    ],
                  ),
                  CommonWidgets.verticalSpace(2),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, ReceiptScreen.receiptScreen),
                          child: _iconButtons(
                              icon: Icons.receipt, title: 'Receipt'),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, HomereturnScreen.routeName);
                            },
                            child: _iconButtons(
                                icon: Icons.inventory, title: 'Return')),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SchedulePage.routeName);
                          },
                          child: _iconButtons(
                              icon: Icons.calendar_today, title: 'Schedule'),
                        ),
                      ]),
                  CommonWidgets.verticalSpace(2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Attendance.routeName);
                          },
                          child: _iconButtons(
                              icon: Icons.groups, title: 'Attendance')),
                      GestureDetector(
                        onTap: () {
                          if (_restrict) {
                            CommonWidgets.showDialogueBox(
                                context: context,
                                title: "Alert",
                                msg: "Van not allocated to this user");
                          } else {
                            Navigator.of(context)
                                .pushNamed(VanStockRequestsScreen.routeName);
                          }
                        },
                        child: _iconButtons(
                            icon: Icons.question_answer,
                            title: 'Van Stock Request'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, OffLoadRequestScreen.routeName);
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Visitspage.routeName);
                          },
                          child: _iconButtons(
                              icon: Icons.handshake, title: 'Visit')),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(VanTransfer.routeName);
                        },
                        child: _iconButtons(
                            image: 'Assets/Images/van stock.png',
                            title: 'Transfer'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Dayclose.routeName);
                        },
                        child: _iconButtons(
                            image: 'Assets/Images/day close.png',
                            title: 'Day close'),
                      )
                    ],
                  )
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
