import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/subject_wise_report_model.dart';
import '../repository/subject_wise_report_repository.dart';

part 'subject_wise_report_event.dart';
part 'subject_wise_report_state.dart';

class SubjectWiseReportBloc extends Bloc<SubjectWiseReportEvent, SubjectWiseReportState> {
  SubjectWiseReportBloc({SubjectWiseReportRepository? repository})
      : _repository = repository ?? SubjectWiseReportRepository(),
        super(SubjectWiseReportState.initial()) {
    on<FetchSubjectWiseReport>(_onFetchSubjectWiseReport);
  }

  final SubjectWiseReportRepository _repository;

  Future<void> _onFetchSubjectWiseReport(
    FetchSubjectWiseReport event,
    Emitter<SubjectWiseReportState> emit,
  ) async {
    emit(state.copyWith(status: SubjectWiseReportStatus.loading, clearError: true));

    final response = await _repository.fetchSubjectWiseReport(event.subjectId);

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: SubjectWiseReportStatus.success,
        data: response.data,
      ));
    } else {
      emit(state.copyWith(
        status: SubjectWiseReportStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load subject report.',
      ));
    }
  }
}
