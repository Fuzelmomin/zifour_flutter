part of 'challenges_list_bloc.dart';

enum ChallengesListStatus { initial, loading, success, failure }

class ChallengesListState {
  final ChallengesListStatus status;
  final ChallengesListResponse? data;
  final String? errorMessage;

  const ChallengesListState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory ChallengesListState.initial() =>
      const ChallengesListState(status: ChallengesListStatus.initial);

  bool get isLoading => status == ChallengesListStatus.loading;
  bool get hasData => data != null && data!.data.isNotEmpty;

  ChallengesListState copyWith({
    ChallengesListStatus? status,
    ChallengesListResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChallengesListState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

