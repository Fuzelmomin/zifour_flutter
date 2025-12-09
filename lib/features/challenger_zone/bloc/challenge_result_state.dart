part of 'challenge_result_bloc.dart';

enum ChallengeResultStatus {
  initial,
  loading,
  success,
  failure,
}

class ChallengeResultState {
  final ChallengeResultStatus status;
  final ChallengeResultResponse? data;
  final String? errorMessage;

  const ChallengeResultState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory ChallengeResultState.initial() {
    return const ChallengeResultState(
      status: ChallengeResultStatus.initial,
    );
  }

  ChallengeResultState copyWith({
    ChallengeResultStatus? status,
    ChallengeResultResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChallengeResultState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
