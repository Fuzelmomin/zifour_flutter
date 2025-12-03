part of 'chapter_bloc.dart';

enum ChapterStatus { initial, loading, success, failure }

class ChapterState {
  final ChapterStatus status;
  final ChapterResponse? data;
  final String? errorMessage;

  const ChapterState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory ChapterState.initial() => const ChapterState(status: ChapterStatus.initial);

  bool get isLoading => status == ChapterStatus.loading;
  bool get hasData => data != null && data!.chapterList.isNotEmpty;

  ChapterState copyWith({
    ChapterStatus? status,
    ChapterResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChapterState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

