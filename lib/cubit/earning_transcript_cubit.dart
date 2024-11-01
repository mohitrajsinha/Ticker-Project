// earnings_transcript_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticker_project/cubit/earning_transacript_state.dart';
import 'package:ticker_project/services/api_services.dart';

class EarningsTranscriptCubit extends Cubit<EarningsTranscriptState> {
  final ApiService apiService;

  EarningsTranscriptCubit(this.apiService) : super(EarningsTranscriptLoading());

  void fetchEarningsTranscript(String companyTicker, int year, int quarter) async {
    try {
      final transcript = await apiService.fetchEarningsTranscript(companyTicker, year, quarter);
      emit(EarningsTranscriptLoaded(transcript));
    } catch (error) {
      emit(EarningsTranscriptError(error.toString()));
    }
  }
}
