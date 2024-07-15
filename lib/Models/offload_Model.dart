// sales_return_model.dart

class Offload {
  final List<SalesReturnData> data;

  Offload({required this.data});

  factory Offload.fromJson(Map<String, dynamic> json) {
    return Offload(
      data: List<SalesReturnData>.from(json['data'].map((item) => SalesReturnData.fromJson(item))),
    );
  }
}

class SalesReturnData {
  final int id;
  final List<Productreturn> product;
  final List<ReturnType> returntype;
  final List<Unit> units;
  final int quantity;
  final double amount;

  SalesReturnData({
    required this.id,
    required this.product,
    required this.returntype,
    required this.units,
    required this.quantity,
    required this.amount,
  });

  factory SalesReturnData.fromJson(Map<String, dynamic> json) {
    return SalesReturnData(
      id: json['id'],
      product: List<Productreturn>.from(json['product'].map((item) => Productreturn.fromJson(item))),
      returntype: List<ReturnType>.from(json['returntype'].map((item) => ReturnType.fromJson(item))),
      units: List<Unit>.from(json['units'].map((item) => Unit.fromJson(item))),
      quantity: json['quantity'],
      amount: json['amount'].toDouble(),
    );
  }
}

class Productreturn {
  final int id;
  final String code;
  final String name;
  final String proImage;

  Productreturn({
    required this.id,
    required this.code,
    required this.name,
    required this.proImage,
  });

  factory Productreturn.fromJson(Map<String, dynamic> json) {
    return Productreturn(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      proImage: json['pro_image'],
    );
  }
}

class ReturnType {
  final int id;
  final String name;

  ReturnType({
    required this.id,
    required this.name,
  });

  factory ReturnType.fromJson(Map<String, dynamic> json) {
    return ReturnType(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Unit {
  final int id;
  final String name;

  Unit({
    required this.id,
    required this.name,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
    );
  }
}