import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticker_project/cubit/earning_data_state.dart';
import 'package:ticker_project/views/earning_transcript_screen.dart';
import '../cubit/earnings_data_cubit.dart';
import '../services/api_services.dart';

class EarningsComparisonScreen extends StatelessWidget {
  final String companyTicker;

  const EarningsComparisonScreen({super.key, required this.companyTicker});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          EarningsDataCubit(ApiService(), companyTicker)..fetchEarningsData(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Earnings Comparison: $companyTicker',
          style: const TextStyle(fontSize: 18),
        )),
        body: BlocBuilder<EarningsDataCubit, EarningsDataState>(
          builder: (context, state) {
            if (state is EarningsDataLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EarningsDataError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is EarningsDataLoaded) {
              final earningsData = state.earningsData;

              List<FlSpot> estimatedSpots = [];
              List<FlSpot> actualSpots = [];

              List<String> uniqueDates = [];
              Map<String, int> dateIndexMap = {};

              for (int i = 0; i < earningsData.length; i++) {
                final data = earningsData[i];
                final dateStr = DateFormat('MMM yyyy').format(data.pricedate);

                if (!dateIndexMap.containsKey(dateStr)) {
                  dateIndexMap[dateStr] = uniqueDates.length;
                  uniqueDates.add(dateStr);
                }
              }

              uniqueDates = uniqueDates.reversed.toList();

              for (int i = 0; i < uniqueDates.length; i++) {
                final dateStr = uniqueDates[i];
                final originalIndex = earningsData.indexWhere((data) =>
                    DateFormat('MMM yyyy').format(data.pricedate) == dateStr);

                if (originalIndex != -1) {
                  final estimatedEps =
                      earningsData[originalIndex].estimatedEps ?? 0.0;
                  final actualEps =
                      earningsData[originalIndex].actualEps ?? 0.0;

                  estimatedSpots.add(FlSpot(i.toDouble(), estimatedEps));
                  actualSpots.add(FlSpot(i.toDouble(), actualEps));
                }
              }

              return Padding(
                padding:
                    const EdgeInsets.only(top: 80.0, left: 20.0, right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            touchCallback: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              if (response != null &&
                                  response.lineBarSpots != null) {
                                final spot = response.lineBarSpots!.first;
                                final selectedDate =
                                    uniqueDates[spot.x.toInt()];
                                DateTime parsedDate =
                                    DateFormat('MMM yyyy').parse(selectedDate);
                                int year = parsedDate.year;
                                int quarter =
                                    ((parsedDate.month - 1) / 3).ceil();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EarningsTranscriptScreen(
                                      companyTicker: companyTicker,
                                      year: year,
                                      quarter: quarter,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              preventCurveOverShooting: true,
                              spots: estimatedSpots,
                              color: Colors.blueAccent,
                              barWidth: 4,
                              isCurved: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.blueAccent,
                                    strokeColor: Colors.blue.shade800,
                                    strokeWidth: 2,
                                  );
                                },
                                checkToShowDot: (spot, _) => true,
                               
                              ),
                            ),
                            LineChartBarData(
                              preventCurveOverShooting: true,
                              spots: actualSpots,
                              color: Colors.green,
                              barWidth: 4,
                              isCurved: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.greenAccent,
                                    strokeColor: Colors.green.shade800,
                                    strokeWidth: 2,
                                  );
                                },
                              ),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text(
                                'Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              sideTitles: SideTitles(
                                interval: 1,
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 &&
                                      index < uniqueDates.length) {
                                    return Text(
                                      uniqueDates[index],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text(
                                'EPS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black54),
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: 12,
                                height: 12,
                                color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            const Text('Estimated EPS',
                                style: TextStyle(color: Colors.blueAccent)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            Container(
                                width: 12, height: 12, color: Colors.green),
                            const SizedBox(width: 8),
                            const Text('Actual EPS',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No earnings data available'));
          },
        ),
      ),
    );
  }
}
