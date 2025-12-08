import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mcq_bookmark_delete_model.dart';
import '../repository/mcq_bookmark_delete_repository.dart';

part 'mcq_bookmark_delete_event.dart';
part 'mcq_bookmark_delete_state.dart';

class McqBookmarkDeleteBloc
    extends Bloc<McqBookmarkDeleteEvent, McqBookmarkDeleteState> {
  McqBookmarkDeleteBloc({McqBookmarkDeleteRepository? repository})
      : _repository = repository ?? McqBookmarkDeleteRepository(),
        super(McqBookmarkDeleteState.initial()) {
    on<McqBookmarkDeleteRequested>(_onRequested);
  }

  final McqBookmarkDeleteRepository _repository;

  Future<void> _onRequested(
    McqBookmarkDeleteRequested event,
    Emitter<McqBookmarkDeleteState> emit,
  ) async {
    emit(state.copyWith(
      status: McqBookmarkDeleteStatus.loading,
      clearError: true,
    ));

    final response = await _repository.deleteMcqBookmark(
      mcqId: event.mcqId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: McqBookmarkDeleteStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: McqBookmarkDeleteStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to delete bookmark.',
      ));
    }
  }
}

