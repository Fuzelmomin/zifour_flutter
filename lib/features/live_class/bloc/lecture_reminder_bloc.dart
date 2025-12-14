import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/lecture_reminder_model.dart';
import '../repository/lecture_reminder_repository.dart';

part 'lecture_reminder_event.dart';
part 'lecture_reminder_state.dart';

class LectureReminderBloc
    extends Bloc<LectureReminderEvent, LectureReminderState> {
  LectureReminderBloc({LectureReminderRepository? repository})
      : _repository = repository ?? LectureReminderRepository(),
        super(LectureReminderInitial()) {
    on<AddLectureReminder>(_onAddLectureReminder);
  }

  final LectureReminderRepository _repository;

  Future<void> _onAddLectureReminder(
    AddLectureReminder event,
    Emitter<LectureReminderState> emit,
  ) async {
    emit(LectureReminderLoading());

    final response = await _repository.addLectureReminder(
      lecId: event.lecId,
      reminderDate: event.reminderDate,
      stuId: event.stuId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(LectureReminderSuccess(
        reminder: response.data!,
        message: response.data!.message,
      ));
      return;
    }

    emit(
      LectureReminderError(
        message: response.errorMsg ?? 'Unable to add reminder.',
      ),
    );
  }
}

