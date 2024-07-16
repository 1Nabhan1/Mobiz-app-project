import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late Future<ApiResponse> futureInvoices;

  @override
  void initState() {
    super.initState();
    futureInvoices = fetchInvoices();
  }

  Future<ApiResponse> fetchInvoices() async {
    final response = await http.get(Uri.parse(
        'http://68.183.92.8:3699/api/get_invoice_outstanding_detail?customer_id=38'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoices')),
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
            return ListView.builder(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                final invoice = snapshot.data!.data[index];
                return ExpansionTile(
                  title: Text(invoice.invoiceNo),
                  subtitle: Text('Amount: \$${invoice.amount}'),
                  children: invoice.customer.map((customer) {
                    return ListTile(
                      title: Text(customer.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contact: ${customer.contactNumber}'),
                          Text('Email: ${customer.email}'),
                          Text('Address: ${customer.address}'),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
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

class Invoice {
  final int id;
  final int customerId;
  final String invoiceNo;
  final String invoiceDate;
  final String invoiceType;
  final double amount;
  final double paid;
  final List<Customer> customer;

  Invoice({
    required this.id,
    required this.customerId,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.invoiceType,
    required this.amount,
    required this.paid,
    required this.customer,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      customerId: json['customer_id'],
      invoiceNo: json['invoice_no'],
      invoiceDate: json['invoice_date'],
      invoiceType: json['invoice_type'],
      amount: double.parse(json['amount']),
      paid: double.parse(json['paid']),
      customer: List<Customer>.from(
          json['customer'].map((item) => Customer.fromJson(item))),
    );
  }
}

class Customer {
  final int id;
  final String name;
  final String code;
  final String address;
  final String contactNumber;
  final String whatsappNumber;
  final String email;
  final String trn;
  final String? custImage;
  final String paymentTerms;
  final int creditLimit;
  final int creditDays;
  final String location;
  final int routeId;
  final int provinceId;
  final int storeId;
  final int status;

  Customer({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.contactNumber,
    required this.whatsappNumber,
    required this.email,
    required this.trn,
    this.custImage,
    required this.paymentTerms,
    required this.creditLimit,
    required this.creditDays,
    required this.location,
    required this.routeId,
    required this.provinceId,
    required this.storeId,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      address: json['address'],
      contactNumber: json['contact_number'],
      whatsappNumber: json['whatsapp_number'],
      email: json['email'],
      trn: json['trn'],
      custImage: json['cust_image'],
      paymentTerms: json['payment_terms'],
      creditLimit: json['credit_limit'],
      creditDays: json['credit_days'],
      location: json['location'],
      routeId: json['route_id'],
      provinceId: json['province_id'],
      storeId: json['store_id'],
      status: json['status'],
    );
  }
}
