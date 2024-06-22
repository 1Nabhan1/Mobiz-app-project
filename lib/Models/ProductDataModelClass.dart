import 'package:mobizapp/Models/vanstockdata.dart';

class ProductDataModel {
  List<Data>? data;
  bool? success;

  ProductDataModel({this.data, this.success});

  ProductDataModel.fromJson(Map<String, dynamic> json) {
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
  String? code;
  String? name;
  String? proImage;
  int? categoryId;
  int? subCategoryId;
  int? brandId;
  int? supplierId;
  int? taxId;
  num? taxPercentage;
  num? taxInclusive;
  num? price;
  int? baseUnitId;
  int? baseUnitQty;
  String? baseUnitDiscount;
  String? baseUnitBarcode;
  int? baseUnitOpStock;
  String? secondUnitPrice;
  int? secondUnitId;
  int? secondUnitQty;
  String? secondUnitDiscount;
  dynamic secondUnitBarcode;
  String? secondUnitOpStock;
  String? thirdUnitPrice;
  int? thirdUnitId;
  int? thirdUnitQty;
  String? thirdUnitDiscount;
  dynamic thirdUnitBarcode;
  String? thirdUnitOpStock;
  String? fourthUnitPrice;
  int? fourthUnitId;
  int? fourthUnitQty;
  String? fourthUnitDiscount;
  int? isMultipleUnit;
  String? fourthUnitOpStock;
  dynamic description;
  int? productQty;
  int? storeId;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  List<Units>? units;
  List<ProductDetail>? productDetail;
  dynamic unitData;

  Data(
      {this.id,
      this.code,
      this.name,
      this.proImage,
      this.categoryId,
      this.subCategoryId,
      this.brandId,
      this.supplierId,
      this.taxId,
      this.taxPercentage,
      this.taxInclusive,
      this.price,
      this.baseUnitId,
      this.baseUnitQty,
      this.baseUnitDiscount,
      this.baseUnitBarcode,
      this.baseUnitOpStock,
      this.secondUnitPrice,
      this.secondUnitId,
      this.secondUnitQty,
      this.secondUnitDiscount,
      this.secondUnitBarcode,
      this.secondUnitOpStock,
      this.thirdUnitPrice,
      this.thirdUnitId,
      this.thirdUnitQty,
      this.thirdUnitDiscount,
      this.thirdUnitBarcode,
      this.thirdUnitOpStock,
      this.fourthUnitPrice,
      this.fourthUnitId,
      this.fourthUnitQty,
      this.fourthUnitDiscount,
      this.isMultipleUnit,
      this.fourthUnitOpStock,
      this.description,
      this.productQty,
      this.storeId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.units,
      this.productDetail,
      this.unitData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    proImage = json['pro_image'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    brandId = json['brand_id'];
    supplierId = json['supplier_id'];
    taxId = json['tax_id'];
    taxPercentage = json['tax_percentage'];
    taxInclusive = json['tax_inclusive'];
    price = json['price'];
    baseUnitId = json['base_unit_id'];
    baseUnitQty = json['base_unit_qty'];
    baseUnitDiscount = json['base_unit_discount'];
    baseUnitBarcode = json['base_unit_barcode'];
    baseUnitOpStock = json['base_unit_op_stock'];
    secondUnitPrice = json['second_unit_price'];
    secondUnitId = json['second_unit_id'];
    secondUnitQty = json['second_unit_qty'];
    secondUnitDiscount = json['second_unit_discount'];
    secondUnitBarcode = json['second_unit_barcode'];
    secondUnitOpStock = json['second_unit_op_stock'];
    thirdUnitPrice = json['third_unit_price'];
    thirdUnitId = json['third_unit_id'];
    thirdUnitQty = json['third_unit_qty'];
    thirdUnitDiscount = json['third_unit_discount'];
    thirdUnitBarcode = json['third_unit_barcode'];
    thirdUnitOpStock = json['third_unit_op_stock'];
    fourthUnitPrice = json['fourth_unit_price'];
    fourthUnitId = json['fourth_unit_id'];
    fourthUnitQty = json['fourth_unit_qty'];
    fourthUnitDiscount = json['fourth_unit_discount'];
    isMultipleUnit = json['is_multiple_unit'];
    fourthUnitOpStock = json['fourth_unit_op_stock'];
    description = json['description'];
    productQty = json['product_qty'];
    storeId = json['store_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    unitData = json['unit_data'];
    if (json['product_detail'] != null) {
      productDetail = <ProductDetail>[];
      json['product_detail'].forEach((v) {
        productDetail!.add(new ProductDetail.fromJson(v));
      });
    }
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
    data['code'] = this.code;
    data['name'] = this.name;
    data['pro_image'] = this.proImage;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['brand_id'] = this.brandId;
    data['supplier_id'] = this.supplierId;
    data['tax_id'] = this.taxId;
    data['tax_percentage'] = this.taxPercentage;
    data['tax_inclusive'] = this.taxInclusive;
    data['price'] = this.price;
    data['base_unit_id'] = this.baseUnitId;
    data['base_unit_qty'] = this.baseUnitQty;
    data['base_unit_discount'] = this.baseUnitDiscount;
    data['base_unit_barcode'] = this.baseUnitBarcode;
    data['base_unit_op_stock'] = this.baseUnitOpStock;
    data['second_unit_price'] = this.secondUnitPrice;
    data['second_unit_id'] = this.secondUnitId;
    data['second_unit_qty'] = this.secondUnitQty;
    data['second_unit_discount'] = this.secondUnitDiscount;
    data['second_unit_barcode'] = this.secondUnitBarcode;
    data['second_unit_op_stock'] = this.secondUnitOpStock;
    data['third_unit_price'] = this.thirdUnitPrice;
    data['third_unit_id'] = this.thirdUnitId;
    data['third_unit_qty'] = this.thirdUnitQty;
    data['third_unit_discount'] = this.thirdUnitDiscount;
    data['third_unit_barcode'] = this.thirdUnitBarcode;
    data['third_unit_op_stock'] = this.thirdUnitOpStock;
    data['fourth_unit_price'] = this.fourthUnitPrice;
    data['fourth_unit_id'] = this.fourthUnitId;
    data['fourth_unit_qty'] = this.fourthUnitQty;
    data['fourth_unit_discount'] = this.fourthUnitDiscount;
    data['is_multiple_unit'] = this.isMultipleUnit;
    data['fourth_unit_op_stock'] = this.fourthUnitOpStock;
    data['description'] = this.description;
    data['product_qty'] = this.productQty;
    data['store_id'] = this.storeId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['unit_data'] = this.unitData;
    if (this.units != null) {
      data['units'] = this.units!.map((v) => v.toJson()).toList();
    }
    if (this.productDetail != null) {
      data['product_detail'] =
          this.productDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Units {
  int? id;
  String? name;
  dynamic description;
  int? status;
  int? storeId;
  int? stock;
  String? price;
  String? minPrice;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Units(
      {this.id,
      this.name,
      this.description,
      this.status,
      this.storeId,
      this.createdAt,
      this.updatedAt,
      this.price,
      this.minPrice,
      this.deletedAt});

  Units.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    price = json['price'];
    minPrice = json['min_price'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['status'] = this.status;
    data['store_id'] = this.storeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['stock'] = this.stock;
    return data;
  }
}








// class ProductDataModel {
//   List<Data>? data;
//   bool? success;
//   List<String>? messages;

//   ProductDataModel({this.data, this.success, this.messages});

//   ProductDataModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     success = json['success'];
//     messages = json['messages'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['success'] = this.success;
//     data['messages'] = this.messages;
//     return data;
//   }
// }

// class Data {
//   int? id;
//   String? code;
//   String? name;
//   String? proImage;
//   int? categoryId;
//   int? subCategoryId;
//   int? brandId;
//   int? supplierId;
//   int? taxId;
//   int? taxPercentage;
//   int? taxInclusive;
//   num? price;
//   int? baseUnitId;
//   int? baseUnitQty;
//   String? baseUnitDiscount;
//   String? baseUnitBarcode;
//   int? baseUnitOpStock;
//   String? secondUnitPrice;
//   int? secondUnitId;
//   int? secondUnitQty;
//   String? secondUnitDiscount;
//   String? secondUnitBarcode;
//   String? secondUnitOpStock;
//   String? thirdUnitPrice;
//   int? thirdUnitId;
//   int? thirdUnitQty;
//   String? thirdUnitDiscount;
//   String? thirdUnitBarcode;
//   String? thirdUnitOpStock;
//   String? fourthUnitPrice;
//   int? fourthUnitId;
//   int? fourthUnitQty;
//   String? fourthUnitDiscount;
//   int? isMultipleUnit;
//   String? fourthUnitOpStock;
//   String? description;
//   int? productQty;
//   int? storeId;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   String? deletedAt;
//   dynamic unitData;

//   Data(
//       {this.id,
//       this.code,
//       this.name,
//       this.proImage,
//       this.categoryId,
//       this.subCategoryId,
//       this.brandId,
//       this.supplierId,
//       this.taxId,
//       this.taxPercentage,
//       this.taxInclusive,
//       this.price,
//       this.baseUnitId,
//       this.baseUnitQty,
//       this.baseUnitDiscount,
//       this.baseUnitBarcode,
//       this.baseUnitOpStock,
//       this.secondUnitPrice,
//       this.secondUnitId,
//       this.secondUnitQty,
//       this.secondUnitDiscount,
//       this.secondUnitBarcode,
//       this.secondUnitOpStock,
//       this.thirdUnitPrice,
//       this.thirdUnitId,
//       this.thirdUnitQty,
//       this.thirdUnitDiscount,
//       this.thirdUnitBarcode,
//       this.thirdUnitOpStock,
//       this.fourthUnitPrice,
//       this.fourthUnitId,
//       this.fourthUnitQty,
//       this.fourthUnitDiscount,
//       this.isMultipleUnit,
//       this.fourthUnitOpStock,
//       this.description,
//       this.productQty,
//       this.storeId,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.unitData,
//       this.deletedAt});//

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     code = json['code'];
//     name = json['name'];
//     proImage = json['pro_image'];
//     categoryId = json['category_id'];
//     subCategoryId = json['sub_category_id'];
//     brandId = json['brand_id'];
//     supplierId = json['supplier_id'];
//     taxId = json['tax_id'];
//     taxPercentage = json['tax_percentage'];
//     taxInclusive = json['tax_inclusive'];
//     price = json['price'];
//     baseUnitId = json['base_unit_id'];
//     baseUnitQty = json['base_unit_qty'];
//     baseUnitDiscount = json['base_unit_discount'];
//     baseUnitBarcode = json['base_unit_barcode'];
//     baseUnitOpStock = json['base_unit_op_stock'];
//     secondUnitPrice = json['second_unit_price'];
//     secondUnitId = json['second_unit_id'];
//     secondUnitQty = json['second_unit_qty'];
//     secondUnitDiscount = json['second_unit_discount'];
//     secondUnitBarcode = json['second_unit_barcode'];
//     secondUnitOpStock = json['second_unit_op_stock'];
//     thirdUnitPrice = json['third_unit_price'];
//     thirdUnitId = json['third_unit_id'];
//     thirdUnitQty = json['third_unit_qty'];
//     thirdUnitDiscount = json['third_unit_discount'];
//     thirdUnitBarcode = json['third_unit_barcode'];
//     thirdUnitOpStock = json['third_unit_op_stock'];
//     fourthUnitPrice = json['fourth_unit_price'];
//     fourthUnitId = json['fourth_unit_id'];
//     fourthUnitQty = json['fourth_unit_qty'];
//     fourthUnitDiscount = json['fourth_unit_discount'];
//     isMultipleUnit = json['is_multiple_unit'];
//     fourthUnitOpStock = json['fourth_unit_op_stock'];
//     description = json['description'];
//     productQty = json['product_qty'];
//     storeId = json['store_id'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//     unitData = json['unit_data'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['code'] = this.code;
//     data['name'] = this.name;
//     data['pro_image'] = this.proImage;
//     data['category_id'] = this.categoryId;
//     data['sub_category_id'] = this.subCategoryId;
//     data['brand_id'] = this.brandId;
//     data['supplier_id'] = this.supplierId;
//     data['tax_id'] = this.taxId;
//     data['tax_percentage'] = this.taxPercentage;
//     data['tax_inclusive'] = this.taxInclusive;
//     data['price'] = this.price;
//     data['base_unit_id'] = this.baseUnitId;
//     data['base_unit_qty'] = this.baseUnitQty;
//     data['base_unit_discount'] = this.baseUnitDiscount;
//     data['base_unit_barcode'] = this.baseUnitBarcode;
//     data['base_unit_op_stock'] = this.baseUnitOpStock;
//     data['second_unit_price'] = this.secondUnitPrice;
//     data['second_unit_id'] = this.secondUnitId;
//     data['second_unit_qty'] = this.secondUnitQty;
//     data['second_unit_discount'] = this.secondUnitDiscount;
//     data['second_unit_barcode'] = this.secondUnitBarcode;
//     data['second_unit_op_stock'] = this.secondUnitOpStock;
//     data['third_unit_price'] = this.thirdUnitPrice;
//     data['third_unit_id'] = this.thirdUnitId;
//     data['third_unit_qty'] = this.thirdUnitQty;
//     data['third_unit_discount'] = this.thirdUnitDiscount;
//     data['third_unit_barcode'] = this.thirdUnitBarcode;
//     data['third_unit_op_stock'] = this.thirdUnitOpStock;
//     data['fourth_unit_price'] = this.fourthUnitPrice;
//     data['fourth_unit_id'] = this.fourthUnitId;
//     data['fourth_unit_qty'] = this.fourthUnitQty;
//     data['fourth_unit_discount'] = this.fourthUnitDiscount;
//     data['is_multiple_unit'] = this.isMultipleUnit;
//     data['fourth_unit_op_stock'] = this.fourthUnitOpStock;
//     data['description'] = this.description;
//     data['product_qty'] = this.productQty;
//     data['store_id'] = this.storeId;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['deleted_at'] = this.deletedAt;
//     data['unitData'] = this.unitData;
//     return data;
//   }
// }
