part of 'challenge_details_bloc.dart';

enum ChallengeDetailsStatus { initial, loading, success, failure }

class ChallengeDetailsState {
  final ChallengeDetailsStatus status;
  final ChallengeDetailsResponse? data;
  final String? errorMessage;

  const ChallengeDetailsState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory ChallengeDetailsState.initial() =>
      const ChallengeDetailsState(status: ChallengeDetailsStatus.initial);

  bool get isLoading => status == ChallengeDetailsStatus.loading;
  // Details should be shown even if total_mcq is 0 (API can return 0 initially)
  bool get hasData => data != null;

  ChallengeDetailsState copyWith({
    ChallengeDetailsStatus? status,
    ChallengeDetailsResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChallengeDetailsState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}


