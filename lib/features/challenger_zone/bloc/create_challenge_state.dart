part of 'create_challenge_bloc.dart';

enum CreateChallengeStatus { initial, loading, success, failure }

class CreateChallengeState {
  final CreateChallengeStatus status;
  final CreateChallengeResponse? data;
  final String? errorMessage;

  const CreateChallengeState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory CreateChallengeState.initial() =>
      const CreateChallengeState(status: CreateChallengeStatus.initial);

  bool get isLoading => status == CreateChallengeStatus.loading;

  CreateChallengeState copyWith({
    CreateChallengeStatus? status,
    CreateChallengeResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateChallengeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}


