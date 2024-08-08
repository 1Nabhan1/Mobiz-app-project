
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'Models/DriverDetailsModel.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  late Future<List<CustomerDelivery>> futureDeliveries;

  @override
  void initState() {
    super.initState();
    futureDeliveries = fetchCustomerDeliveries(10, 62);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Deliveries'),
      ),
      body: FutureBuilder<List<CustomerDelivery>>(
        future: futureDeliveries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final delivery = snapshot.data![index];
                return ListTile(
                  title: Text(delivery.invoiceNo),
                  subtitle: Text(delivery.customer.name),
                  trailing: Text('\$${delivery.total}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Future<List<CustomerDelivery>> fetchCustomerDeliveries(int storeId, int userId) async {
  final response = await http.get(
      Uri.parse('http://68.183.92.8:3699/api/get_customer_delivery_by_driver?store_id=$storeId&user_id=$userId'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      return List<CustomerDelivery>.from(
          jsonResponse['data'].map((delivery) => CustomerDelivery.fromJson(delivery)));
    } else {
      throw Exception('Failed to load data');
    }
  } else {
    throw Exception('Failed to load data');
  }
}

