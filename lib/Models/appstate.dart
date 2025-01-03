class AppState {
  //////// Login Information
  /// Login state : LOGGED_IN , LOGGED_OUT
  String? loginState;
  bool? isExistingUser;
  String? token;
  String? userType;
  String? name;
  String? email;
  String? vatState;
  String? validate_qtySO;
  String? discountState;
  String? attendanceState;
  String? printer;
  int? userId;
  int? vanId;
  int? storeId;
  int? routeId;
  int? rolId;
  String? appVersion;
  String? buildNumber;
  String? osType;
  String? imageUrl;
  String? minorVersion;
  String? username;
  Map? devices;
  bool? initialConsent;
  String? country;
  bool? isEmailVerified;
  bool? isMobileVerified;
  bool? isTwoFactorEnabled;
  //// Make it as singleton class
  static final AppState _appState = new AppState._internal();

  AppState._internal() {
    loginState = "LOGGED_OUT";
    isExistingUser = false;
    token = "";
    userType = "";
    name = "";
    email = "";
    userId;
    rolId;
    storeId;
    vatState;
    validate_qtySO;
    discountState;
    attendanceState;
    printer;
    routeId;
    vanId;
    appVersion = "";
    buildNumber = "";
    osType = "";
    imageUrl = "";
    minorVersion = "";
    username = "";
    devices = {};
    initialConsent = false;
    country = "";
    isEmailVerified = false;
    isMobileVerified = false;
    isTwoFactorEnabled = false;
  }

  factory AppState() {
    return _appState;
  }

  AppState.fromJson(Map<String, dynamic> json) {
    loginState = json['login_state'];
    isExistingUser = json['is_existing_user'];
    token = json['token'];
    storeId = json['store_id'];
    vatState = json['vat_no_vat'];
    validate_qtySO = json['validate_qty_in_so'];
    discountState = json['discount'];
    attendanceState = json['attendance'];
    printer = json['printer'];
    routeId = json['route_id'];
    userType = json['user_type'];
    // userType = json['rol_id'];
    name = json['name'];
    rolId = json['rol_id'];
    email = json['email'];
    appVersion = json['app_version'];
    buildNumber = json['build_number'];
    userId = json['id'];
    osType = json['os_type'];
    imageUrl = json['image_url'];
    minorVersion = json['minor_version'];
    username = json["username"];
    devices = json["devices"];
    initialConsent = json['initial_consent'];
    country = json['country'];
    isMobileVerified = json['is_mobile_verified'];
    isEmailVerified = json['is_email_verified'];
    isTwoFactorEnabled = json["is_two_factor_enabled"];
    vanId = json["van_id"];
  }

  ////////// retrieve as json to store it in shared preference
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['login_state'] = loginState;
    data['is_existing_user'] = isExistingUser;
    data['token'] = token;
    data['user_type'] = userType;
    data['id'] = userId;
    data['rol_id'] = rolId;
    data['name'] = name;
    data['email'] = email;
    data['store_id'] = storeId;
    data['vat_no_vat'] = vatState;
    data['validate_qty_in_so'] = validate_qtySO;
    data['discount'] = discountState;
    data['attendance'] = attendanceState;
    data['printer'] = printer;
    data['route_id'] = routeId;
    data['app_version'] = appVersion;
    data['build_number'] = buildNumber;
    data['os_type'] = osType;
    data['image_url'] = imageUrl;
    data['minor_version'] = minorVersion;
    data["username"] = username;
    data["devices"] = devices;
    data['initial_consent'] = initialConsent;
    data['country'] = country;
    data['is_mobile_verified'] = isMobileVerified;
    data['is_email_verified'] = isEmailVerified;
    data["is_two_factor_enabled"] = isTwoFactorEnabled;
    data['van_id'] = vanId;
    return data;
  }
}
