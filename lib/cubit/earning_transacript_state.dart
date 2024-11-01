// earnings_transcript_state.dart
import 'package:equatable/equatable.dart';

abstract class EarningsTranscriptState extends Equatable {
  const EarningsTranscriptState();

  @override
  List<Object> get props => [];
}

class EarningsTranscriptLoading extends EarningsTranscriptState {}

class EarningsTranscriptLoaded extends EarningsTranscriptState {
  final String transcript;

  const EarningsTranscriptLoaded(this.transcript);

  @override
  List<Object> get props => [transcript];
}

class EarningsTranscriptError extends EarningsTranscriptState {
  final String message;

  const EarningsTranscriptError(this.message);

  @override
  List<Object> get props => [message];
}
