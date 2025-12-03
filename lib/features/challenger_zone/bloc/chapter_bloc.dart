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
  }

  final ChapterRepository _repository;

  Future<void> _onRequested(
    ChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    emit(state.copyWith(
      status: ChapterStatus.loading,
      clearError: true,
    ));

    final response = await _repository.fetchChapters(subId: event.subId);

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: ChapterStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: ChapterStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load chapters.',
      ));
    }
  }
}

