part of 'subject_bloc.dart';

enum SubjectStatus { initial, loading, success, failure }

class SubjectState {
  final SubjectStatus status;
  final SubjectResponse? data;
  final String? errorMessage;

  const SubjectState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory SubjectState.initial() => const SubjectState(status: SubjectStatus.initial);

  SubjectState copyWith({
    SubjectStatus? status,
    SubjectResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SubjectState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

