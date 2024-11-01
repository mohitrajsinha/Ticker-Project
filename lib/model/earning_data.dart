// earnings_data.dart
class EarningsData {
  final DateTime pricedate;
  final double? actualEps;
  final double? estimatedEps;

  EarningsData({
    required this.pricedate,
    this.actualEps,
    this.estimatedEps,
  });

  factory EarningsData.fromJson(Map<String, dynamic> json) {
    return EarningsData(
      pricedate: DateTime.parse(json['pricedate']),
      actualEps: json['actual_eps']?.toDouble(),
      estimatedEps: json['estimated_eps']?.toDouble(),
    );
  }
}
