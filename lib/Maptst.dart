// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   TextEditingController _locationController = TextEditingController();
//   double? _latitude;
//   double? _longitude;
//
//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }
//
//   void _getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _latitude = position.latitude;
//       _longitude = position.longitude;
//     });
//     _updateLocationTextField(_latitude!, _longitude!);
//   }
//
//   void _updateLocationTextField(double latitude, double longitude) {
//     _locationController.text = '$latitude, $longitude';
//   }
//
//   void _openMapScreen() async {
//     if (_latitude != null && _longitude != null) {
//       LatLng selectedLocation = LatLng(_latitude!, _longitude!);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MapScreen(
//             initialLocation: selectedLocation,
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Location'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _locationController,
//               readOnly: true, // Make the text field read-only
//               decoration: InputDecoration(
//                 hintText: 'Tap to select location',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.my_location),
//                   onPressed: _getLocation,
//                 ),
//               ),
//               // onTap: _openMapScreen,
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _openMapScreen,
//               child: Text('Open Map'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MapScreen extends StatefulWidget {
//   final LatLng initialLocation;
//
//   const MapScreen({Key? key, required this.initialLocation}) : super(key: key);
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController _mapController;
//
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map View'),
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: widget.initialLocation,
//           zoom: 14.0,
//         ),
//         markers: {
//           Marker(
//             markerId: MarkerId('selectedLocation'),
//             position: widget.initialLocation,
//           ),
//         },
//       ),
//     );
//   }
// }
//
//
//
// // import 'dart:async';
// //
// // import 'package:flutter/material.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// //
// // class MainScreen extends StatefulWidget {
// //   const MainScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MainScreen> createState() => _MainScreenState();
// // }
// //
// // class _MainScreenState extends State<MainScreen> {
// //   TextEditingController _locationController = TextEditingController();
// //
// //   void _openMapScreen() async {
// //     LatLng? selectedLocation = await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => const MapScreen(),
// //       ),
// //     );
// //
// //     if (selectedLocation != null) {
// //       _locationController.text =
// //       '${selectedLocation.latitude}, ${selectedLocation.longitude}';
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Select Location'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: TextField(
// //           controller: _locationController,
// //           readOnly: true,
// //           decoration: InputDecoration(
// //             hintText: 'Tap to select location',
// //           ),
// //           onTap: _openMapScreen,
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
//
// // class MapScreen extends StatefulWidget {
// //   const MapScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MapScreen> createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> {
// //   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
// //   static const CameraPosition _initialPos = CameraPosition(
// //     target: LatLng(50, 50),
// //     zoom: 14.4746,
// //   );
// //   final List<Marker> _markers = [];
// //   TextEditingController _searchController = TextEditingController();
// //
// //   // Method to fetch address from coordinates
// //   Future<void> _fetchAddress(LatLng position) async {
// //     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
// //     if (placemarks.isNotEmpty) {
// //       Placemark placemark = placemarks[0];
// //       String address = '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
// //       Navigator.pop(context, address); // Return address to previous screen
// //     } else {
// //       // Handle no address found
// //       Navigator.pop(context); // Return without address
// //     }
// //   }
// //
// //   Future<void> _searchAndNavigate() async {
// //     var addresses = await locationFromAddress(_searchController.text);
// //     if (addresses.isNotEmpty) {
// //       var first = addresses.first;
// //       LatLng target = LatLng(first.latitude, first.longitude);
// //       final GoogleMapController controller = await _controller.future;
// //       controller.animateCamera(CameraUpdate.newCameraPosition(
// //         CameraPosition(target: target, zoom: 14.4746),
// //       ));
// //       setState(() {
// //         _markers.add(Marker(
// //           markerId: MarkerId('search'),
// //           position: target,
// //           infoWindow: InfoWindow(
// //             title: _searchController.text,
// //           ),
// //         ));
// //       });
// //     }
// //   }
// //
// //   void _onMapTapped(LatLng position) {
// //     setState(() {
// //       _markers.add(Marker(
// //         markerId: MarkerId(position.toString()),
// //         position: position,
// //         infoWindow: InfoWindow(
// //           title: 'Selected Location',
// //         ),
// //       ));
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: TextField(
// //           controller: _searchController,
// //           decoration: InputDecoration(
// //             hintText: 'Search Place',
// //             suffixIcon: IconButton(
// //               icon: Icon(Icons.search),
// //               onPressed: _searchAndNavigate,
// //             ),
// //           ),
// //           onSubmitted: (value) => _searchAndNavigate(),
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: GoogleMap(
// //               mapType: MapType.normal,
// //               initialCameraPosition: _initialPos,
// //               markers: Set<Marker>.of(_markers),
// //               onMapCreated: (GoogleMapController controller) {
// //                 _controller.complete(controller);
// //               },
// //               onTap: _onMapTapped,
// //             ),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (_markers.isNotEmpty) {
// //                 LatLng selectedLocation = _markers.last.position;
// //                 _fetchAddress(selectedLocation);
// //               }
// //             },
// //             child: Text('Fetch Address'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
