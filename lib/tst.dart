// ElevatedButton(
// style: ButtonStyle(
// backgroundColor: MaterialStateProperty.all(AppConfig.colorPrimary),
// ),
// onPressed: () {
// Navigator.pushNamed(
// context,Stock_Name.routeName,
// arguments: {'id': data.id}
// );
// print(data.id);
// },
// child: Text(
// "Add",
// style: TextStyle(color: Colors.white),
// ),
// )



// void postDataComplete() async {
//   var url = Uri.parse('${RestDatasource().BASE_URL}/api/stock-take.save');
//   List<int> quantities = [];
//   List<int> selectedUnitIds = [];
//
//   for (int index = 0; index < cartItems.length; index++) {
//     String? qty = qtys[index];
//     int quantity = qty != null ? int.parse(qty) : 1;
//     quantities.add(quantity);
//     String? selectedUnitName = cartItems[index].selectedUnitName;
//     int selectedUnitId;
//     if (selectedUnitName != null) {
//       selectedUnitId = cartItems[index]
//           .units
//           .firstWhere((unit) => unit.name == selectedUnitName)
//           .unit!;
//     } else {
//       selectedUnitId = cartItems[index].units.first.unit!;
//     }
//
//     selectedUnitIds.add(selectedUnitId);
//   }
//   var data = {
//     'id': dataId,
//     'van_id': AppState().vanId,
//     'store_id': AppState().storeId,
//     'user_id': AppState().userId,
//     'item_id': cartItems.map((item) => item.id).toList(),
//     'quantity': quantities,
//     'unit': selectedUnitIds,
//   };
//   // print(_remarksText);
//   // print('wwwwwwwwwwwwwwwwwwwwwwwww');
//   var body = json.encode(data);
//
//   var response = await http.post(
//     url,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: body,
//   );
//   print("DAATA$data");
//
//   if (response.statusCode == 200) {
//     print("SIUU$data");
//     print('Post successful');
//     if (mounted) {
//       CommonWidgets.showDialogueBox(
//           context: context, title: "Alert", msg: "Created Successfully")
//           .then(
//             (value) {
//           clearCart();
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()), // Replace `HomePage` with your actual home page widget.
//                 (route) => false, // Remove all previous routes.
//           );
//         },
//       );
//     }
//     print(response.body);
//   } else {
//     print('Post failed with status: ${response.statusCode}');
//     print(response.body);
//   }
// }