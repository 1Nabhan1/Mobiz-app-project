class StoreDetail {
  final int id;
  final String code;
  final String name;
  final String email;
  final String? address;
  final String? emirate;
  final String? country;
  final String? contactNumber;
  final String? whatsappNumber;
  final String? trn;
  final String? subscriptionEndDate;
  final String? createdAt;
  final String? updatedAt;
  final String? currency;
  final String? logos; // List of image URLs

  StoreDetail({
    required this.id,
    required this.code,
    required this.name,
    required this.email,
    this.address,
    this.emirate,
    this.country,
    this.contactNumber,
    this.whatsappNumber,
    this.trn,
    this.subscriptionEndDate,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.logos, // Include this field in constructor
  });

  factory StoreDetail.fromJson(Map<String, dynamic> json) {
    // Parse logos as a list of strings
    // List<String> logosList = [];
    // if (json['data']['logos'] != null) {
    //   for (var logo in json['data']['logos']) {
    //     logosList.add(logo.toString());
    //   }
    // }

    return StoreDetail(
      id: json['data']['id'],
      code: json['data']['code'],
      name: json['data']['name'],
      email: json['data']['email'],
      address: json['data']['address'],
      emirate: json['data']['emirate'],
      country: json['data']['country'],
      contactNumber: json['data']['contact_number'],
      whatsappNumber: json['data']['whatsapp_number'],
      trn: json['data']['trn'],
      subscriptionEndDate: json['data']['subscription_end_date'],
      createdAt: json['data']['created_at'],
      updatedAt: json['data']['updated_at'],
      currency: json['data']['currency'],
      logos: json['data']['logo'], // Assign logos field from JSON
    );
  }
}