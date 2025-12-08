part of 'mcq_bookmark_delete_bloc.dart';

enum McqBookmarkDeleteStatus { initial, loading, success, failure }

class McqBookmarkDeleteState {
  final McqBookmarkDeleteStatus status;
  final McqBookmarkDeleteResponse? data;
  final String? errorMessage;

  const McqBookmarkDeleteState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory McqBookmarkDeleteState.initial() =>
      const McqBookmarkDeleteState(status: McqBookmarkDeleteStatus.initial);

  bool get isLoading => status == McqBookmarkDeleteStatus.loading;

  McqBookmarkDeleteState copyWith({
    McqBookmarkDeleteStatus? status,
    McqBookmarkDeleteResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return McqBookmarkDeleteState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

