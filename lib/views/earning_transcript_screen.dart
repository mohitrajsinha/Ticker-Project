
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticker_project/cubit/earning_transacript_state.dart';
import 'package:ticker_project/cubit/earning_transcript_cubit.dart';
import 'package:ticker_project/services/api_services.dart';

class EarningsTranscriptScreen extends StatelessWidget {
  final String companyTicker;
  final int year;
  final int quarter;

  const EarningsTranscriptScreen({
    super.key,
    required this.companyTicker,
    required this.year,
    required this.quarter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EarningsTranscriptCubit(ApiService())
        ..fetchEarningsTranscript(companyTicker, year, quarter),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Earnings Transcript: $companyTicker',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        body: BlocBuilder<EarningsTranscriptCubit, EarningsTranscriptState>(
          builder: (context, state) {
            if (state is EarningsTranscriptLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EarningsTranscriptError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is EarningsTranscriptLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(child: Text(state.transcript)),
              );
            }
            return const Center(child: Text('No transcript available'));
          },
        ),
      ),
    );
  }
}
