import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/mcq_bookmark_list_model.dart';
import '../repository/mcq_bookmark_list_repository.dart';

part 'mcq_bookmark_list_event.dart';
part 'mcq_bookmark_list_state.dart';

class McqBookmarkListBloc
    extends Bloc<McqBookmarkListEvent, McqBookmarkListState> {
  McqBookmarkListBloc({McqBookmarkListRepository? repository})
      : _repository = repository ?? McqBookmarkListRepository(),
        super(McqBookmarkListState.initial()) {
    on<McqBookmarkListRequested>(_onRequested);
  }

  final McqBookmarkListRepository _repository;

  Future<void> _onRequested(
    McqBookmarkListRequested event,
    Emitter<McqBookmarkListState> emit,
  ) async {
    emit(state.copyWith(
      status: McqBookmarkListStatus.loading,
      clearError: true,
    ));

    final response = await _repository.getMcqBookmarkList();

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: McqBookmarkListStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: McqBookmarkListStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load bookmarks.',
      ));
    }
  }
}

