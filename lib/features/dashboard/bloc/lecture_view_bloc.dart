import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/lecture_view_model.dart';
import '../repository/lecture_view_repository.dart';

part 'lecture_view_event.dart';
part 'lecture_view_state.dart';

class LectureViewBloc extends Bloc<LectureViewEvent, LectureViewState> {
  LectureViewBloc({LectureViewRepository? repository})
      : _repository = repository ?? LectureViewRepository(),
        super(LectureViewInitial()) {
    on<MarkLectureAsViewed>(_onMarkLectureAsViewed);
  }

  final LectureViewRepository _repository;

  Future<void> _onMarkLectureAsViewed(
    MarkLectureAsViewed event,
    Emitter<LectureViewState> emit,
  ) async {
    // Don't emit loading state for silent API call
    final response = await _repository.markLectureAsViewed(
      lecId: event.lecId,
      stuId: event.stuId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(LectureViewSuccess(
        message: response.data!.message,
      ));
      return;
    }

    // Silent failure - don't emit error state
    emit(LectureViewInitial());
  }
}

