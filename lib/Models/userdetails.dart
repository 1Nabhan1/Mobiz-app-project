class UserDetailsModel {
  List<Data>? data;
  bool? success;
  List<String>? messages;

  UserDetailsModel({this.data, this.success, this.messages});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
    messages = json['messages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['messages'] = this.messages;
    return data;
  }
}

class Data {
  int? id;
  int? routeId;
  int? vanId;
  int? userId;
  Null? description;
  int? status;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Data(
      {this.id,
      this.routeId,
      this.vanId,
      this.userId,
      this.description,
      this.status,
      this.storeId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    routeId = json['route_id'];
    vanId = json['van_id'];
    userId = json['user_id'];
    description = json['description'];
    status = json['status'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['route_id'] = this.routeId;
    data['van_id'] = this.vanId;
    data['user_id'] = this.userId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['store_id'] = this.storeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
