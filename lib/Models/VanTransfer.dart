import 'dart:convert';

class VanData {
  int? id;
  String? code;
  String? name;
  String? description;
  int? status;
  int? storeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  VanData({
    this.id,
    this.code,
    this.name,
    this.description,
    this.status,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory VanData.fromJson(Map<String, dynamic> json) {
    return VanData(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      storeId: json['store_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }
}
