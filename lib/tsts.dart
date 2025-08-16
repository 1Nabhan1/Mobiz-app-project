import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<DayClosePendingResponse?> fetchDayClosePendingData(int userId, int storeId) async {
  final String url = 'http://68.183.92.8:3699/api/get_dayclose_user_pending?user_id=$userId&store_id=$storeId';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DayClosePendingResponse.fromJson(jsonData);
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
  return null;
}


class PendingApprovalPage extends StatefulWidget {
  @override
  _PendingApprovalPageState createState() => _PendingApprovalPageState();
}

class _PendingApprovalPageState extends State<PendingApprovalPage> {
  late Future<DayClosePendingResponse?> _futureResponse;
  bool _isButtonEnabled = true; // Track button state

  @override
  void initState() {
    super.initState();
    _futureResponse = fetchDayClosePendingData(27, 10); // Replace with actual userId and storeId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Approvals'),
      ),
      body: FutureBuilder<DayClosePendingResponse?>(
        future: _futureResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            // Update button state based on the response data
            if (data.data == 'pending') {
              _isButtonEnabled = false; // Disable the button if status is 'pending'
            } else {
              _isButtonEnabled = true; // Enable the button if status is not 'pending'
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data: ${data.data}'),
                  SizedBox(height: 10),
                  Text('Success: ${data.success}'),
                  SizedBox(height: 10),
                  Text('Messages:'),
                  ...data.messages.map((msg) => Text('- $msg')).toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isButtonEnabled ? _onButtonPressed : null, // Disable button if _isButtonEnabled is false
                    child: Text(_isButtonEnabled ? 'Proceed' : 'Pending Approval'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }

  void _onButtonPressed() {
    // Add your button press logic here
    print("Button pressed!");
  }
}

class DayClosePendingResponse {
  final String data;
  final bool success;
  final List<String> messages;

  DayClosePendingResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory DayClosePendingResponse.fromJson(Map<String, dynamic> json) {
    return DayClosePendingResponse(
      data: json['data'],
      success: json['success'],
      messages: List<String>.from(json['messages']),
    );
  }
}
