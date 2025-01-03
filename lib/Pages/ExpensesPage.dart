// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'package:shimmer/shimmer.dart';
// import 'dart:convert';
// import '../Components/commonwidgets.dart';
// import '../Models/Expense_model.dart';
// import '../Models/appstate.dart';
// import '../Utilities/rest_ds.dart';
// import '../confg/appconfig.dart';
// import '../confg/sizeconfig.dart';
// import 'Expense_add.dart';
//
// class Expensespage extends StatefulWidget {
//   static const routeName = "/Expensespage";
//
//   Expensespage({Key? key}) : super(key: key);
//
//   @override
//   State<Expensespage> createState() => _ExpensespageState();
// }
//
// class _ExpensespageState extends State<Expensespage> {
//   late Future<List<ExpenseDetail>> futureExpenseDetails;
//   late List<bool> isExpandedList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     futureExpenseDetails = fetchExpenseDetails(AppState().storeId!);
//   }
//
//   Future<List<ExpenseDetail>> fetchExpenseDetails(int storeId) async {
//     final response = await http.get(Uri.parse(
//         '${RestDatasource().BASE_URL}/api/get_expense_detail?store_id=${storeId}&user_id=${AppState().userId}'));
//
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       List<dynamic> data = jsonResponse['data'];
//
//       // Initialize isExpandedList with false for each item
//       isExpandedList = List.generate(data.length, (index) => false);
//
//       return data.map((item) => ExpenseDetail.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to load expense details');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppConfig.colorPrimary,
//         title: Text(
//           'Expenses',
//           style: TextStyle(color: AppConfig.backgroundColor),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => ExpenseAdd()));
//               },
//               child: Icon(
//                 Icons.add,
//                 color: Colors.white,
//               ),
//             ),
//           )
//         ],
//       ),
//       body: FutureBuilder<List<ExpenseDetail>>(
//         future: futureExpenseDetails,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: Shimmer.fromColors(
//                 baseColor: AppConfig.buttonDeactiveColor.withOpacity(0.1),
//                 highlightColor: AppConfig.backButtonColor,
//                 child: ListView.builder(
//                   itemCount: 6,
//                   itemBuilder: (context, index) =>
//                       CommonWidgets.loadingContainers(
//                     height: SizeConfig.blockSizeVertical * 10,
//                     width: SizeConfig.blockSizeHorizontal * 90,
//                   ),
//                 ),
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 var expenseDetail = snapshot.data![index];
//                 bool isExpanded = isExpandedList[index];
//                 String detailText = '';
//
//                 if (expenseDetail.status == 'Approved') {
//                   detailText = expenseDetail.approvedReason ??
//                       'No approval reason provided';
//                 } else if (expenseDetail.status == 'Rejected') {
//                   detailText = expenseDetail.rejectedReason ??
//                       'No rejection reason provided';
//                 }
//
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isExpandedList[index] = !isExpandedList[index];
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                     child: Card(
//                       elevation: 3,
//                       child: Container(
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: AppConfig.backgroundColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Flexible(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '${expenseDetail.inDate} | ${expenseDetail.invoiceNo ?? ""}',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         Text(
//                                             'Amount : ${expenseDetail.amount}'),
//                                         Text(
//                                             'Vat Amount : ${expenseDetail.vatAmount}'),
//                                         Text(
//                                             'Total Amount : ${expenseDetail.totalAmount}'),
//                                         // if (expenseDetail.description == '')
//                                         Text(
//                                           '${expenseDetail.expense.isNotEmpty ? expenseDetail.expense[0].name : ""} ${expenseDetail.description == '' ? '' : '| ${expenseDetail.description}'}',
//                                         ),
//                                         if (expenseDetail.status != 'Pending')
//                                           Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text("Remarks: "),
//                                               Expanded(
//                                                 child: SingleChildScrollView(
//                                                   scrollDirection:
//                                                       Axis.horizontal,
//                                                   child: Text(
//                                                     detailText,
//                                                     // maxLines: 1,
//                                                     overflow: TextOverflow.clip,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   Text(expenseDetail.status),
//                                 ],
//                               ),
//                               if (isExpandedList[index])
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 10.0),
//                                   child: Column(
//                                     children: [
//                                       Wrap(
//                                         spacing: 10,
//                                         runSpacing: 10,
//                                         children: expenseDetail.documents
//                                             .map((document) {
//                                           return Image.network(
//                                             '${RestDatasource().BASE_URL}/uploads/expense/${document.documentName}',
//                                             height: 100,
//                                             width: 100,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                               return Icon(
//                                                 Icons.broken_image,
//                                                 size: 100,
//                                                 color: Colors.grey,
//                                               );
//                                             },
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
