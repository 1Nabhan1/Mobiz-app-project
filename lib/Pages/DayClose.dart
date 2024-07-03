import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:shimmer/shimmer.dart';

import '../Components/commonwidgets.dart';
import '../Utilities/rest_ds.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class Dayclose extends StatefulWidget {
  static const routeName = "/Dayclose";
  const Dayclose({super.key});

  @override
  State<Dayclose> createState() => _DaycloseState();
}

class _DaycloseState extends State<Dayclose> {
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchDayCloseOutstanding();
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
            'Day close',
            style: TextStyle(color: AppConfig.backgroundColor),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: AppConfig.buttonDeactiveColor.withOpacity(0.1),
                highlightColor: AppConfig.backButtonColor,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) =>
                      CommonWidgets.loadingContainers(
                    height: SizeConfig.blockSizeVertical * 40,
                    width: SizeConfig.blockSizeHorizontal * 40,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final data = snapshot.data!['data'];
              return Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello Sales'),
                          RichText(
                            text: TextSpan(
                                text: 'Van  ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: ' ${data['van']}',
                                      style: TextStyle(color: Colors.grey))
                                ]),
                          ),
                          Text(
                              'Scheduled ${data['sheduled']} | Visited  ${data['vist_customer']} | Not Visited ${data['non_vist_customer']} | Pending ${data['pending']}'),
                          RichText(
                            text: TextSpan(
                                text: 'Sales  ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text:
                                          '${data['no_of_sales']} | ${data['amount_of_sales']}',
                                      style: TextStyle(color: Colors.grey))
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Orders  ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text:
                                          '${data['no_of_sales_order']} | ${data['amount_of_sales_order']}',
                                      style: TextStyle(color: Colors.grey))
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Returns  ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text:
                                          '${data['no_of_sales_return']} | ${data['amount_of_sales_return']}',
                                      style: TextStyle(color: Colors.grey))
                                ]),
                          ),
                          Text('Collection'),
                          Text(
                            'Cash ${data['collection_cash']}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                              'Cheque ${data['collection_cheque']} | ${data['collection_no_cheque']}',
                              style: TextStyle(color: Colors.grey)),
                          Text('Last Day Balance'),
                          Text('Cash ${data['last_day_balance_amount']}',
                              style: TextStyle(color: Colors.grey)),
                          Text(
                              'Cheque ${data['last_day_balance_no_of_cheque']} | ${data['last_day_balance_cheque_amount']}',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    )
                  ],
                ),
              );
            } else {
              return Text('No data available');
            }
          },
        ));
  }

  Future<Map<String, dynamic>> fetchDayCloseOutstanding() async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_dayclose_outstanding?van_id=${AppState().vanId}&store_id=${AppState().storeId}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
