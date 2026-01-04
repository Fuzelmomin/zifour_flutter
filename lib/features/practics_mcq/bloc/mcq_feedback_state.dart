part of 'mcq_feedback_bloc.dart';

enum McqFeedbackStatus { initial, loading, success, failure }

class McqFeedbackState {
  final McqFeedbackStatus status;
  final McqFeedbackResponse? data;
  final String? errorMessage;

  McqFeedbackState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory McqFeedbackState.initial() {
    return McqFeedbackState(
      status: McqFeedbackStatus.initial,
    );
  }

  bool get isLoading => status == McqFeedbackStatus.loading;

  McqFeedbackState copyWith({
    McqFeedbackStatus? status,
    McqFeedbackResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return McqFeedbackState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
