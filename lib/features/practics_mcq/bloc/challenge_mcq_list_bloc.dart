import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/challenge_mcq_list_model.dart';
import '../repository/challenge_mcq_list_repository.dart';

part 'challenge_mcq_list_event.dart';
part 'challenge_mcq_list_state.dart';

class ChallengeMcqListBloc
    extends Bloc<ChallengeMcqListEvent, ChallengeMcqListState> {
  ChallengeMcqListBloc({ChallengeMcqListRepository? repository})
      : _repository = repository ?? ChallengeMcqListRepository(),
        super(ChallengeMcqListState.initial()) {
    on<ChallengeMcqListRequested>(_onRequested);
  }

  final ChallengeMcqListRepository _repository;

  Future<void> _onRequested(
    ChallengeMcqListRequested event,
    Emitter<ChallengeMcqListState> emit,
  ) async {
    emit(state.copyWith(
      status: ChallengeMcqListStatus.loading,
      clearError: true,
    ));

    final response = await _repository.fetchMcqList(
      crtChlId: event.crtChlId,
    apiType: event.apiType,
    sampleTest: event.sampleTest,
    topicId: event.topicId,
    pkId: event.pkId,
    paperId: event.paperId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: ChallengeMcqListStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: ChallengeMcqListStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load MCQs.',
      ));
    }
  }
}

