part of 'update_challenge_bloc.dart';

enum UpdateChallengeStatus { initial, loading, success, failure }

class UpdateChallengeState {
  final UpdateChallengeStatus status;
  final UpdateChallengeResponse? data;
  final String? errorMessage;

  const UpdateChallengeState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory UpdateChallengeState.initial() =>
      const UpdateChallengeState(status: UpdateChallengeStatus.initial);

  bool get isLoading => status == UpdateChallengeStatus.loading;

  UpdateChallengeState copyWith({
    UpdateChallengeStatus? status,
    UpdateChallengeResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UpdateChallengeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

