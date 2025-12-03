part of 'challenge_mcq_list_bloc.dart';

enum ChallengeMcqListStatus { initial, loading, success, failure }

class ChallengeMcqListState {
  final ChallengeMcqListStatus status;
  final ChallengeMcqListResponse? data;
  final String? errorMessage;

  const ChallengeMcqListState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory ChallengeMcqListState.initial() =>
      const ChallengeMcqListState(status: ChallengeMcqListStatus.initial);

  bool get isLoading => status == ChallengeMcqListStatus.loading;
  bool get hasData => data != null && data!.mcqList.isNotEmpty;

  ChallengeMcqListState copyWith({
    ChallengeMcqListStatus? status,
    ChallengeMcqListResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChallengeMcqListState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

