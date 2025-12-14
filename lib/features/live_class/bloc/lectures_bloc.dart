import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/lectures_model.dart';
import '../repository/lectures_repository.dart';

part 'lectures_event.dart';
part 'lectures_state.dart';

class LecturesBloc extends Bloc<LecturesEvent, LecturesState> {
  LecturesBloc({LecturesRepository? repository})
      : _repository = repository ?? LecturesRepository(),
        super(LecturesInitial()) {
    on<FetchLectures>(_onFetchLectures);
  }

  final LecturesRepository _repository;

  Future<void> _onFetchLectures(
    FetchLectures event,
    Emitter<LecturesState> emit,
  ) async {
    emit(LecturesLoading());

    final response = await _repository.getLectures(
      chpId: event.chpId,
      tpcId: event.tpcId,
      subId: event.subId,
      stuId: event.stuId,
      medId: event.medId,
      exmId: event.exmId,
      lvCls: event.lvCls,
      lecSample: event.lecSample,
      lecRept: event.lecRept,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      final lectures = response.data!.lectureList ?? [];
      emit(LecturesSuccess(
        lectures: lectures,
        chpTitle: response.data!.chpTitle,
        testBtn: response.data!.testBtn,
        message: response.data!.message,
      ));
      return;
    }

    emit(
      LecturesError(
        message: response.errorMsg ?? 'Unable to load lectures.',
      ),
    );
  }
}

