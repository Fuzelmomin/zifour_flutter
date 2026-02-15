import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/overall_report_model.dart';
import '../repository/overall_report_repository.dart';

part 'overall_report_event.dart';
part 'overall_report_state.dart';

class OverallReportBloc extends Bloc<OverallReportEvent, OverallReportState> {
  OverallReportBloc({OverallReportRepository? repository})
      : _repository = repository ?? OverallReportRepository(),
        super(OverallReportState.initial()) {
    on<FetchOverallReport>(_onFetchOverallReport);
  }

  final OverallReportRepository _repository;

  Future<void> _onFetchOverallReport(
    FetchOverallReport event,
    Emitter<OverallReportState> emit,
  ) async {
    emit(state.copyWith(status: OverallReportStatus.loading, clearError: true));

    final response = await _repository.fetchOverallReport();

    if (response.status == ApiStatus.success && response.data != null) {
      emit(state.copyWith(
        status: OverallReportStatus.success,
        data: response.data,
      ));
    } else {
      emit(state.copyWith(
        status: OverallReportStatus.failure,
        errorMessage: response.errorMsg ?? 'Unable to load report.',
      ));
    }
  }
}
