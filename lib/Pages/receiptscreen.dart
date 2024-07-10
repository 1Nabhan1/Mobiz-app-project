import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobizapp/Components/commonwidgets.dart';
import 'package:mobizapp/Models/appstate.dart';
import 'package:mobizapp/Utilities/rest_ds.dart';
import 'package:shimmer/shimmer.dart';

import '../Models/receiptdatamodel.dart';
import '../confg/appconfig.dart';
import '../confg/sizeconfig.dart';

class ReceiptScreen extends StatefulWidget {
  static const receiptScreen = "/Receipt";
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  bool _initDone = false;
  bool _noData = false;

  ReceiptsData receiptsData = ReceiptsData();

  @override
  void initState() {
    super.initState();
    _getRecentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConfig.backgroundColor),
        title: const Text(
          'Receipts',
          style: TextStyle(color: AppConfig.backgroundColor),
        ),
        backgroundColor: AppConfig.colorPrimary,
      ),
      body: Column(
        children: [
          CommonWidgets.verticalSpace(1),
          (_initDone && !_noData)
              ? SizedBox(
                  height: SizeConfig.blockSizeVertical * 85,
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          CommonWidgets.verticalSpace(1),
                      itemCount: 10, //products.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          _productsCard(receiptsData.data![index])),
                )
              : (_noData && _initDone)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          CommonWidgets.verticalSpace(3),
                          const Center(
                            child: Text('No Data'),
                          ),
                        ])
                  : Shimmer.fromColors(
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
                            CommonWidgets.loadingContainers(
                                height: SizeConfig.blockSizeVertical * 10,
                                width: SizeConfig.blockSizeHorizontal * 90),
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _productsCard(Data data) {
    return Card(
      elevation: 1,
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 90,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          color: AppConfig.backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            trailing: Transform.rotate(
              angle: 100,
              child: const Icon(Icons.touch_app, color: Colors.transparent),
            ),
            backgroundColor: AppConfig.backgroundColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 70,
                  child: Text(
                    '${DateFormat('dd MMMM yyyy').format(DateTime.parse(data.inDate!))} ${data.inTime} | ${data.voucherNo}',
                    style: TextStyle(
                      fontSize: AppConfig.textCaption3Size,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      (data.customer!.isNotEmpty)
                          ? data.customer![0].code ?? ''
                          : '',
                      style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                          fontWeight: AppConfig.headLineWeight),
                    ),
                    Text(' | '),
                    Text(
                      (data.customer!.isNotEmpty)
                          ? data.customer![0].name ?? ''
                          : '',
                      style: TextStyle(
                          fontSize: AppConfig.textCaption3Size,
                          fontWeight: AppConfig.headLineWeight),
                    ),
                  ],
                ),
                Text(
                  'Amount: ${data.amount}',
                  style: TextStyle(
                    fontSize: AppConfig.textCaption3Size,
                  ),
                ),
                Text(
                  'Type:  ${data.collectionType}',
                  style: TextStyle(
                    fontSize: AppConfig.textCaption3Size,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Invoice'),
                        Text(
                          'Amount: ${data.amount}',
                          style: TextStyle(
                            fontSize: AppConfig.textCaption3Size,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _getRecentData() async {
    RestDatasource api = RestDatasource();
    Map<String, dynamic> response =
        await api.getDetails('/api/get_collection_report', AppState().token);

    receiptsData = ReceiptsData.fromJson(response);
    if (response['data'] != null) {
      setState(() {
        _initDone = true;
      });
    } else {
      setState(() {
        _initDone = true;
        _noData = true;
      });
    }
    print('Response Data $response');
  }
}
