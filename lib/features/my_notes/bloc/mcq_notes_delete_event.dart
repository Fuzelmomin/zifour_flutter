part of 'mcq_notes_delete_bloc.dart';

abstract class McqNotesDeleteEvent {
  const McqNotesDeleteEvent();
}

class McqNotesDeleteRequested extends McqNotesDeleteEvent {
  final String mcqId;

  const McqNotesDeleteRequested({
    required this.mcqId,
  });
}

