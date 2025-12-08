part of 'mcq_notes_bloc.dart';

abstract class McqNotesEvent {
  const McqNotesEvent();
}

class McqNotesRequested extends McqNotesEvent {
  final String mcqId;
  final String mcqNotesTitle;
  final String mcqNotesDescription;

  const McqNotesRequested({
    required this.mcqId,
    required this.mcqNotesTitle,
    required this.mcqNotesDescription,
  });
}

