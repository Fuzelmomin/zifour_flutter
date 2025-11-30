import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/calendar_event_model.dart';
import '../repository/calendar_event_repository.dart';

part 'calendar_event_event.dart';
part 'calendar_event_state.dart';

class CalendarEventBloc
    extends Bloc<CalendarEventEvent, CalendarEventState> {
  CalendarEventBloc({CalendarEventRepository? repository})
      : _repository = repository ?? CalendarEventRepository(),
        super(CalendarEventInitial()) {
    on<CreateCalendarEvent>(_onCreateCalendarEvent);
  }

  final CalendarEventRepository _repository;

  Future<void> _onCreateCalendarEvent(
    CreateCalendarEvent event,
    Emitter<CalendarEventState> emit,
  ) async {
    emit(CalendarEventLoading());

    final response = await _repository.createEvent(
      studentId: event.studentId,
      date: event.date,
      time: event.time,
      title: event.title,
      description: event.description,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(CalendarEventSuccess(message: response.data!.message));
      return;
    }

    emit(
      CalendarEventError(
        message: response.errorMsg ?? 'Unable to create event.',
      ),
    );
  }
}

