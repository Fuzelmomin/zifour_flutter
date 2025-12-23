import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/core/api_models/api_status.dart';
import 'package:zifour_sourcecode/features/india_test_series/model/online_test_paper_model.dart';
import 'package:zifour_sourcecode/features/india_test_series/repository/india_test_series_repository.dart';

part 'online_test_paper_event.dart';
part 'online_test_paper_state.dart';

class OnlineTestPaperBloc extends Bloc<OnlineTestPaperEvent, OnlineTestPaperState> {
  final IndiaTestSeriesRepository _repository;

  OnlineTestPaperBloc({IndiaTestSeriesRepository? repository})
      : _repository = repository ?? IndiaTestSeriesRepository(),
        super(OnlineTestPaperState.initial()) {
    on<OnlineTestPaperRequested>(_onRequested);
  }

  Future<void> _onRequested(
    OnlineTestPaperRequested event,
    Emitter<OnlineTestPaperState> emit,
  ) async {
    emit(state.copyWith(
      status: OnlineTestPaperStatus.loading,
      clearError: true,
    ));

    final response = await _repository.fetchOnlineTestPapers(event.pkId);

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: OnlineTestPaperStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: OnlineTestPaperStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load test papers.',
      ));
    }
  }
}
