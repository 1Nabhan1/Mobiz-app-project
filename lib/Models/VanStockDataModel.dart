import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:flutter/material.dart';

// class ProductListPage extends StatefulWidget {
//   @override
//   _ProductListPageState createState() => _ProductListPageState();
// }
//
// class _ProductListPageState extends State<ProductListPage> {
//   late Future<List<Product12>> productsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     productsFuture = VanStockService().fetchVanStockProducts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products'),
//       ),
//       body: FutureBuilder<List<Product12>>(
//         future: productsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             // Filter products with stock greater than 0
//             final products = snapshot.data!.where((product) {
//               // Filter units that have stock > 0
//               product.units =
//                   product.units.where((unit) => unit.stock > 0).toList();
//               // Only include products with at least one unit that has stock > 0
//               return product.units.isNotEmpty;
//             }).toList();
//
//             if (products.isEmpty) {
//               return Center(child: Text('No products with stock available'));
//             }
//
//             return ListView.builder(
//               shrinkWrap: true,
//               physics: BouncingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 final product = products[index];
//                 return Column(
//                   children: [
//                     ListTile(
//                       title: Text(product.name),
//                       subtitle: Text('Price: \$${product.price.toString()}'),
//                     ),
//                     Row(
//                       children: [
//                         // Display units with stock > 0
//                         for (var unit in product.units)
//                           Text('${unit.name}: ${unit.stock}  '),
//                       ],
//                     ),
//                     Divider(),
//                   ],
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text('No products found'));
//           }
//         },
//       ),
//     );
//   }
// }
//
// class VanStockService {
//   Future<List<Product12>> fetchVanStockProducts() async {
//     try {
//       // Send GET request to the API
//       final response = await http.get(Uri.parse("http://68.183.92.8:3699/api/get_van_stock_return?store_id=10&van_id=09"));
//
//       // Check if the response is successful
//       if (response.statusCode == 200) {
//         // Decode the JSON response
//         final Map<String, dynamic> jsonResponse = json.decode(response.body);
//
//         // Parse the JSON into the VanStockReturnResponse model
//         VanStockReturnResponse vanStockResponse =
//             VanStockReturnResponse.fromJson(jsonResponse);
//
//         // Return the list of products
//         return vanStockResponse.products;
//       } else {
//         throw Exception('Failed to load products');
//       }
//     } catch (e) {
//       print('Error fetching products: $e');
//       throw Exception('Error fetching products');
//     }
//   }
// }
class VanStockReturnResponse {
  final int currentPage;
  List<Product12> products;
  final String? firstPageUrl;
  final int from;
  final int lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;
  final bool success;
  final List<dynamic> messages;

  VanStockReturnResponse({
    required this.currentPage,
    required this.products,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
    required this.success,
    required this.messages,
  });

  factory VanStockReturnResponse.fromJson(Map<String, dynamic> json) {
    return VanStockReturnResponse(
      currentPage: json['data']['current_page'],
      products: (json['data']['data'] as List)
          .map((i) => Product12.fromJson(i))
          .toList(),
      firstPageUrl: json['data']['first_page_url'],
      from: json['data']['from'],
      lastPage: json['data']['last_page'],
      lastPageUrl: json['data']['last_page_url'],
      links:
          (json['data']['links'] as List).map((i) => Link.fromJson(i)).toList(),
      nextPageUrl: json['data']['next_page_url'],
      path: json['data']['path'],
      perPage: json['data']['per_page'],
      prevPageUrl: json['data']['prev_page_url'],
      to: json['data']['to'],
      total: json['data']['total'],
      success: json['success'],
      messages: json['messages'],
    );
  }
}

class Product12 {
  final int id;
  final String code;
  final String name;
  final String proImage;
  final int taxPercentage;
  final double price;
  final int storeId;
  final int status;
  List<Unit> units;

  Product12({
    required this.id,
    required this.code,
    required this.name,
    required this.proImage,
    required this.taxPercentage,
    required this.price,
    required this.storeId,
    required this.status,
    required this.units,
  });

  factory Product12.fromJson(Map<String, dynamic> json) {
    return Product12(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      proImage: json['pro_image'],
      taxPercentage: json['tax_percentage'],
      price: double.parse(json['price'].toString()),
      storeId: json['store_id'],
      status: json['status'],
      units: (json['units'] as List).map((i) => Unit.fromJson(i)).toList(),
    );
  }
}

class Unit {
  final int unit;
  final int id;
  final String name;
  final double price;
  final double minPrice;
  final double stock;

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
      price: double.parse(json['price'].toString()),
      minPrice: double.parse(json['min_price'].toString()),
      stock:double.parse(json['stock'].toString()),
    );
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
