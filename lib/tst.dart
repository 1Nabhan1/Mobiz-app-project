import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasData = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final url =
        'http://68.183.92.8:3699/api/get_product_return_type?store_id=10';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _hasData = responseData['data'].isNotEmpty;
        _isLoading = false;
      });
    } else {
      // Handle the error
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Data Check')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _hasData
                ? Container() // No button if data is present
                : ElevatedButton(
                    onPressed: () {
                      // Define the button action here
                    },
                    child: Text('No Data Available'),
                  ),
      ),
    );
  }
}
