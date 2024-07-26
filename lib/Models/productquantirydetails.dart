class ProductQuantityDetails {
  String? status;
  Result? result;

  ProductQuantityDetails({this.status, this.result});

  ProductQuantityDetails.fromJson(Map<String, dynamic> json) {
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
  List<String>? messages;

  Result({this.data, this.success, this.messages});

  Result.fromJson(Map<String, dynamic> json) {
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
  int? productId;
  int? unit;
  int? qty;
  dynamic minPrice;
  dynamic price;
  List<Units>? units;

  Data(
      {this.id,
      this.productId,
      this.unit,
      this.qty,
      this.units,
      this.minPrice,
      this.price});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    unit = json['unit'];
    minPrice = json['minimum_price'];
    price = json['price'];
    qty = json['qty'];
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
    data['product_id'] = this.productId;
    data['unit'] = this.unit;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['minPrice'] = this.minPrice;
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
