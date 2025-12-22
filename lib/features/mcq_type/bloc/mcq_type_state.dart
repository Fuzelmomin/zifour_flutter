part of 'mcq_type_bloc.dart';

enum McqTypeStatus {
  initial,
  loading,
  success,
  failure,
}

class McqTypeState {
  final McqTypeStatus status;
  final McqTypeResponse? data;
  final String? errorMessage;

  const McqTypeState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory McqTypeState.initial() {
    return const McqTypeState(
      status: McqTypeStatus.initial,
    );
  }

  McqTypeState copyWith({
    McqTypeStatus? status,
    McqTypeResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return McqTypeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
