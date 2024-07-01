class SOAResponse {
  final List<List<dynamic>> data;
  final double opening;
  final double closing;
  final bool success;
  final List<String> messages;

  SOAResponse({
    required this.data,
    required this.opening,
    required this.closing,
    required this.success,
    required this.messages,
  });

  factory SOAResponse.fromJson(Map<String, dynamic> json) {
    return SOAResponse(
      data: List<List<dynamic>>.from(json['data'].map((item) => List<dynamic>.from(item.map((e) => e)))),
      opening: (json['opening'] as num).toDouble(),
      closing: (json['closing'] as num).toDouble(),
      success: json['success'] as bool,
      messages: List<String>.from(json['messages'].map((x) => x as String)),
    );
  }
}

class SOAData {
  final String date;
  final String reference;
  final String amount;
  final String payment;
  final String balance;

  SOAData({
    required this.date,
    required this.reference,
    required this.amount,
    required this.payment,
    required this.balance,
  });

  factory SOAData.fromJson(Map<String, dynamic> json) {
    return SOAData(
      date: json['date'] ?? '',
      reference: json['reference'] ?? '',
      amount: json['amount'].toString(), // Convert to string
      payment: json['payment'].toString(), // Convert to string
      balance: json['balance'].toString(), // Convert to string
    );
  }
}