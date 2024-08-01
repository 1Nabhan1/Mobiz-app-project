// import 'dart:convert';
//
// class VanTransfer {
//   int? id;
//   int? fromVanId;
//   int? toVanId;
//   int? userId;
//   String? inDate;
//   String? inTime;
//   String? invoiceNo;
//   String? approvedDate;
//   String? approvedTime;
//   int? approvedUser;
//   int? storeId;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   String? deletedAt;
//   List<Detail>? detail;
//
//   VanTransfer({
//      this.id,
//      this.fromVanId,
//      this.toVanId,
//      this.userId,
//      this.inDate,
//      this.inTime,
//      this.invoiceNo,
//     this.approvedDate,
//     this.approvedTime,
//      this.approvedUser,
//      this.storeId,
//      this.status,
//      this.createdAt,
//      this.updatedAt,
//     this.deletedAt,
//      this.detail,
//   });
//
//   factory VanTransfer.fromJson(Map<String, dynamic> json) {
//     return VanTransfer(
//       id: json['id'],
//       fromVanId: json['from_van_id'],
//       toVanId: json['to_van_id'],
//       userId: json['user_id'],
//       inDate: json['in_date'],
//       inTime: json['in_time'],
//       invoiceNo: json['invoice_no'],
//       approvedDate: json['approved_date'],
//       approvedTime: json['approved_time'],
//       approvedUser: json['approved_user'],
//       storeId: json['store_id'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       deletedAt: json['deleted_at'],
//       detail: (json['detail'] as List<dynamic>)
//           .map((item) => Detail.fromJson(item))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'from_van_id': fromVanId,
//       'to_van_id': toVanId,
//       'user_id': userId,
//       'in_date': inDate,
//       'in_time': inTime,
//       'invoice_no': invoiceNo,
//       'approved_date': approvedDate,
//       'approved_time': approvedTime,
//       'approved_user': approvedUser,
//       'store_id': storeId,
//       'status': status,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'deleted_at': deletedAt,
//       'detail': detail.map((item) => item.toJson()).toList(),
//     };
//   }
// }
//
// class Detail {
//   int id;
//   int vanTransferId;
//   int itemId;
//   String unit;
//   int quantity;
//   int convertQty;
//   int fromVanId;
//   int toVanId;
//   int userId;
//   int storeId;
//   int status;
//   String createdAt;
//   String updatedAt;
//   String? deletedAt;
//   int productId;
//   String productName;
//   String productCode;
//
//   Detail({
//     required this.id,
//     required this.vanTransferId,
//     required this.itemId,
//     required this.unit,
//     required this.quantity,
//     required this.convertQty,
//     required this.fromVanId,
//     required this.toVanId,
//     required this.userId,
//     required this.storeId,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     this.deletedAt,
//     required this.productId,
//     required this.productName,
//     required this.productCode,
//   });
//
//   factory Detail.fromJson(Map<String, dynamic> json) {
//     return Detail(
//       id: json['id'],
//       vanTransferId: json['van_transfar_id'],
//       itemId: json['item_id'],
//       unit: json['unit'],
//       quantity: json['quantity'],
//       convertQty: json['convert_qty'],
//       fromVanId: json['from_van_id'],
//       toVanId: json['to_van_id'],
//       userId: json['user_id'],
//       storeId: json['store_id'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       deletedAt: json['deleted_at'],
//       productId: json['product_id'],
//       productName: json['product_name'],
//       productCode: json['product_code'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'van_transfar_id': vanTransferId,
//       'item_id': itemId,
//       'unit': unit,
//       'quantity': quantity,
//       'convert_qty': convertQty,
//       'from_van_id': fromVanId,
//       'to_van_id': toVanId,
//       'user_id': userId,
//       'store_id': storeId,
//       'status': status,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'deleted_at': deletedAt,
//       'product_id': productId,
//       'product_name': productName,
//       'product_code': productCode,
//     };
//   }
// }
//
// // Example function to parse JSON response
// List<VanTransfer> parseVanTransferResponse(String responseBody) {
//   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<VanTransfer>((json) => VanTransfer.fromJson(json)).toList();
// }
