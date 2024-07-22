// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Zoom Drawer Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();
//
//   void _toggleDrawer() {
//     _zoomDrawerController.toggle?.call();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ZoomDrawer(
//       controller: _zoomDrawerController,
//       menuScreen: MenuScreen(),
//       mainScreen: MainScreen(toggleDrawer: _toggleDrawer),
//       borderRadius: 24.0,
//       showShadow: true,
//       angle: -12.0,
//       drawerShadowsBackgroundColor: Colors.grey,
//       slideWidth: MediaQuery.of(context).size.width * 0.65,
//     );
//   }
// }
//
// class MenuScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.yellow,
//     );
//   }
// }
//
// class MainScreen extends StatelessWidget {
//   final VoidCallback toggleDrawer;
//
//   const MainScreen({Key? key, required this.toggleDrawer}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.pink,
//       child: Center(
//         child: ElevatedButton(
//           onPressed: toggleDrawer,
//           child: Text("Toggle Drawer"),
//         ),
//       ),
//     );
//   }
// }
