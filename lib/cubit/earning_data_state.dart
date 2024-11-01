// earnings_data_state.dart
import 'package:equatable/equatable.dart';
import 'package:ticker_project/model/earning_data.dart';

abstract class EarningsDataState extends Equatable {
  const EarningsDataState();

  @override
  List<Object> get props => [];
}

class EarningsDataLoading extends EarningsDataState {}

class EarningsDataLoaded extends EarningsDataState {
  final List<EarningsData> earningsData;

  const EarningsDataLoaded(this.earningsData);

  @override
  List<Object> get props => [earningsData];
}

class EarningsDataError extends EarningsDataState {
  final String message;

  const EarningsDataError(this.message);

  @override
  List<Object> get props => [message];
}
