import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/confg/appconfig.dart';
import 'package:shimmer/shimmer.dart';
import '../Components/commonwidgets.dart';
import '../Models/Day_close.dart';
import '../Utilities/rest_ds.dart';
import '../confg/sizeconfig.dart';


class Dayexpanding extends StatefulWidget {
  final int id;
  final String invoiceNo;

  const Dayexpanding({Key? key, required this.id, required this.invoiceNo})
      : super(key: key);

  @override
  State<Dayexpanding> createState() => _DayexpandingState();
}

class _DayexpandingState extends State<Dayexpanding> {
  late Future<DataResponse> futureDayCloseData;

  @override
  void initState() {
    super.initState();
    futureDayCloseData = fetchDayCloseData(widget.id);
  }

  Future<DataResponse> fetchDayCloseData(int id) async {
    final response = await http.get(Uri.parse(
        '${RestDatasource().BASE_URL}/api/get_dayclose_by_id?van_id=${AppState().vanId}&store_id=${AppState().storeId}&id=$id'));

    if (response.statusCode == 200) {
      return DataResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppConfig.colorPrimary,
        title: Text(
          'Reports',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<DataResponse>(
        future: futureDayCloseData,
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
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            Data dayClose = snapshot.data!.data;
            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello ${AppState().name}'),
                          RichText(
                            text: TextSpan(
                                text: 'Van  ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: ' ${dayClose.vanId}',
                                      style: TextStyle(color: Colors.grey))
                                ]),
                          ),
                          // Text(
                          //     'Scheduled ${data['sheduled']} | Visited  ${data['vist_customer']} | Not Visited ${data['non_vist_customer']} | Pending ${data['pending']}'),
                          RichText(
                            text: TextSpan(
                                text: 'Sales  ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text:
                                      '${dayClose.noOfSales} | ${dayClose.amountOfSales}',
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
                                      '${dayClose.noOfOrder} | ${dayClose.amountOfOrder}',
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
                                      '${dayClose.noOfReturns} | ${dayClose.amountOfReturns}',
                                      style: TextStyle(color: Colors.grey))
                                ]),
                          ),
                          Text('Collection'),
                          Text(
                            'Cash ${dayClose.collectionCashAmount}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                              'Cheque ${dayClose.collectionChequeAmount} | ${dayClose.collectionNoOfCheque}',
                              style: TextStyle(color: Colors.grey)),
                          Text('Last Day Balance'),
                          Text('Cash ${dayClose.lastDayBalanceAmount}',
                              style: TextStyle(color: Colors.grey)),
                          Text(
                              'Cheque ${dayClose.lastDayBalanceNoOfCheque} | ${dayClose.lastDayBalanceChequeAmount}',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cash Deposited'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Cash Handed Over'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('No of Cheque Deposited'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Cheque Deposited Amount'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('No of Cheque Handed Over'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Cheque Handed Over Amount'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Balance Cash in Hand'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('No of Cheque in Hand'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Cheque Amount in Hand'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              child: Center(
                                  child: Text('${dayClose.cashDeposited}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                  child: Text('${dayClose.cashHandOver}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                  child: Text('${dayClose.noOfChequeDeposited}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                  child: Text('${dayClose.chequeDepositedAmount}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                  child: Text('${dayClose.noOfChequeHandOver}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                  child: Text('${dayClose.chequeHandOverAmount}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                  child: Text('${dayClose.balanceCashInHand}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                  child: Text('${dayClose.noOfChequeInHand}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                  child: Text('${dayClose.chequeAmountInHand}')),
                              width: 70,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: AppConfig.colorPrimary,
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.upload,
                                size: 35,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}