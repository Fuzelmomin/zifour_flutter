import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/calendar_events_list_model.dart';
import '../repository/get_calender_events_repository.dart';

part 'get_calender_events_event.dart';
part 'get_calender_events_state.dart';

class GetCalenderEventsBloc
    extends Bloc<GetCalenderEventsEvent, GetCalenderEventsState> {
  GetCalenderEventsBloc({GetCalenderEventsRepository? repository})
      : _repository = repository ?? GetCalenderEventsRepository(),
        super(GetCalenderEventsInitial()) {
    on<FetchCalenderEvents>(_onFetchCalenderEvents);
  }

  final GetCalenderEventsRepository _repository;

  Future<void> _onFetchCalenderEvents(
    FetchCalenderEvents event,
    Emitter<GetCalenderEventsState> emit,
  ) async {
    emit(GetCalenderEventsLoading());

    final response = await _repository.getEvents(studentId: event.studentId);

    if (response.status == ApiStatus.success && response.data != null) {
      final events = response.data!.calevtList ?? [];
      emit(GetCalenderEventsSuccess(events: events));
      return;
    }

    emit(
      GetCalenderEventsError(
        message: response.errorMsg ?? 'Unable to load events.',
      ),
    );
  }
}
