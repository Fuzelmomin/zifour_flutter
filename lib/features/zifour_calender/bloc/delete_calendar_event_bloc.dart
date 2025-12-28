import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/delete_calendar_event_repository.dart';
import '../../../core/api_models/api_status.dart';

// Events
abstract class DeleteCalendarEventEvent {}

class PerformDeleteCalendarEvent extends DeleteCalendarEventEvent {
  final String studentId;
  final String eventId;

  PerformDeleteCalendarEvent({required this.studentId, required this.eventId});
}

// States
abstract class DeleteCalendarEventState {}

class DeleteCalendarEventInitial extends DeleteCalendarEventState {}

class DeleteCalendarEventLoading extends DeleteCalendarEventState {}

class DeleteCalendarEventSuccess extends DeleteCalendarEventState {
  final String message;
  final String eventId;

  DeleteCalendarEventSuccess({required this.message, required this.eventId});
}

class DeleteCalendarEventError extends DeleteCalendarEventState {
  final String message;

  DeleteCalendarEventError({required this.message});
}

// BLoC
class DeleteCalendarEventBloc
    extends Bloc<DeleteCalendarEventEvent, DeleteCalendarEventState> {
  final DeleteCalendarEventRepository repository;

  DeleteCalendarEventBloc({DeleteCalendarEventRepository? repository})
      : this.repository = repository ?? DeleteCalendarEventRepository(),
        super(DeleteCalendarEventInitial()) {
    on<PerformDeleteCalendarEvent>(_onDeleteEvent);
  }

  Future<void> _onDeleteEvent(
    PerformDeleteCalendarEvent event,
    Emitter<DeleteCalendarEventState> emit,
  ) async {
    emit(DeleteCalendarEventLoading());

    final response = await repository.deleteEvent(
      studentId: event.studentId,
      eventId: event.eventId,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(DeleteCalendarEventSuccess(
        message: response.data!.message,
        eventId: event.eventId,
      ));
    } else {
      emit(DeleteCalendarEventError(
        message: response.errorMsg ?? 'Failed to delete event',
      ));
    }
  }
}
