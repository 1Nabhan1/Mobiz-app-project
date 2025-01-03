// class SalesReport {
//   final int todaySale;
//   final int weekSale;
//   final int monthSale;
//   final int beforeThisMonthSale;
//   final int totalSale;
//
//   SalesReport({
//     required this.todaySale,
//     required this.weekSale,
//     required this.monthSale,
//     required this.beforeThisMonthSale,
//     required this.totalSale,
//   });
//
//   factory SalesReport.fromJson(Map<String, dynamic> json) {
//     return SalesReport(
//       todaySale: json['today_sale'],
//       weekSale: json['week_sale'],
//       monthSale: json['month_sale'],
//       beforeThisMonthSale: json['befor_this_month_sale'],
//       totalSale: json['total_sale'],
//     );
//   }
// }
class SalesReport {
  final int todaySale;
  final int weekSale;
  final int monthSale;
  final int beforeThisMonthSale;
  final int totalSale;

  SalesReport({
    required this.todaySale,
    required this.weekSale,
    required this.monthSale,
    required this.beforeThisMonthSale,
    required this.totalSale,
  });

  factory SalesReport.fromJson(Map<String, dynamic> json) {
    return SalesReport(
      todaySale: (json['today_sale'] as num).toInt(),
      weekSale: (json['week_sale'] as num).toInt(),
      monthSale: (json['month_sale'] as num).toInt(),
      beforeThisMonthSale: (json['befor_this_month_sale'] as num).toInt(),
      totalSale: (json['total_sale'] as num).toInt(),
    );
  }
}
