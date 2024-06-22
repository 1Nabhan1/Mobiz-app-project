class QuantityModel {
  String? status;
  Result? result;

  QuantityModel({this.status, this.result});

  QuantityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  List<Data>? data;
  bool? success;

  Result({this.data, this.success});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;

    return data;
  }
}

class Data {
  int? id;
  String? barcode;
  int? productId;
  int? unit;
  int? qty;
  String? discount;
  int? opStock;
  String? price;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Units>? units;

  Data(
      {this.id,
      this.barcode,
      this.productId,
      this.unit,
      this.qty,
      this.discount,
      this.opStock,
      this.price,
      this.storeId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.units});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barcode = json['barcode'];
    productId = json['product_id'];
    unit = json['unit'];
    qty = json['qty'];
    discount = json['discount'];
    opStock = json['op_stock'];
    price = json['price'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['units'] != null) {
      units = <Units>[];
      json['units'].forEach((v) {
        units!.add(new Units.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['barcode'] = this.barcode;
    data['product_id'] = this.productId;
    data['unit'] = this.unit;
    data['qty'] = this.qty;
    data['discount'] = this.discount;
    data['op_stock'] = this.opStock;
    data['price'] = this.price;
    data['store_id'] = this.storeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.units != null) {
      data['units'] = this.units!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Units {
  int? id;
  String? name;

  Units({this.id, this.name});

  Units.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
