import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Models/Visit_reason_model.dart';

class VisitReasonService {
  static const String url =
      'https://mobiz-api.yes45.in/api/get_visit_reason?store_id=10';

  Future<VisitReasonResponse> fetchVisitReasons() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return VisitReasonResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load visit reasons');
    }
  }
}

class VisitReasonScreen extends StatefulWidget {
  @override
  _VisitReasonScreenState createState() => _VisitReasonScreenState();
}

class _VisitReasonScreenState extends State<VisitReasonScreen> {
  late Future<VisitReasonResponse> futureVisitReason;

  @override
  void initState() {
    super.initState();
    futureVisitReason = VisitReasonService().fetchVisitReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visit Reasons'),
      ),
      body: Center(
        child: FutureBuilder<VisitReasonResponse>(
          future: futureVisitReason,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  final visitReason = snapshot.data!.data[index];
                  return Text(visitReason.reason??'no data');
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
