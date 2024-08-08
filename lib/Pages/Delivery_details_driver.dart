import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../confg/appconfig.dart';

class DeliveryDetailsDriver extends StatefulWidget {
  static const routeName = "/ProductDetailsDriver";

  const DeliveryDetailsDriver({super.key});

  @override
  State<DeliveryDetailsDriver> createState() => _DeliveryDetailsDriverState();
}

class _DeliveryDetailsDriverState extends State<DeliveryDetailsDriver> {
  List<bool> isSelected = [false, false, false];
  void _onContainerTap(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        if (i == index) {
          isSelected[i] = true;
        } else {
          isSelected[i] = false;
        }
      }
    });
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
              }))
        ],
      ),
    );
  }
}
