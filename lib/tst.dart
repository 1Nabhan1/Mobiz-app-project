import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(PlaceSearchApp());
}

class PlaceSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlaceSearchPage(),
    );
  }
}

class PlaceSearchPage extends StatefulWidget {
  @override
  _PlaceSearchPageState createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  TextEditingController _placeController = TextEditingController();
  String latitude = '';
  String longitude = '';
  bool isLoading = false;

  // Function to fetch latitude and longitude based on a place name
  Future<void> fetchLatLong(String place) async {
    final String apiKey = 'AIzaSyD3t6H9yoFcwZV9a9_uQsKy7WAJjViZGrs'; // Replace with your Google API Key
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$place&key=$apiKey';

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final lat = data['results'][0]['geometry']['location']['lat'];
          final lng = data['results'][0]['geometry']['location']['lng'];

          setState(() {
            latitude = lat.toString();
            longitude = lng.toString();
          });
        } else {
          print('Error: ${data['status']}');
          setState(() {
            latitude = 'Not Found';
            longitude = 'Not Found';
          });
        }
      } else {
        print('Failed to get response from API');
        setState(() {
          latitude = 'Error';
          longitude = 'Error';
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        latitude = 'Error';
        longitude = 'Error';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Location'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text field for place input
            TextField(
              controller: _placeController,
              decoration: InputDecoration(
                labelText: 'Enter place',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Search button
            ElevatedButton(
              onPressed: () {
                if (_placeController.text.isNotEmpty) {
                  fetchLatLong(_placeController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a place name')),
                  );
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text('Search'),
            ),
            SizedBox(height: 20),

            // Display latitude and longitude
            if (latitude.isNotEmpty && longitude.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Latitude: $latitude',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Longitude: $longitude',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
