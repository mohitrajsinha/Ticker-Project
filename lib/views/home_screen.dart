import 'package:flutter/material.dart';
import 'package:ticker_project/views/earning_comparison_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tickerController = TextEditingController();
  String? errorMessage;

  void _searchTicker() {
    final ticker = _tickerController.text.trim().toUpperCase();
    if (ticker.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a valid company ticker';
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EarningsComparisonScreen(companyTicker: ticker),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _tickerController,
              decoration: InputDecoration(
                labelText: 'Company Ticker',
                hintText: 'Enter a company ticker (e.g., MSFT)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchTicker,
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
