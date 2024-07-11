import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Models/sales_model.dart';

class ProductTypeDropdown extends StatefulWidget {
  @override
  _ProductTypeDropdownState createState() => _ProductTypeDropdownState();
}

class _ProductTypeDropdownState extends State<ProductTypeDropdown> {
  List<ProductType> productTypes = [];
  ProductType? selectedProductType;

  @override
  void initState() {
    super.initState();
    fetchProductTypes();
  }

  Future<void> fetchProductTypes() async {
    final response = await http
        .get(Uri.parse('https://mobiz-api.yes45.in/api/get_product_type'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<ProductType> loadedProductTypes = [];

      for (var item in data['data']) {
        loadedProductTypes.add(ProductType.fromJson(item));
      }

      setState(() {
        productTypes = loadedProductTypes;
        if (productTypes.isNotEmpty) {
          selectedProductType = productTypes.first;
        }
      });
    } else {
      throw Exception('Failed to load product types');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text('Product Type Dropdown')),
      body: Column(
        children: [
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ProductType>(
                      isExpanded: true,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                      hint: Text('Select Product Type'),
                      value: selectedProductType,
                      onChanged: (ProductType? newValue) {
                        setState(() {
                          selectedProductType = newValue;
                        });
                      },
                      items: productTypes.map((ProductType productType) {
                        return DropdownMenuItem<ProductType>(
                          value: productType,
                          child: Text(productType.name),
                        );
                      }).toList(),
                      icon: SizedBox.shrink(),
                    ),
                  ),
                ),
                Text('Product Type Dropdown')
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                print(selectedProductType?.id.toString());
              },
              child: Text('jj'))
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ProductTypeDropdown()));
