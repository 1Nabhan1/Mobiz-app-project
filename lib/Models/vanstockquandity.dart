class VanStockQuandity {
  String? status;
  Result? result;

  VanStockQuandity({this.status, this.result});

  VanStockQuandity.fromJson(Map<String, dynamic> json) {
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
  dynamic data;
  bool? success;
  List<String>? messages;

  Result({this.data, this.success, this.messages});

  Result.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    success = json['success'];
    messages = json['messages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['success'] = this.success;
    data['messages'] = this.messages;
    return data;
  }
}
