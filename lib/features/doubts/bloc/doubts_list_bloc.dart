import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/doubts_list_model.dart';
import '../repository/doubts_list_repository.dart';

part 'doubts_list_event.dart';
part 'doubts_list_state.dart';

class DoubtsListBloc extends Bloc<DoubtsListEvent, DoubtsListState> {
  DoubtsListBloc({DoubtsListRepository? repository})
      : _repository = repository ?? DoubtsListRepository(),
        super(DoubtsListInitial()) {
    on<DoubtsListRequested>(_onDoubtsListRequested);
  }

  final DoubtsListRepository _repository;

  Future<void> _onDoubtsListRequested(
    DoubtsListRequested event,
    Emitter<DoubtsListState> emit,
  ) async {
    emit(DoubtsListLoading());

    final response = await _repository.fetchDoubtsList();

    if (response.status == ApiStatus.success && response.data != null) {
      emit(DoubtsListSuccess(response.data!));
    } else {
      emit(DoubtsListError(
        response.errorMsg ?? 'Unable to load doubts.',
      ));
    }
  }
}

