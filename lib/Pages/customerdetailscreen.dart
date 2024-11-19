import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobizapp/Components/commonwidgets.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Pages/CustomeSOA.dart';
import 'package:mobizapp/Pages/CustomerStock.dart';
import 'package:mobizapp/Pages/CustomerVisit.dart';
import 'package:mobizapp/Pages/customerorderdetail.dart';
import 'package:mobizapp/Pages/customerregistration.dart';
import 'package:mobizapp/Pages/paymentcollection.dart';
import 'package:mobizapp/Pages/saleinvoices.dart';
import 'package:mobizapp/Pages/salesscreen.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:mobizapp/confg/sizeconfig.dart';
import 'package:mobizapp/vanstockselactpro_tst.dart';

import '../Utilities/rest_ds.dart';
import '../sales_screen.dart';
import 'Copy/Copy.dart';
import 'Total_sales.dart';
import 'customerreturndetails.dart';

class CustomerDetailsScreen extends StatefulWidget {
  static const routeName = "/customerdetailsscreen";
  const CustomerDetailsScreen({
    super.key,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  Timer? _timer;

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    _fetchData();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchData());
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _showButton = false;
  String _message = "";
  String _data = '';
  String? name;
  String? address;
  String? email;
  String? phone;
  String? whatsappNumber;
  String? customerType;
  String? location;
  int? provinceId;
  int? routeId;
  int?pricegroupId;
  int? id;
  String? img;
  String? code;
  String? trn;
  int? creditDays;
  String? creditBalance;
  String? totalOutstanding;
  String? paymentTerms;
  int? creditLimit;
  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
          'Pending Offload request found, Please cancel or approve to Proceed'),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic>? params =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      name = params!['name'];
      address = params['address'];
      phone = params!['phone'];
      location = params['location'];
      whatsappNumber = params['whatsappNumber'];
      customerType = params!['customerType'];
      creditDays = params['days'];
      creditBalance = params['balance'];
      totalOutstanding = params['total'];
      trn = params['trn'];
      img = params['cust_image'];
      paymentTerms = params['paymentTerms'];
      provinceId = params['provinceId'];
      routeId = params['routeId'];
      creditLimit = params!['creditLimit'];
      email = params!['mail'];
      id = params['id'];
      code = params['code'];
      pricegroupId = params['price_group_id'];


    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        title: const Text(
          'Customer',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (name ?? "").toUpperCase(),
                style: TextStyle(
                    fontSize: AppConfig.headLineSize,
                    fontWeight: AppConfig.headLineWeight),
              ),
              Row(
                children: [
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 35,
                    height: SizeConfig.blockSizeVertical * 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FadeInImage(
                        image: NetworkImage(
                            'http://68.183.92.8:3696/uploads/customer/cust_image/$img'),
                        placeholder:
                            const AssetImage('Assets/Images/no_image.jpg'),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('Assets/Images/no_image.jpg',
                              fit: BoxFit.fitWidth);
                        },
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  CommonWidgets.horizontalSpace(2),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: SizeConfig.blockSizeVertical * 17,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CommonWidgets.verticalSpace(1),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            SizedBox(
                                width: SizeConfig.blockSizeHorizontal * 40,
                                child: Text(address ?? '')),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 40,
                              child: Text(phone ?? ''),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.mail,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 40,
                              child: Text(email ?? ''),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Customer Type: $paymentTerms',
                    style: TextStyle(
                        fontWeight: AppConfig.headLineWeight,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                  CommonWidgets.horizontalSpace(2),
                  Text(
                    customerType ?? '',
                    style: TextStyle(fontWeight: AppConfig.headLineWeight),
                  ),
                ],
              ),
              CommonWidgets.verticalSpace(2),
              Row(
                children: [
                  Text(
                    'Credit Days:',
                    style: TextStyle(
                        fontWeight: AppConfig.headLineWeight,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                  CommonWidgets.horizontalSpace(2),
                  Text(
                    creditDays.toString(),
                    style: TextStyle(fontWeight: AppConfig.headLineWeight),
                  ),
                ],
              ),
              CommonWidgets.verticalSpace(2),
              Row(
                children: [
                  Text(
                    'Credit Limit:',
                    style: TextStyle(
                        fontWeight: AppConfig.headLineWeight,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                  CommonWidgets.horizontalSpace(2),
                  Text(
                    creditLimit.toString(),
                    style: TextStyle(fontWeight: AppConfig.headLineWeight),
                  ),
                  CommonWidgets.horizontalSpace(2),
                  Text(
                    'Credit Balance: ${int.tryParse(_data) != null ? (int.tryParse(_data)! - creditLimit!).toString() : ''}',
                    style: TextStyle(
                      fontWeight: AppConfig.headLineWeight,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              CommonWidgets.verticalSpace(2),
              Row(
                children: [
                  Text(
                    'Total Outstanding: ${_data == '[]' ? '' : _data}',
                    style: TextStyle(
                        fontWeight: AppConfig.headLineWeight,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                  CommonWidgets.horizontalSpace(2),
                  Text(
                    totalOutstanding ?? '',
                    style: TextStyle(fontWeight: AppConfig.headLineWeight),
                  ),
                ],
              ),
              CommonWidgets.verticalSpace(2),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: PageView(
                  children:[
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, CustomerRegistration.routeName,
                                  arguments: {
                                    'name': name,
                                    'address': address,
                                    'phone': phone,
                                    'whatsappNumber': whatsappNumber,
                                    'email': email,
                                    'location': location,
                                    'payment_terms': customerType,
                                    'credit_days': creditDays,
                                    'credit_limit': creditLimit,
                                    'paymentTerms': paymentTerms,
                                    'trn': trn,
                                    'cust_image':img,
                                    'code': code,
                                    'provinceId': provinceId,
                                    'routeId': routeId,
                                    'id': id,
                                  });
                            },
                            child: _iconButtons(icon: Icons.person_add, title: 'Edit')),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, SOA.routeName, arguments: {
                                'customerId': id,
                                'name': name,
                                'address': address,
                                'code': code,
                                'paymentTerms': paymentTerms
                              });
                            },
                            child: _iconButtons(
                                icon: Icons.settings_suggest, title: 'SOA')),
                        InkWell(
                            onTap: () {
                              _showButton
                                  ? _showSnackBar(context)
                                  : Navigator.of(context)
                                  .pushNamed(CopyScreen.routeName, arguments: {
                                'customerId': id,
                                'name': name,
                                'price_group_id':pricegroupId,
                                'code': code,
                                'paymentTerms': paymentTerms,
                                'outstandamt': _data
                              });
                            },
                            child: _iconButtons(
                                icon: Icons.point_of_sale, title: 'Sale')),
                      ]),
                      CommonWidgets.verticalSpace(2),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        InkWell(
                            onTap: () {
                              _showButton
                                  ? _showSnackBar(context)
                                  : Navigator.of(context)
                                  .pushNamed(SalesScreen.routeName, arguments: {
                                'customerId': id,
                                'name': name,
                              });
                            },
                            child: _iconButtons(
                                icon: Icons.point_of_sale, title: 'Sales')),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Customerreturndetail.routeName, arguments: {
                                'customerId': id,
                                'name': name,
                                'code': code,
                                'paymentTerms': paymentTerms,
                                'outstandamt': _data
                              });
                            },
                            child:
                            _iconButtons(icon: Icons.inventory, title: 'Return')),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PaymentCollectionScreen.routeName,
                                  arguments: {
                                    'customerId': id,
                                    'name': name,
                                    'code': code,
                                    'paymentTerms': paymentTerms,
                                    'outstandamt': _data
                                  });

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => PaymentCollectionScreen(
                              //         id: 'customer',
                              //         code: 'code',
                              //         name: 'name',
                              //       ),
                              //     ));
                            },
                            child: _iconButtons(
                                icon: Icons.payments, title: 'Payment Collection'))
                      ]),
                      CommonWidgets.verticalSpace(2),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, CustomerStock.routeName,arguments: {
                              'customerId': id,
                            });
                          },
                          child: _iconButtons(
                              icon: Icons.storefront_rounded, title: 'Customer Stock'),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, CustomerVisit.routeName,
                                  arguments: {
                                    'name': name,
                                    'code': code,
                                    'email': email,
                                    'paymentTerms': paymentTerms,
                                    'address': address,
                                    'phone': phone,
                                    'id': id,
                                  });
                            },
                            child: _iconButtons(icon: Icons.bar_chart, title: 'Visit')),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, TotalSales.routeName,
                                  arguments: {
                                    'id': id,
                                  });
                            },
                            child: _iconButtons(
                                icon: Icons.pie_chart, title: 'Total Sales'))
                      ]),
                    ],
                  ),

                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Customerorderdetail.routeName, arguments: {
                                    'customerId': id,
                                    'name': name,
                                    'code': code,
                                    'paymentTerms': paymentTerms
                                  });
                                },
                                child:
                                _iconButtons(icon: Icons.shopping_bag, title: 'Order'))
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
      ),
    );
  }

  Widget _iconButtons({required IconData icon, required String title}) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 22,
      height: SizeConfig.blockSizeVertical * 11,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: AppConfig.colorPrimary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppConfig.backgroundColor,
            size: 40,
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

  Future<void> _fetchData() async {
    final url =
        '${RestDatasource().BASE_URL}/api/vanoffloadrequest.pending?store_id=${AppState().storeId}&van_id=${AppState().vanId}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _showButton = data['success'] ?? false;
          _message = _showButton ? "" : "Button is hidden due to API response.";
        });
      } else {
        // Handle server errors or other HTTP errors
        setState(() {
          _showButton = false;
          _message = "Failed to fetch data.";
        });
      }
    } catch (e) {
      // Handle other errors, such as network issues
      setState(() {
        _showButton = false;
        _message = "An error occurred: $e";
      });
    }
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(Uri.parse(
          '${RestDatasource().BASE_URL}/api/get_sales_pending_outstanding?customer_id=$id'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          _data = jsonResponse['data'].toString();
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
