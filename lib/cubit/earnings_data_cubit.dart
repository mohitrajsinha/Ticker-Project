// earnings_data_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticker_project/cubit/earning_data_state.dart';
import 'package:ticker_project/services/api_services.dart';

class EarningsDataCubit extends Cubit<EarningsDataState> {
  final ApiService apiService;
  final String companyTicker;

  EarningsDataCubit(this.apiService, this.companyTicker) : super(EarningsDataLoading());

  void fetchEarningsData() async {
    try {
      final earningsData = await apiService.fetchEarningsData(companyTicker);
      emit(EarningsDataLoaded(earningsData));
    } catch (error) {
      emit(EarningsDataError(error.toString()));
    }
  }
}
