import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Models/customerdetails.dart';
import 'package:mobizapp/Pages/customerdetailscreen.dart';
import 'package:mobizapp/Pages/customerregistration.dart';
import 'package:mobizapp/Pages/salesscreen.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart'as http;
import '../Components/commonwidgets.dart';
import '../Models/Store_model.dart';
import '../confg/sizeconfig.dart';
import 'Mapscreen.dart';

class CustomersDataScreen extends StatefulWidget {
  static const routeName = "/CustomersScreen";
  const CustomersDataScreen({super.key});

  @override
  State<CustomersDataScreen> createState() => _CustomersDataScreenState();
}

class _CustomersDataScreenState extends State<CustomersDataScreen> {
  CustomerData customer = CustomerData();
  bool _initDone = false;
  bool _nodata = false;
  List<Data> filteredCustomers = [];
  String searchQuery = '';
  bool _isSearching = false;
  bool showFields = false;

  @override
  void initState() {
    super.initState();
    getCustomerDetails();
    requestLocationPermission();
    fetchStoreDetail() .then((storeDetail) {
      if (storeDetail != null && storeDetail.comapny_id == 5) {
        setState(() {
          showFields = true; // Show fields for company_id 5
        });
      } else {
        setState(() {
          showFields = false; // Hide fields otherwise
        });
      }
      print("SSSSS${storeDetail!.comapny_id}");
      print("Fields$showFields");
    });
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        getCustomerDetails();
      } else {
        Fluttertoast.showToast(
          msg: "Location permission is required to use this feature.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      getCustomerDetails();
    }
  }

  void _searchCustomer(String query) {
    final filteredList = customer.data!.where((customer) {
      final customerName = customer.name?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return customerName.contains(searchLower);
    }).toList();

    setState(() {
      searchQuery = query;
      filteredCustomers = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        iconTheme: const IconThemeData(color: AppConfig.backButtonColor),
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  _searchCustomer(query);
                },
                style: const TextStyle(color: Colors.white),
              )
            : const Text(
                'Shops',
                style: TextStyle(color: AppConfig.backButtonColor),
              ),
        actions: [
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      searchQuery = '';
                      filteredCustomers = customer.data!;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search, size: 30),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
              color: AppConfig.backgroundColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, CustomerRegistration.routeName);
            },
          ),
          CommonWidgets.horizontalSpace(3),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (_initDone && !_nodata)
                ? SizedBox(
                    height: SizeConfig.blockSizeVertical * 78,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          CommonWidgets.verticalSpace(1),
                      itemCount: (searchQuery.isEmpty
                              ? customer.data!
                              : filteredCustomers)
                          .length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => _customersCard(
                          searchQuery.isEmpty
                              ? customer.data![index]
                              : filteredCustomers[index]),
                    ),
                  )
                : (_nodata && _initDone)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            CommonWidgets.verticalSpace(3),
                            const Center(
                              child: Text('No Data'),
                            ),
                          ])
                    : Shimmer.fromColors(
                        baseColor:
                            AppConfig.buttonDeactiveColor.withOpacity(0.1),
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
                      ),
          ],
        ),
      ),
    );
  }

  Widget _customersCard(Data data) {
    void _openMapScreen() async {
      String coordinates = data.location ?? '';

      if (coordinates.isEmpty) {
        Fluttertoast.showToast(
          msg: "Location are not available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
      List<String> latLngStr = coordinates.split(', ');
      double latitude = double.parse(latLngStr[0]);
      double longitude = double.parse(latLngStr[1]);
      LatLng selectedLocation = LatLng(latitude, longitude);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(
            initialLocation: selectedLocation,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(CustomerDetailsScreen.routeName, arguments: {
          'name': data.name!,
          'address': data.address,
          'phone': data.contactNumber,
          'mail': data.email,
          'location': data.location,
          'cust_image':data.img,
          'customerType': '',
          'days': data.creditDays,
          'creditLimit': data.creditLimit,
          'paymentTerms': data.paymentTerms,
          'provinceId': data.provinceId,
          'routeId': data.routeId,
          'price_group_id':data.pricegroupId,
          'trn': data.trn,
          'whatsappNumber': data.whatsappNumber,
          'code': data.code,
          'balance': '',
          'total': '',
          'id': data.id,
        });
      },
      child: Card(
        elevation: 3,
        child: Container(
          width: SizeConfig.blockSizeHorizontal * 90,
          decoration: const BoxDecoration(
            color: AppConfig.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: FadeInImage(
                      image: NetworkImage(
                          'http://68.183.92.8:3696/uploads/customer/cust_image/${data.img}'),
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
                CommonWidgets.horizontalSpace(3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 80,
                      child: Text(
                        (data.name ?? '').toUpperCase(),
                        style: TextStyle(
                            fontSize: AppConfig.paragraphSize,
                            fontWeight: AppConfig.headLineWeight),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 70,
                      child: Row(children: [
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 60,
                          child: Text(
                            'Address:${data.address ?? ''}',
                            style:
                                TextStyle(fontSize: AppConfig.textCaption3Size),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _openMapScreen,
                          child: Image.asset(
                            'Assets/Images/vecteezy_google-maps-icon_16716478.png',
                            fit: BoxFit.cover,
                            height: 30,
                          ),
                        )
                      ]),
                    ),
                    Text(
                      'Contact:${data.contactNumber}',
                      style: TextStyle(fontSize: AppConfig.textCaption3Size),
                    ),
                    Visibility(
                      visible: showFields,
                      child: Column(
                        children: [
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 72,
                            child: Text(
                              'Building: ${data.building ?? 'N/A'}',
                              style: TextStyle(fontSize: AppConfig.textCaption3Size),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 72,
                            child: Text(
                              'Flat Number: ${data.flatNo ?? 'N/A'}',
                              style: TextStyle(fontSize: AppConfig.textCaption3Size),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<StoreDetail?> fetchStoreDetail() async {
    final url = Uri.parse('${RestDatasource().BASE_URL}/api/get_store_detail?store_id=${AppState().storeId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("data:::${data['company_id']}");
        // print(showFields);
        if (data['company_id'] == 5) {
          setState(() {
            showFields = true;
          });
        } else {
          setState(() {
            showFields = false;
          });
        }
        return StoreDetail.fromJson(data);
      } else {
        // Handle error
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> getCustomerDetails() async {
    RestDatasource api = RestDatasource();

    dynamic resJson = await api.getDetails(
        '/api/get_customer?store_id=${AppState().storeId}&route_id=${AppState().routeId}',
        AppState().token);
    print('Cust $resJson');
    if (resJson['data'] != null && resJson['data'].length > 0) {
      customer = CustomerData.fromJson(resJson);

      setState(() {
        customer = CustomerData.fromJson(resJson);
        filteredCustomers = customer.data!;
        _initDone = true;
      });
    } else {
      setState(() {
        _nodata = true;
        _initDone = true;
      });
    }
  }
}
