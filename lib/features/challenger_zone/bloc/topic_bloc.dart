import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/topic_model.dart';
import '../repository/topic_repository.dart';

part 'topic_event.dart';
part 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  TopicBloc({TopicRepository? repository})
      : _repository = repository ?? TopicRepository(),
        super(TopicState.initial()) {
    on<TopicRequested>(_onRequested);
  }

  final TopicRepository _repository;

  Future<void> _onRequested(
    TopicRequested event,
    Emitter<TopicState> emit,
  ) async {
    emit(state.copyWith(
      status: TopicStatus.loading,
      clearError: true,
    ));

    final response = await _repository.fetchTopics(
      chapterIds: event.chapterIds,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: TopicStatus.success,
        data: response.data,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: TopicStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load topics.',
      ));
    }
  }
}


