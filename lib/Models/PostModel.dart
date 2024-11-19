// class ProductResponse {
//   final ProductData data;
//   final int returnCount;
//   final bool success;
//   final List<String> messages;  // Assuming messages are a list of strings, change if needed
//
//   ProductResponse({
//     required this.data,
//     required this.returnCount,
//     required this.success,
//     required this.messages,
//   });
//
//   factory ProductResponse.fromJson(Map<String, dynamic> json) {
//     return ProductResponse(
//       data: ProductData.fromJson(json['data']),
//       returnCount: json['return_count'],
//       success: json['success'],
//       messages: List<String>.from(json['messages'] ?? []), // Default to empty list if null
//     );
//   }
// }
//
// class ProductData {
//   final int id;
//   final String code;
//   final String name;
//   final String proImage;
//   final int categoryId;
//   final int subCategoryId;
//   final int brandId;
//   final int supplierId;
//   final int taxId;
//   final int taxPercentage;
//   final int taxInclusive;
//   final double price;
//   final int baseUnitId;
//   final int baseUnitQty;
//   final String baseUnitDiscount;
//   final String? baseUnitBarcode;
//   final int baseUnitOpStock;
//   final int isMultipleUnit;
//   final String? description;
//   final int productQty;
//   final int storeId;
//   final int status;
//   final String inventoryRequired;
//   final String serialBarcodeRequired;
//   final String batchCodeRequired;
//   final String expiryRequired;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime? deletedAt;
//   final List<ProductDetail> productDetail;
//
//   ProductData({
//     required this.id,
//     required this.code,
//     required this.name,
//     required this.proImage,
//     required this.categoryId,
//     required this.subCategoryId,
//     required this.brandId,
//     required this.supplierId,
//     required this.taxId,
//     required this.taxPercentage,
//     required this.taxInclusive,
//     required this.price,
//     required this.baseUnitId,
//     required this.baseUnitQty,
//     required this.baseUnitDiscount,
//     this.baseUnitBarcode,
//     required this.baseUnitOpStock,
//     required this.isMultipleUnit,
//     this.description,
//     required this.productQty,
//     required this.storeId,
//     required this.status,
//     required this.inventoryRequired,
//     required this.serialBarcodeRequired,
//     required this.batchCodeRequired,
//     required this.expiryRequired,
//     required this.createdAt,
//     required this.updatedAt,
//     this.deletedAt,
//     required this.productDetail,
//   });
//
//   factory ProductData.fromJson(Map<String, dynamic> json) {
//     return ProductData(
//       id: json['id'],
//       code: json['code'],
//       name: json['name'],
//       proImage: json['pro_image'],
//       categoryId: json['category_id'],
//       subCategoryId: json['sub_category_id'],
//       brandId: json['brand_id'],
//       supplierId: json['supplier_id'],
//       taxId: json['tax_id'],
//       taxPercentage: json['tax_percentage'],
//       taxInclusive: json['tax_inclusive'],
//       price: (json['price'] ?? 0.0).toDouble(), // Handle price as double
//       baseUnitId: json['base_unit_id'],
//       baseUnitQty: json['base_unit_qty'],
//       baseUnitDiscount: json['base_unit_discount'],
//       baseUnitBarcode: json['base_unit_barcode'],
//       baseUnitOpStock: json['base_unit_op_stock'],
//       isMultipleUnit: json['is_multiple_unit'],
//       description: json['description'],
//       productQty: json['product_qty'],
//       storeId: json['store_id'],
//       status: json['status'],
//       inventoryRequired: json['inventory_required'],  // Corrected typo
//       serialBarcodeRequired: json['serial_barcode_required'],
//       batchCodeRequired: json['batch_code_required'],
//       expiryRequired: json['expiry_required'],
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//       deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
//       productDetail: (json['product_detail'] as List)
//           .map((detail) => ProductDetail.fromJson(detail))
//           .toList(),
//     );
//   }
// }
//
// class ProductDetail {
//   final int productId;
//   final int unit;
//   final int id;
//   final String name;
//   final String unitName;
//   final String price;
//   final String minPrice;
//   final String returnPrice;
//   final String convertQty;
//   final String opStock;
//   final String stock;
//
//   ProductDetail({
//     required this.productId,
//     required this.unit,
//     required this.id,
//     required this.name,
//     required this.unitName,
//     required this.price,
//     required this.minPrice,
//     required this.returnPrice,
//     required this.convertQty,
//     required this.opStock,
//     required this.stock,
//   });
//
//   factory ProductDetail.fromJson(Map<String, dynamic> json) {
//     return ProductDetail(
//       productId: json['product_id'],
//       unit: json['unit'],
//       id: json['id'],
//       name: json['name'],
//       unitName: json['unit_name'],
//       price: json['price'],
//       minPrice: json['min_price'],
//       returnPrice: json['return_price'],
//       convertQty: json['convert_qty'],
//       opStock: json['op_stock'],
//       stock: json['stock'],
//     );
//   }
// }
