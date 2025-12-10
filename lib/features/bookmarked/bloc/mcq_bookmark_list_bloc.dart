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
    on<McqBookmarkItemRemoved>(_onItemRemoved);
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

  void _onItemRemoved(
    McqBookmarkItemRemoved event,
    Emitter<McqBookmarkListState> emit,
  ) {
    if (state.data == null) return;

    // Remove item from list locally
    final updatedList = state.data!.mcqBookmarkList
        .where((item) => item.mcqId != event.mcqId)
        .toList();

    final updatedData = McqBookmarkListResponse(
      status: state.data!.status,
      message: state.data!.message,
      mcqBookmarkList: updatedList,
    );

    emit(state.copyWith(
      status: McqBookmarkListStatus.success,
      data: updatedData,
    ));
  }
}

