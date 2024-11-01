// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticker_project/model/earning_data.dart';

class ApiService {
  static const String apiUrl = 'https://api.api-ninjas.com/v1/earningscalendar';
  static const String earningsTranscriptUrl =
      'https://api.api-ninjas.com/v1/earningstranscript';
  // static const String apiKey = 'YOUR_API_KEY';  // Replace with your actual API key

  Future<List<EarningsData>> fetchEarningsData(String ticker) async {
    final response = await http.get(
      Uri.parse('$apiUrl?ticker=$ticker'),
    );

    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      return jsonData.map((data) => EarningsData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load earnings data');
    }
  }

  Future<bool> isValidTicker(String ticker) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$ticker'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if data is empty
        if (data != null && data.isNotEmpty) {
          return true; // Ticker is valid
        }
      }
      return false; // Ticker is invalid
    } catch (e) {
      print('Error validating ticker: $e');
      return false; // Error or empty data means invalid ticker
    }
  }

  Future<String> fetchEarningsTranscript(
      String ticker, int year, int quarter) async {
    final response = await http.get(
      Uri.parse(
          '$earningsTranscriptUrl?ticker=$ticker&year=$year&quarter=$quarter'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['transcript'];
    } else {
      throw Exception('Failed to load earnings transcript');
    }
  }
}
