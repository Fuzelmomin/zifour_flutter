import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/chapter_model.dart';
import '../repository/chapter_repository.dart';

part 'chapter_event.dart';
part 'chapter_state.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  ChapterBloc({ChapterRepository? repository})
      : _repository = repository ?? ChapterRepository(),
        super(ChapterState.initial()) {
    on<ChapterRequested>(_onRequested);
    on<ChapterRemoveRequested>(_onRemoveRequested);
  }

  final ChapterRepository _repository;

  Future<void> _onRequested(
    ChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    // Keep current chapters if they exist
    final currentChapters = state.data?.chapterList ?? [];

    emit(state.copyWith(
      status: ChapterStatus.loading,
      clearError: true,
    ));

    final response = await _repository.fetchChapters(subId: event.subId);

    if (response.status == ApiStatus.success && response.data != null) {
      // Append new chapters to existing list
      final newChapters = response.data!.chapterList;
      final mergedChapters = [...currentChapters, ...newChapters];

      emit(state.copyWith(
        status: ChapterStatus.success,
        data: ChapterResponse(
          status: true,
          message: response.data!.message,
          chapterList: mergedChapters,
        ),
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: ChapterStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load chapters.',
      ));
    }
  }

  void _onRemoveRequested(
    ChapterRemoveRequested event,
    Emitter<ChapterState> emit,
  ) {
    if (state.data != null) {
      final filteredChapters = state.data!.chapterList
          .where((chapter) => chapter.subId != event.subId)
          .toList();

      emit(state.copyWith(
        status: ChapterStatus.success,
        data: ChapterResponse(
          status: true,
          message: state.data!.message,
          chapterList: filteredChapters,
        ),
      ));
    }
  }
}

