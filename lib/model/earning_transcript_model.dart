class EarningTranscript {
    final String ticker;
    final String year;
    final String quarter;

    EarningTranscript({
        required this.ticker,
        required this.year,
        required this.quarter,
    });

    factory EarningTranscript.fromJson(Map<String, dynamic> json) => EarningTranscript(
        ticker: json["ticker"],
        year: json["year"],
        quarter: json["quarter"],
    );

    Map<String, dynamic> toJson() => {
        "ticker": ticker,
        "year": year,
        "quarter": quarter,
    };
}