import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mcq_bookmark_model.dart';
import '../repository/mcq_bookmark_repository.dart';

part 'mcq_bookmark_event.dart';
part 'mcq_bookmark_state.dart';

class McqBookmarkBloc extends Bloc<McqBookmarkEvent, McqBookmarkState> {
  McqBookmarkBloc({McqBookmarkRepository? repository})
      : _repository = repository ?? McqBookmarkRepository(),
        super(McqBookmarkState.initial()) {
    on<McqBookmarkRequested>(_onRequested);
  }

  final McqBookmarkRepository _repository;

  Future<void> _onRequested(
    McqBookmarkRequested event,
    Emitter<McqBookmarkState> emit,
  ) async {
    emit(state.copyWith(
      status: McqBookmarkStatus.loading,
      clearError: true,
    ));

    final response = await _repository.addMcqBookmark(
      mcqId: event.mcqId,
      mcqType: event.mcqType,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: McqBookmarkStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: McqBookmarkStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to add bookmark.',
      ));
    }
  }
}

