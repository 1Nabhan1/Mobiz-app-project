import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Models/customerdetails.dart';
import 'package:mobizapp/Pages/customerdetailscreen.dart';
import 'package:mobizapp/Pages/customerregistration.dart';
import 'package:mobizapp/Pages/salesscreen.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:shimmer/shimmer.dart';

import '../Components/commonwidgets.dart';
import '../Maptst.dart';
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
  @override
  void initState() {
    super.initState();
    getCustomerDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.colorPrimary,
        iconTheme: const IconThemeData(color: AppConfig.backButtonColor),
        title: const Text(
          'Shops',
          style: TextStyle(color: AppConfig.backButtonColor),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, CustomerRegistration.routeName);
            },
            child: const Icon(
              Icons.add,
              size: 30,
              color: AppConfig.backgroundColor,
            ),
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
                      itemCount: customer.data!.length!,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          _customersCard(customer.data![index]),
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
      String coordinates = data.location??'';

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
        Navigator.of(context)
            .pushNamed(CustomerDetailsScreen.routeName, arguments: {
          'name': data.name!,
          'address': data.address,
          'phone': data.contactNumber,
          'mail': data.email,
          'customerType': '',
          'days': data.creditDays,
          'creditLimit': data.creditLimit,
          'paymentTerms': data.paymentTerms,
          'provinceId':data.provinceId,
          'routeId':data.routeId,
          'trn':data.trn,
          'whatsappNumber':data.whatsappNumber,
          'code':data.code,
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
                      image: const NetworkImage(
                          'https://www.vecteezy.com/vector-art/5337799-icon-image-not-found-vector'),
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
                        GestureDetector(onTap: _openMapScreen,
                          child: const Icon(
                            CupertinoIcons.map,
                            size: 20,
                          ),
                        )
                      ]),
                    ),
                    Text(
                      'Contact:${data.contactNumber}',
                      style: TextStyle(fontSize: AppConfig.textCaption3Size),
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

  Future<void> getCustomerDetails() async {
    RestDatasource api = RestDatasource();

    dynamic resJson = await api.getDetails(
        '/api/get_customer?store_id=${AppState().storeId}&route_id=${AppState().routeId}',
        AppState().token);
    print('Cust $resJson');
    if (resJson['data'] != null && resJson['data'].length > 0) {
      customer = CustomerData.fromJson(resJson);

      setState(() {
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
