class VanStockData {
  String? status;
  Result? result;

  VanStockData({this.status, this.result});

  VanStockData.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? code;
  String? proImage;
  List<ProductDetail>? productDetail;

  Data({this.id, this.name, this.code, this.proImage, this.productDetail});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    proImage = json['pro_image'];
    if (json['product_detail'] != null) {
      productDetail = <ProductDetail>[];
      json['product_detail'].forEach((v) {
        productDetail!.add(new ProductDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['pro_image'] = this.proImage;
    if (this.productDetail != null) {
      data['product_detail'] =
          this.productDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetail {
  int? productId;
  int? unit;
  int? id;
  String? name;
  int? stock;
  String? price;
  String? minPrice;

  ProductDetail(
      {this.productId,
      this.unit,
      this.id,
      this.name,
      this.price,
      this.minPrice});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    unit = json['unit'];
    id = json['id'];
    name = json['name'];
    stock = json['stock'];
    price = json['price'];
    minPrice = json['min_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['unit'] = this.unit;
    data['id'] = this.id;
    data['name'] = this.name;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['minPrice'] = this.minPrice;
    return data;
  }
}
