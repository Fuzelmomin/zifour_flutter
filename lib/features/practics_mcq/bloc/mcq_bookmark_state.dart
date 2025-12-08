part of 'mcq_bookmark_bloc.dart';

enum McqBookmarkStatus { initial, loading, success, failure }

class McqBookmarkState {
  final McqBookmarkStatus status;
  final McqBookmarkResponse? data;
  final String? errorMessage;

  const McqBookmarkState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory McqBookmarkState.initial() =>
      const McqBookmarkState(status: McqBookmarkStatus.initial);

  bool get isLoading => status == McqBookmarkStatus.loading;

  McqBookmarkState copyWith({
    McqBookmarkStatus? status,
    McqBookmarkResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return McqBookmarkState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

