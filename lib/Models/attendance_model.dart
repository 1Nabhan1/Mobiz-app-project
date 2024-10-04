class CheckInOutData {
  String van;
  int sheduled;
  int vistCustomer;
  int nonVistCustomer;
  int pending;
  dynamic lastOdometerIn;
  dynamic lastOdometerOut;

  CheckInOutData({
    required this.van,
    required this.sheduled,
    required this.vistCustomer,
    required this.nonVistCustomer,
    required this.pending,
    this.lastOdometerIn,
    this.lastOdometerOut,
  });

  factory CheckInOutData.fromJson(Map<String, dynamic> json) {
    return CheckInOutData(
      van: json['van'],
      sheduled: json['sheduled'],
      vistCustomer: json['vist_customer'],
      nonVistCustomer: json['non_vist_customer'],
      pending: json['pending'],
      lastOdometerIn: json['last_odometer_in'],
      lastOdometerOut: json['last_odo_meter_out'],
    );
  }
}

class ApiResponse {
  CheckInOutData data;
  bool success;
  List<String> messages;

  ApiResponse({
    required this.data,
    required this.success,
    required this.messages,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: CheckInOutData.fromJson(json['data']),
      success: json['success'],
      messages: List<String>.from(json['messages']),
    );
  }
}