part of 'mcq_bookmark_list_bloc.dart';

enum McqBookmarkListStatus { initial, loading, success, failure }

class McqBookmarkListState {
  final McqBookmarkListStatus status;
  final McqBookmarkListResponse? data;
  final String? errorMessage;

  const McqBookmarkListState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory McqBookmarkListState.initial() =>
      const McqBookmarkListState(status: McqBookmarkListStatus.initial);

  bool get isLoading => status == McqBookmarkListStatus.loading;
  bool get hasData => data != null && data!.mcqBookmarkList.isNotEmpty;

  McqBookmarkListState copyWith({
    McqBookmarkListStatus? status,
    McqBookmarkListResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return McqBookmarkListState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

