
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UnitDropdown extends StatefulWidget {
  @override
  _UnitDropdownState createState() => _UnitDropdownState();
}

class _UnitDropdownState extends State<UnitDropdown> {
  late Future<ApiResponse> futureUnits;
  String? selectedUnit;

  @override
  void initState() {
    super.initState();
    futureUnits = fetchUnits();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponse>(
      future: futureUnits,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<DropdownMenuItem<String>> dropdownItems = snapshot.data!.data.map((unit) {
            return DropdownMenuItem<String>(
              value: unit.id.toString(),
              child: Text(unit.name),
            );
          }).toList();

          return DropdownButton<String>(
            value: selectedUnit,
            hint: Text('Select Unit'),
            items: dropdownItems,
            onChanged: (value) {
              setState(() {
                selectedUnit = value;
              });
            },
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}

Future<ApiResponse> fetchUnits() async {
  final response = await http.get(Uri.parse('http://68.183.92.8:3699/api/get_product_with_units_by_products?store_id=10&van_id=9&id=25'));

  if (response.statusCode == 200) {
    return ApiResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load units');
  }
}

// Model for unit data
class Unit {
  final int unit;
  final int id;
  final String name;
  final String price;
  final String minPrice;
  final String stock;

  Unit({
    required this.unit,
    required this.id,
    required this.name,
    required this.price,
    required this.minPrice,
    required this.stock,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unit: json['unit'],
      id: json['id'],
      name: json['name'],
      price: json['price'],
      minPrice: json['min_price'],
      stock: json['stock'],
    );
  }
}

// Response model
class ApiResponse {
  final List<Unit> data;
  final bool success;
  final List<String> messages;

  ApiResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Unit> units = list.map((i) => Unit.fromJson(i)).toList();

    return ApiResponse(
      data: units,
      success: json['success'],
      messages: List<String>.from(json['messages']),
    );
  }
}
