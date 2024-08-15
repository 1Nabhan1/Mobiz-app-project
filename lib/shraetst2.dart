import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Models/paymentcollectionclass.dart';

class HomePagevv extends StatefulWidget {
  @override
  _HomePagevvState createState() => _HomePagevvState();
}

class _HomePagevvState extends State<HomePagevv> {
  Future<ApiResponse> fetchInvoices() async {
    final response = await http.get(Uri.parse(
        'http://68.183.92.8:3699/api/get_invoice_outstanding_detail?customer_id=38'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  late Future<ApiResponse> futureInvoices;
  List<String> enteredValues = [];

  @override
  void initState() {
    super.initState();
    futureInvoices = fetchInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView.builder with Dialog'),
      ),
      body: FutureBuilder<ApiResponse>(
        future: futureInvoices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No invoices found'));
          } else {
            // Initialize the entered values list
            if (enteredValues.length != snapshot.data!.data.length) {
              enteredValues = List.filled(snapshot.data!.data.length, '');
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                final invoice = snapshot.data!.data[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showDialog(context, index);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                        ),
                                        width: 50,
                                        height: 20,
                                        child: Center(
                                          child: Text(enteredValues[
                                              index]), // Display entered value
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Amount: ${invoice.amount} | Paid: ${invoice.paid} | Balance: ${invoice.amount - invoice.paid}',
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            // visible: expandedStates[index],
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children:
                                        invoice.collection.map((collection) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 10),
                                        child: Row(
                                          children: [
                                            // Display collection details
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDialog(BuildContext context, int index) {
    String enteredValue =
        enteredValues[index]; // Initialize with current entered value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Value'),
          content: TextField(
            onChanged: (value) {
              enteredValue = value;
            },
            decoration: InputDecoration(hintText: 'Enter value'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  enteredValues[index] =
                      enteredValue; // Update entered value in the list
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Entered value: $enteredValue'),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ApiResponse {
  final List<Invoice> data;

  ApiResponse({required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: List<Invoice>.from(
          json['data'].map((item) => Invoice.fromJson(item))),
    );
  }
}
