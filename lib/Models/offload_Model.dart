class Offload {
  final List<SalesReturnData> data;

  Offload({required this.data});

  factory Offload.fromJson(Map<String, dynamic> json) {
    return Offload(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => SalesReturnData.fromJson(item))
              .toList() ??
          [],
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
      id: json['id'] ?? 0,
      product: (json['product'] as List<dynamic>?)
              ?.map((item) => Productreturn.fromJson(item))
              .toList() ??
          [],
      returntype: (json['returntype'] as List<dynamic>?)
              ?.map((item) => ReturnType.fromJson(item))
              .toList() ??
          [],
      units: (json['units'] as List<dynamic>?)
              ?.map((item) => Unit.fromJson(item))
              .toList() ??
          [],
      quantity: json['quantity'] ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
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
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      proImage: json['pro_image'] ?? '',
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
