part of 'submit_mcq_answer_bloc.dart';

enum SubmitMcqAnswerStatus { initial, loading, success, failure }

class SubmitMcqAnswerState {
  final SubmitMcqAnswerStatus status;
  final SubmitMcqAnswerResponse? data;
  final String? errorMessage;

  const SubmitMcqAnswerState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory SubmitMcqAnswerState.initial() =>
      const SubmitMcqAnswerState(status: SubmitMcqAnswerStatus.initial);

  bool get isLoading => status == SubmitMcqAnswerStatus.loading;

  SubmitMcqAnswerState copyWith({
    SubmitMcqAnswerStatus? status,
    SubmitMcqAnswerResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SubmitMcqAnswerState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

