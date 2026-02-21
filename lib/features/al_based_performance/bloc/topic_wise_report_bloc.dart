import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/topic_wise_report_model.dart';
import '../repository/topic_wise_report_repository.dart';

part 'topic_wise_report_event.dart';
part 'topic_wise_report_state.dart';

class TopicWiseReportBloc extends Bloc<TopicWiseReportEvent, TopicWiseReportState> {
  TopicWiseReportBloc({TopicWiseReportRepository? repository})
      : _repository = repository ?? TopicWiseReportRepository(),
        super(TopicWiseReportState.initial()) {
    on<FetchTopicWiseReport>(_onFetchTopicWiseReport);
  }

  final TopicWiseReportRepository _repository;

  Future<void> _onFetchTopicWiseReport(
    FetchTopicWiseReport event,
    Emitter<TopicWiseReportState> emit,
  ) async {
    emit(state.copyWith(status: TopicWiseReportStatus.loading, clearError: true));

    final response = await _repository.fetchTopicWiseReport(event.topicId);

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: TopicWiseReportStatus.success,
        data: response.data,
      ));
    } else {
      emit(state.copyWith(
        status: TopicWiseReportStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load topic report.',
      ));
    }
  }
}
