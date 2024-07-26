class AppConfigJC {
  String? status;
  String? androidVersion;
  String? iosVersion;
  String? features;
  String? backendVersion;
  String? backendFeatures;
  String? webappVersion;
  String? webappFeatures;
  String? forceUpdateRequired;
  String? appUrl;
  String? appId;

  AppConfigJC(
      {this.status,
        this.androidVersion,
        this.iosVersion,
        this.features,
        this.backendVersion,
        this.backendFeatures,
        this.webappVersion,
        this.webappFeatures,
        this.forceUpdateRequired,
        this.appUrl,
        this.appId});

  AppConfigJC.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    androidVersion = json['android_version'];
    iosVersion = json['ios_version'];
    features = json['features'];
    backendVersion = json['backend_version'];
    backendFeatures = json['backend_features'];
    webappVersion = json['webapp_version'];
    webappFeatures = json['webapp_features'];
    forceUpdateRequired = json['force_update_required'];
    appUrl = json['app_url'];
    appId = json['app_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['android_version'] = this.androidVersion;
    data['ios_version'] = this.iosVersion;
    data['features'] = this.features;
    data['backend_version'] = this.backendVersion;
    data['backend_features'] = this.backendFeatures;
    data['webapp_version'] = this.webappVersion;
    data['webapp_features'] = this.webappFeatures;
    data['force_update_required'] = this.forceUpdateRequired;
    data['app_url'] = this.appUrl;
    data['app_id'] = this.appId;
    return data;
  }
}
